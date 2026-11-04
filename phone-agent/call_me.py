#!/usr/bin/env python3
"""
call_me.py — an AI agent that phones you and holds a real conversation.

  Twilio  = the phone line (places the call, speech-to-text, text-to-speech)
  Claude  = the brain (decides what to say each turn, and when to hang up)

Two modes:

  python call_me.py say "Your build finished."      # one-way spoken message, no server needed
  python call_me.py talk                             # two-way AI conversation (needs PUBLIC_URL)
  python call_me.py talk --goal "Remind me about the dentist and confirm I'll go"

Configuration comes from environment variables (see .env.example).
"""
from __future__ import annotations

import argparse
import os
import sys
import threading
from xml.sax.saxutils import escape

import anthropic
from flask import Flask, Response, abort, request
from twilio.request_validator import RequestValidator
from twilio.rest import Client as TwilioClient
from twilio.twiml.voice_response import Gather, VoiceResponse

# ----------------------------------------------------------------------------- config

def env(name: str, default: str | None = None, required: bool = True) -> str:
    val = os.environ.get(name, default)
    if required and not val:
        sys.exit(f"Missing required environment variable: {name}  (see phone-agent/.env.example)")
    return val or ""


MODEL = os.environ.get("AGENT_MODEL", "claude-opus-5-5")
# Phone calls are latency-sensitive: every turn the caller waits in silence while
# Claude thinks. "low" keeps replies snappy; raise to "medium" for harder tasks.
EFFORT = os.environ.get("AGENT_EFFORT", "low")
VOICE = os.environ.get("TWILIO_VOICE", "Polly.Joanna-Neural")
MAX_TURNS = int(os.environ.get("MAX_TURNS", "20"))
HANGUP_TOKEN = "[HANGUP]"

SYSTEM_PROMPT = f"""You are a friendly AI assistant speaking to the user over a live phone call
that you placed to them. Everything you write is converted to speech, so:
- Speak naturally and briefly: one to three short sentences per turn.
- No markdown, lists, emoji, URLs, or symbols that don't read aloud well.
- If you didn't catch what they said, ask them to repeat it.
- When the conversation's purpose is done, or the user says goodbye or asks you
  to hang up, say a short goodbye and end your message with {HANGUP_TOKEN}

The purpose of this call: {{goal}}"""

DEFAULT_GOAL = ("Introduce yourself as the user's AI agent, confirm the call works, "
                "and chat about whatever they want until they say goodbye.")

# ----------------------------------------------------------------------------- Claude

claude = anthropic.Anthropic()  # reads ANTHROPIC_API_KEY (or an `ant auth login` profile)

# CallSid -> list of Messages API turns. In-memory: fine for a personal agent.
conversations: dict[str, list] = {}
goals: dict[str, str] = {}
lock = threading.Lock()


def claude_reply(call_sid: str, user_text: str) -> tuple[str, bool]:
    """Append the caller's words, ask Claude for the next line. Returns (speech, hang_up)."""
    with lock:
        history = conversations.setdefault(call_sid, [])
        history.append({"role": "user", "content": user_text})
        goal = goals.get(call_sid, DEFAULT_GOAL)

    try:
        response = claude.beta.messages.create(
            model=MODEL,
            max_tokens=1024,
            system=SYSTEM_PROMPT.format(goal=goal),
            messages=history,
            output_config={"effort": EFFORT},
            # If a safety classifier declines, re-run on a fallback model instead of going silent.
            betas=["server-side-fallback-2026-07-01"],
            fallbacks="default",
        )
    except anthropic.APIError as e:
        print(f"[claude] API error: {e}", file=sys.stderr)
        history.pop()  # keep history append-only and consistent for a retry
        return "Sorry, I'm having trouble thinking right now. Let's talk later. Goodbye!", True

    if response.stop_reason == "refusal":
        history.pop()
        return "Sorry, I can't help with that one. Anything else?", False

    # Append the full content (incl. thinking blocks) unchanged: history stays append-only.
    with lock:
        history.append({"role": "assistant", "content": response.content})

    text = " ".join(b.text for b in response.content if b.type == "text").strip()
    hang_up = HANGUP_TOKEN in text
    text = text.replace(HANGUP_TOKEN, "").strip() or "Goodbye!"
    return text, hang_up


# ----------------------------------------------------------------------------- Twilio webhooks

app = Flask(__name__)


def require_twilio_signature() -> None:
    """Reject requests that weren't signed by Twilio (anyone can hit a public URL)."""
    validator = RequestValidator(env("TWILIO_AUTH_TOKEN"))
    public_url = env("PUBLIC_URL").rstrip("/")
    url = public_url + request.full_path.rstrip("?")
    if not validator.validate(url, request.form, request.headers.get("X-Twilio-Signature", "")):
        abort(403)


def gather_twiml(say_text: str) -> str:
    vr = VoiceResponse()
    g = Gather(input="speech", action="/turn", method="POST",
               speech_timeout="auto", speech_model="phone_call", action_on_empty_result=True)
    g.say(say_text, voice=VOICE)
    vr.append(g)
    # If Gather times out with nothing, Twilio falls through to here.
    vr.redirect("/turn", method="POST")
    return str(vr)


@app.post("/voice")
def voice():
    """Twilio hits this when the user picks up."""
    require_twilio_signature()
    call_sid = request.form["CallSid"]
    opening, hang_up = claude_reply(call_sid, "(The user just answered the phone. Greet them.)")
    if hang_up:
        return Response(f'<Response><Say voice="{VOICE}">{escape(opening)}</Say><Hangup/></Response>',
                        mimetype="text/xml")
    return Response(gather_twiml(opening), mimetype="text/xml")


@app.post("/turn")
def turn():
    """Twilio hits this with each thing the user says."""
    require_twilio_signature()
    call_sid = request.form["CallSid"]
    heard = request.form.get("SpeechResult", "").strip()
    print(f"[user]   {heard or '(silence)'}")

    turns = sum(1 for m in conversations.get(call_sid, []) if m["role"] == "user")
    if turns >= MAX_TURNS:
        reply, hang_up = "We've been chatting a while, so I'll let you go. Goodbye!", True
    else:
        reply, hang_up = claude_reply(call_sid, heard or "(silence — the user said nothing)")
    print(f"[claude] {reply}")

    if hang_up:
        vr = VoiceResponse()
        vr.say(reply, voice=VOICE)
        vr.hangup()
        return Response(str(vr), mimetype="text/xml")
    return Response(gather_twiml(reply), mimetype="text/xml")


@app.post("/status")
def status():
    require_twilio_signature()
    print(f"[call]   {request.form.get('CallSid')} -> {request.form.get('CallStatus')}")
    return ("", 204)


# ----------------------------------------------------------------------------- placing calls

def twilio_client() -> TwilioClient:
    return TwilioClient(env("TWILIO_ACCOUNT_SID"), env("TWILIO_AUTH_TOKEN"))


def place_say_call(message: str) -> None:
    """One-way call: Twilio reads the message aloud. Inline TwiML, so no server needed."""
    twiml = (f'<Response><Pause length="1"/><Say voice="{VOICE}">{escape(message)}</Say>'
             f'<Pause length="1"/><Say voice="{VOICE}">Again: {escape(message)}</Say></Response>')
    call = twilio_client().calls.create(to=env("MY_PHONE_NUMBER"), from_=env("TWILIO_PHONE_NUMBER"),
                                        twiml=twiml)
    print(f"Calling {env('MY_PHONE_NUMBER')} … (call SID {call.sid})")


def place_talk_call(goal: str) -> None:
    base = env("PUBLIC_URL").rstrip("/")
    call = twilio_client().calls.create(
        to=env("MY_PHONE_NUMBER"), from_=env("TWILIO_PHONE_NUMBER"),
        url=f"{base}/voice", method="POST",
        status_callback=f"{base}/status", status_callback_method="POST",
        status_callback_event=["initiated", "ringing", "answered", "completed"],
    )
    goals[call.sid] = goal
    print(f"Calling {env('MY_PHONE_NUMBER')} … (call SID {call.sid}). Pick up and talk!")


def main() -> None:
    p = argparse.ArgumentParser(description="An AI agent that calls your phone.")
    sub = p.add_subparsers(dest="mode", required=True)
    s = sub.add_parser("say", help="one-way spoken message")
    s.add_argument("message")
    t = sub.add_parser("talk", help="two-way conversation with Claude")
    t.add_argument("--goal", default=DEFAULT_GOAL, help="what the agent should accomplish on the call")
    t.add_argument("--port", type=int, default=int(os.environ.get("PORT", "5050")))
    args = p.parse_args()

    if args.mode == "say":
        place_say_call(args.message)
        return

    # talk: start the webhook server, then dial once it's listening.
    for name in ("PUBLIC_URL", "TWILIO_ACCOUNT_SID", "TWILIO_AUTH_TOKEN",
                 "TWILIO_PHONE_NUMBER", "MY_PHONE_NUMBER"):
        env(name)  # fail fast before dialing
    threading.Timer(1.5, place_talk_call, args=(args.goal,)).start()
    print(f"Webhook server on :{args.port}, reachable at {env('PUBLIC_URL')}")
    app.run(host="0.0.0.0", port=args.port)


if __name__ == "__main__":
    main()
