# phone-agent: an AI that calls your phone

Twilio places the call, turns your speech into text and reads replies aloud. Claude decides what to say each turn and when to hang up.

```
your phone ⇄ Twilio ⇄ (webhooks) ⇄ call_me.py ⇄ Claude API
```

## One-time setup (about 10 minutes)

1. **Twilio**: sign up at twilio.com (the trial includes credit) and buy a voice-capable number. On a trial account, add your own phone under *Verified Caller IDs*. Trial calls play a short Twilio notice first.
2. **Claude**: create an API key at platform.claude.com.
3. Install and configure:
   ```bash
   cd phone-agent
   python -m venv .venv && source .venv/bin/activate
   pip install -r requirements.txt
   cp .env.example .env      # fill in your keys + your phone number
   set -a; source .env; set +a
   ```

## Use it

**Spoken message (no server needed):**
```bash
python call_me.py say "Hey, your deploy finished and all tests passed."
```

**Live two-way conversation with Claude:**
```bash
ngrok http 5050                       # in another terminal; copy the https URL into PUBLIC_URL
python call_me.py talk
python call_me.py talk --goal "Quiz me on Spanish vocabulary for 5 minutes"
```
Your phone rings. Pick up and talk. Say "bye" (or "hang up") and the agent ends the call.

## Notes
- Only Twilio-signed requests are accepted (`X-Twilio-Signature` is validated), so the public URL can't be abused.
- `AGENT_EFFORT=low` is the default because every turn is time you spend waiting on the line.
- Refusal fallback is on (`fallbacks: "default"`), so a safety-classifier decline is retried on a fallback model and doesn't leave the line silent.
- Conversation state is in memory per call. A restart drops calls that are in progress.
- Calls cost money: Twilio's per-minute rate plus Claude tokens, usually cents for a short call.
