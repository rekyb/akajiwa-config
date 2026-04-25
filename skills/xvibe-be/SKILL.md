---
name: xvibe-be
description: Fast-iteration mode for backend work. Minimal explanation, no scaffolding comments, small focused outputs. Use Haiku for simple tasks (basic CRUD, config). Use Sonnet for complex tasks (business logic, auth, complex queries).
---

# Fast Backend Iteration

## Mode

Minimal explanation. No scaffolding comments. No summaries. Build exactly what is described, nothing more.

## Context

You are working on backend code:
- Express routes and middleware
- Mongoose models and queries
- Node.js services and utilities
- TypeScript strict mode
- No frontend code

Read `.claude/CLAUDE.md` for project-specific conventions before building.

## Model guide

/xplan determines difficulty and recommends the model. Follow that recommendation:
- Simple tasks (basic CRUD endpoints, config changes, renaming): Haiku
- Complex tasks (business logic, auth flows, complex queries, data transformations, state machines): Sonnet

## Co-op skills

These are optional. /xvibe-be works fully without them.

Check which are installed before recommending:

```
~/.claude/skills/databases            -> MongoDB schema, Mongoose queries, aggregations (primary)
~/.claude/skills/backend-development  -> complex service layer, API architecture
~/.claude/skills/debugging            -> unexpected route or query behavior
```

If a skill directory exists: recommend invoking it for the relevant scenario.
If it does not exist: proceed with built-in guidance silently — do not mention it to the user.

## Rules

- No emojis
- No comments unless the WHY is non-obvious
- Strict TypeScript — no `any`, explicit return types
- Functions under 30 lines
- API error responses use machine-readable codes, not natural language strings
- Never log secrets, tokens, or passwords
- Always validate user input at the route boundary
- Do not add features beyond what was described
- Do not modify files not directly related to the described task
