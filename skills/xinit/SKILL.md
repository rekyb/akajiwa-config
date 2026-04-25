---
name: xinit
description: Set up project config for an existing project without planning a feature. Creates .claude/CLAUDE.md and .claude/memory/memory.md. Use /xplan instead if you have a feature to plan immediately.
---

# Project Config Setup

## When to use

Use /xinit when you want to set up project context but are not ready to plan a specific feature. If you have a feature to plan right now, use /xplan instead — it handles setup automatically.

## Process

Check if `.claude/CLAUDE.md` already exists. If it does, confirm with the user before overwriting.

Ask these questions one at a time:

1. What is this project? (one sentence)
2. Any stack differences from your global defaults (Next.js, Express, MongoDB)?
3. Any existing features or conventions Claude should know about?
4. Any known constraints (external API limits, legacy decisions, performance requirements)?

While asking questions, read the existing codebase:
- Check `package.json` for installed dependencies and scripts
- Check folder structure for established patterns
- Check for existing `tsconfig.json`, `.eslintrc`, `prettier.config.js`

## Output

Create `.claude/CLAUDE.md` using the template at `~/.claude/templates/project-claude.md`. Fill in every section from your questions and codebase scan. Do not leave any section as a placeholder.

Create `.claude/memory/memory.md`:

```md
# Project Memory — [Project Name]

Project-specific learnings from development sessions. Run /xretro to add entries.

---
```

Confirm: "Project config created. Use /xplan to plan your first feature."

## Rules

- No emojis
- Never leave template placeholders unfilled — ask more questions if needed
- Never overwrite an existing .claude/CLAUDE.md without explicit user confirmation
