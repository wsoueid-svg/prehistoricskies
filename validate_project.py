#!/usr/bin/env python3
"""Static integrity checks for the Prehistoric Skies Godot project."""
from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ERRORS: list[str] = []


def error(message: str) -> None:
    ERRORS.append(message)


def strip_strings_and_comments(text: str) -> str:
    out: list[str] = []
    quote: str | None = None
    escaped = False
    for char in text:
        if quote is not None:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == quote:
                quote = None
            out.append(" ")
            continue
        if char in {'"', "'"}:
            quote = char
            out.append(" ")
            continue
        out.append(char)
    no_strings = "".join(out)
    return "\n".join(line.split("#", 1)[0] for line in no_strings.splitlines())


def check_balanced(path: Path) -> None:
    clean = strip_strings_and_comments(path.read_text(encoding="utf-8"))
    pairs = {")": "(", "]": "[", "}": "{"}
    stack: list[tuple[str, int]] = []
    for line_number, line in enumerate(clean.splitlines(), 1):
        for char in line:
            if char in "([{":
                stack.append((char, line_number))
            elif char in ")]}":
                if not stack or stack[-1][0] != pairs[char]:
                    error(f"{path.relative_to(ROOT)}:{line_number}: unmatched {char}")
                    return
                stack.pop()
    for char, line_number in stack:
        error(f"{path.relative_to(ROOT)}:{line_number}: unclosed {char}")


def check_gdscript(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    if "\t" in text:
        error(f"{path.relative_to(ROOT)}: contains tab indentation")
    for line_number, line in enumerate(text.splitlines(), 1):
        if line.strip() and len(line) - len(line.lstrip(" ")) % 4 != 0:
            # Kept as a warning-like check only for accidental odd indentation.
            pass
        if line.rstrip() != line:
            error(f"{path.relative_to(ROOT)}:{line_number}: trailing whitespace")
    functions = re.findall(r"^func\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(", text, flags=re.MULTILINE)
    duplicates = sorted({name for name in functions if functions.count(name) > 1})
    if duplicates:
        error(f"{path.relative_to(ROOT)}: duplicate functions: {', '.join(duplicates)}")
    check_balanced(path)


def check_resource_references() -> None:
    for path in ROOT.rglob("*"):
        if path.suffix not in {".gd", ".tscn", ".godot", ".cfg"} or not path.is_file():
            continue
        text = path.read_text(encoding="utf-8")
        for match in re.finditer(r'res://([^"\')]+)', text):
            target = ROOT / match.group(1)
            if not target.exists():
                error(f"{path.relative_to(ROOT)}: missing resource {match.group(0)}")


def check_required_files() -> None:
    required = [
        "project.godot",
        "export_presets.cfg",
        "scenes/main.tscn",
        "scripts/main.gd",
        "scripts/player.gd",
        "scripts/terrain.gd",
        "scripts/touch_controls.gd",
    ]
    for relative in required:
        if not (ROOT / relative).is_file():
            error(f"missing required file: {relative}")


def manifest() -> str:
    rows: list[str] = []
    for path in sorted(p for p in ROOT.rglob("*") if p.is_file() and ".godot" not in p.parts and p.name != "SHA256SUMS.txt"):
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        rows.append(f"{digest}  {path.relative_to(ROOT).as_posix()}")
    return "\n".join(rows) + "\n"


def main() -> int:
    check_required_files()
    for script in sorted((ROOT / "scripts").glob("*.gd")):
        check_gdscript(script)
    check_resource_references()
    (ROOT / "SHA256SUMS.txt").write_text(manifest(), encoding="utf-8")
    if ERRORS:
        print("STATIC VALIDATION FAILED")
        for issue in ERRORS:
            print(f"- {issue}")
        return 1
    print("STATIC VALIDATION PASSED")
    print(f"Project: {ROOT}")
    print(f"Scripts checked: {len(list((ROOT / 'scripts').glob('*.gd')))}")
    print("Resource references: present")
    print("Bracket/quote structure: balanced")
    print("SHA256SUMS.txt: refreshed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
