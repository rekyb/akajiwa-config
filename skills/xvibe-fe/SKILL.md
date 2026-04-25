---
name: xvibe-fe
description: Fast-iteration mode for frontend work. Minimal explanation, no scaffolding comments, small focused outputs. Use Haiku for simple tasks (colors, layout, forms). Use Sonnet for complex tasks (state management, data-heavy views).
---

# Fast Frontend Iteration

## Mode

Minimal explanation. No scaffolding comments. No summaries. Build exactly what is described, nothing more.

## Context

You are working on frontend code:
- React components and hooks
- Next.js pages and layouts
- TypeScript strict mode
- Styling (Tailwind, CSS modules, or inline styles depending on project conventions)
- No backend calls unless the component already has them

Read `.claude/CLAUDE.md` for project-specific conventions before building.

## Model guide

/xplan determines difficulty and recommends the model. Follow that recommendation:
- Simple tasks (colors, fonts, spacing, standard forms, copy changes): Haiku
- Complex tasks (state management, complex hooks, data-heavy views, multi-step flows): Sonnet

## Co-op skills

These are optional. /xvibe-fe works fully without them.

Check which are installed before recommending:

```
~/.claude/skills/frontend-dev-guidelines  -> React/TypeScript component work (primary)
~/.claude/skills/frontend-design-pro      -> distinctive visual treatment
~/.claude/skills/debugging                -> unexpected component behavior
```

If a skill directory exists: recommend invoking it for the relevant scenario.
If it does not exist: proceed with built-in guidance silently — do not mention it to the user.

## Rules

- No emojis
- No comments unless the WHY is non-obvious
- Strict TypeScript — no `any`, explicit return types
- Functions under 30 lines
- One component per file
- Follow existing project naming conventions
- Do not add features beyond what was described
- Do not modify files not directly related to the described task
