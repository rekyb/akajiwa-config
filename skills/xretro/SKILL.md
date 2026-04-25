---
name: xretro
description: Session retrospective. Scans the conversation for corrections, discoveries, patterns, and anti-patterns. Routes learnings to the right memory layer. Flags promotion candidates for /xreflect. Runs automatically via Stop hook at session end.
---

# Session Retrospective

## Process

Scan the full conversation for moments where:
- The user corrected or rewrote Claude's output (CORRECTION)
- Something unexpected worked well (DISCOVERY)
- An approach consistently produced good results (PATTERN)
- An approach consistently failed or produced problems (ANTI-PATTERN)

Skip:
- Typo fixes
- Simple variable renames
- Re-runs of the same command
- Anything that is obvious from the code or spec

## Routing

For each learning, determine if it is:

**Project-specific** — applies only to this codebase (schema conventions, framework-specific patterns, project constraints)
- Write to `.claude/memory/memory.md` in the current project

**Universal candidate** — applies across all projects (copy tone, error code standards, game feel patterns)
- Write to `.claude/memory/memory.md` in the current project AND flag as a promotion candidate

## Entry format

```md
## YYYY-MM-DD

- CORRECTION: [what was wrong] -> [what it was changed to]. [why this matters, one sentence].
- DISCOVERY: [what was found]. [why this is useful, one sentence].
- PATTERN: [what approach]. [what it consistently produces, one sentence].
- ANTI-PATTERN: [what approach]. [what it consistently produces, one sentence].
```

## After writing

Check `~/.claude/memory/memory.md` (shared) and `.claude/memory/memory.md` (project) for entries that appear 3 or more times across different sessions.

If found, output:

```
Promotion candidate detected:
"[entry summary]" has appeared [N] times.
Run /xreflect to review and promote it to global config.
```

## Rules

- No emojis
- One line per entry
- Never duplicate an existing entry — check before writing
- Write the date as YYYY-MM-DD
- Never write trivial corrections
- If nothing worth capturing happened in the session, output: "No learnings to record for this session."
