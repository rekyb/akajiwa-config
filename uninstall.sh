#!/usr/bin/env bash
set -euo pipefail

CLAUDE_HOME="$HOME/.claude"
SKILLS_DIR="$CLAUDE_HOME/skills"

echo "Akajiwa Claude Code Config - Uninstaller"
echo "========================================="
echo ""

SKILLS=(xplan xdesign xreview xvibe-fe xvibe-be xvibe-design xqa xinit xretro xreflect update-memory get-memory)

for skill in "${SKILLS[@]}"; do
    target="$SKILLS_DIR/$skill"
    if [ -L "$target" ] || [ -d "$target" ]; then
        rm -rf "$target"
        echo "Removed: $skill"
    fi
done

rm -f "$CLAUDE_HOME/.akajiwa-config-path"
echo "Removed: config path file"

echo ""
echo "Done."
echo "CLAUDE.md, settings.json hooks, and memory files were not removed."
echo "Remove them manually if needed:"
echo "  ~/.claude/CLAUDE.md"
echo "  ~/.claude/memory/"
echo "  ~/.claude/settings.json (remove the Stop and PreToolUse hooks)"
