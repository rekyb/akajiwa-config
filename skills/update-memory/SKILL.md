---
name: update-memory
description: Commit and push project memory to the project repo so teammates receive the latest learnings.
---

# Push Project Memory

## Process

Check that `.claude/memory/memory.md` exists in the current project. If it does not, output:

```
No project memory file found at .claude/memory/memory.md.
Run /xretro first to generate learnings, or /xinit to set up the project config.
```

Read the latest entries in `.claude/memory/memory.md` to generate a commit message.

Run:

```bash
git add .claude/memory/memory.md
git commit -m "retro: learnings from session [YYYY-MM-DD]"
git push
```

Confirm: "Project memory pushed. Teammates will receive it on their next git pull."

## Rules

- No emojis
- Only commit `.claude/memory/memory.md` — not other files
- If there are no new entries since the last commit, output: "No new memory entries to push."
