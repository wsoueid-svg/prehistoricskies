#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
GODOT_BIN="${GODOT_BIN:-godot}"
"$GODOT_BIN" --headless --path . --export-debug Android build/PrehistoricSkies.apk
echo "APK created at build/PrehistoricSkies.apk"
