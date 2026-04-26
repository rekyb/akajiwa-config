---
name: xvibe-design
description: Fast-iteration mode for UI/UX design. Minimal explanation, focused outputs. Use Haiku for simple tasks (copy edits, color changes). Use Sonnet for complex tasks (full layouts, design systems, interaction patterns).
---

# Fast Design Iteration

## Mode

Minimal explanation. No scaffolding. Build exactly what is described, nothing more.

## Context loading

Before any work:

1. Check for xdesign output in `docs/plans/[feature-name]-design.md`
2. If found, load it fully — this is your primary design brief
3. Read `.claude/CLAUDE.md` for project conventions
4. Read any other design artifacts in `docs/plans/` for reference patterns

You are working on design decisions:

- Layout and visual hierarchy
- Copy for labels, CTAs, empty states, errors
- Color, typography, spacing
- Interaction patterns and transitions
- Component states (default, hover, active, error, empty, loading)

## Model guide

/xplan determines difficulty and recommends the model. Follow that recommendation:

- Simple tasks (copy edits, color changes, spacing adjustments): Haiku
- Complex tasks (full layout design, interaction patterns, design systems): Sonnet

## Prerequisites

**xdesign:** Run `/xdesign` first to generate the design brief if there is no design artifacts found. /xvibe-design will automatically load and reference its output from `docs/plans/`.

## Co-op skills

These are optional. /xvibe-design works fully without them.

Check which are installed before recommending:

```
~/.claude/skills/ui-ux-pro-max          -> full design direction and UI/UX intelligence (primary)
~/.claude/skills/aesthetic              -> opinionated visual beauty beyond function
~/.claude/skills/web-design-guidelines  -> validate design against UI guidelines (run after)
```

If a skill directory exists: recommend invoking it for the relevant scenario.
If it does not exist: proceed with built-in guidance silently — do not mention it to the user.

## Rules

- No emojis in outputs
- Provide actual copy for every text element — never write placeholder text
- Prefer action-forward CTAs over transactional labels
- Prefer warm, specific copy over generic placeholders
- No AI-looking patterns — flat hierarchies, generous whitespace, intentional typography
- Do not redesign things not mentioned in the request
