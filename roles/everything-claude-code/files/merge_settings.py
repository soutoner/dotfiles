#!/usr/bin/env python3
"""
Analyse ~/.claude/settings.json and produce a safe-merge result.

Usage: merge_settings.py <settings_path>

Output (JSON on stdout):
  {"status": "new",        "merged": {...}, "details": []}
  {"status": "ok",         "merged": {...}, "details": []}
  {"status": "conflict",   "merged": {...}, "details": ["key: 'old' -> 'new'", ...]}
  {"status": "parse_error","details": ["<error>"]}
"""
import json
import os
import sys

DESIRED = {
    "model": "sonnet",
    "env": {
        "MAX_THINKING_TOKENS": "10000",
        "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "50",
        "CLAUDE_CODE_SUBAGENT_MODEL": "haiku",
    },
}


def main(settings_path):
    if not os.path.exists(settings_path):
        print(json.dumps({"status": "new", "merged": DESIRED, "details": []}))
        return

    with open(settings_path) as f:
        try:
            existing = json.load(f)
        except json.JSONDecodeError as exc:
            print(json.dumps({"status": "parse_error", "details": [str(exc)]}))
            return

    conflicts = []

    if "model" in existing and existing["model"] != DESIRED["model"]:
        conflicts.append("model: '{}' -> '{}'".format(existing["model"], DESIRED["model"]))

    existing_env = existing.get("env", {})
    for key, val in DESIRED["env"].items():
        if key in existing_env and existing_env[key] != val:
            conflicts.append("env.{}: '{}' -> '{}'".format(key, existing_env[key], val))

    merged = dict(existing)
    if "model" not in merged:
        merged["model"] = DESIRED["model"]
    merged_env = dict(merged.get("env", {}))
    for key, val in DESIRED["env"].items():
        merged_env[key] = val
    merged["env"] = merged_env

    status = "conflict" if conflicts else "ok"
    print(json.dumps({"status": status, "merged": merged, "details": conflicts}))


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Usage: merge_settings.py <settings_path>")
    main(sys.argv[1])
