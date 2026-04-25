---
name: xreflect
description: Scan both memory layers for patterns appearing 3 or more times. Propose promotions to global CLAUDE.md or the relevant skill. On approval, edit the file, commit, and push to the config repo.
---

# Pattern Promotion

## Process

Read both memory files:
- `~/.claude/memory/memory.md` (shared)
- `.claude/memory/memory.md` (current project, if it exists)

Identify entries that:
- Appear 3 or more times across different session dates
- Are marked as universal candidates
- Represent a consistent correction or pattern (not a one-off)

## Proposal format

For each promotion candidate, output:

```
Pattern detected ([N] occurrences):
"[summary of the pattern]"

Earliest: [date]
Latest: [date]

Proposed change:
  File: [~/.claude/CLAUDE.md or skills/[skill]/SKILL.md]
  Add: "[exact text to add]"

Promote? [yes/no]
```

Wait for the user's response before making any change.

## On approval

1. Edit the target file and add the promoted rule
2. Remove the duplicate entries from memory (keep one as a record)
3. Read the config repo path from `~/.claude/.akajiwa-config-path`
4. Run in the config repo directory:

```bash
git add -A
git commit -m "reflect: promote [pattern summary] to global config"
git push
```

5. Confirm: "Promoted and pushed. Run /get-memory on other machines to receive this update."

## Rules

- No emojis
- Never edit any file without explicit user approval
- Never push without explicit user approval
- Promote to the most specific location: a skill file if the pattern is command-specific, CLAUDE.md if it is universal
- After promotion, verify the promoted text does not duplicate existing content in the target file
