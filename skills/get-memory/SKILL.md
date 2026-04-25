---
name: get-memory
description: Pull latest shared memory and config updates from the config repo. Re-symlinks skills if anything changed. Reports what was updated.
---

# Pull Shared Memory

## Process

Read the config repo path from `~/.claude/.akajiwa-config-path`.

If the file does not exist, output:

```
Config repo path not found at ~/.claude/.akajiwa-config-path.
Re-run the installer to set it up: ./install.sh or ./install.ps1
```

Run in the config repo directory:

```bash
git pull
```

After pulling, compare the updated files with their installed versions:

- If `CLAUDE.md` changed: copy to `~/.claude/CLAUDE.md` (merge if user has local additions)
- If `memory/memory.md` changed: copy to `~/.claude/memory/memory.md`
- If `memory/features-index.md` changed: copy to `~/.claude/memory/features-index.md`
- If any skill changed: re-symlink that skill

Report what changed:

```
Updated: memory/memory.md (+N new entries)
Updated: skills/xretro (new version)
No changes: CLAUDE.md, 10 other skills
```

If nothing changed: "Already up to date."

## Rules

- No emojis
- Never overwrite local additions to CLAUDE.md — merge by appending remote changes
- Report every changed file — do not silently update
