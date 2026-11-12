#!/usr/bin/env python3
"""
free_call.py — ring your phone for free with a Telegram voice call.

Uses the CallMeBot web API (a third-party service, not Telegram's own API):
your phone rings in the Telegram app and a text-to-speech voice reads the message.
No phone company, no API key, no paid account. Standard library only.

One-time setup (on your phone):
  1. Install Telegram and set a username (Settings -> Username).
  2. Authorise CallMeBot to call you: message @CallMeBot_txtbot and send /start
     (see callmebot.com for the current instructions).

Usage:
  export TELEGRAM_USER=@yourusername
  python free_call.py "Your build finished and all tests passed."
  python free_call.py --repeat 2 --lang en-GB-Standard-B "Time to stand up."
"""
import argparse
import os
import sys
import urllib.error
import urllib.parse
import urllib.request

API = "https://api.callmebot.com/start.php"


def build_url(user: str, text: str, lang: str, repeat: int) -> str:
    if not user.startswith("@") and not user.lstrip("+").isdigit():
        user = "@" + user
    query = {"user": user, "text": text, "lang": lang, "rpt": str(repeat)}
    return API + "?" + urllib.parse.urlencode(query)


def main() -> int:
    p = argparse.ArgumentParser(description="Ring your phone via a free Telegram voice call.")
    p.add_argument("message", help="what the voice should say")
    p.add_argument("--user", default=os.environ.get("TELEGRAM_USER"),
                   help="your Telegram @username (or set TELEGRAM_USER)")
    p.add_argument("--lang", default="en-US-Standard-B", help="text-to-speech voice")
    p.add_argument("--repeat", type=int, default=2, help="times to repeat the message")
    p.add_argument("--dry-run", action="store_true", help="print the request URL, don't call")
    args = p.parse_args()

    if not args.user:
        sys.exit("Set TELEGRAM_USER=@yourusername or pass --user")
    url = build_url(args.user, args.message, args.lang, args.repeat)
    if args.dry_run:
        print(url)
        return 0

    try:
        # The service holds the request open while the call is queued and ringing.
        with urllib.request.urlopen(url, timeout=120) as r:
            body = r.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as e:
        sys.exit(f"CallMeBot answered HTTP {e.code}: {e.read().decode('utf-8', 'replace')[:300]}")
    except urllib.error.URLError as e:
        sys.exit(f"Could not reach CallMeBot: {e.reason}")
    print(body.strip()[:500])
    return 0


if __name__ == "__main__":
    sys.exit(main())
