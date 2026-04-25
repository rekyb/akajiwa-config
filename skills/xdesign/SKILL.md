---
name: xdesign
description: UI/UX design brief and direction. Checks for existing components in the features index before proposing new ones. Generates a design artifact in docs/plans/. Opus recommended.
---

# UI/UX Design Brief

## Model check

Check the current model before proceeding. If not on Opus, output:

```
/xdesign works best on Opus for design judgment and direction.
Current model: [detected model]
Switch with: /model claude-opus-4-7

Continue on current model, or switch first?
```

Wait for the user's response before continuing.

## Step 1 — Features index check

Read `~/.claude/memory/features-index.md`.

If existing components or design patterns are found that relate to what the user wants to design, surface them:

```
Existing components found that may be relevant:

-> [Component name] from [project]
   [What it does, props it accepts]

Should the design reuse or extend these?
```

## Step 2 — Focused questions

Ask one at a time:

1. What screen or component are we designing?
2. What is the user trying to accomplish on this screen?
3. Any existing brand or visual reference to follow?
4. Mobile, desktop, or both?
5. Any copy constraints or tone guidelines?

## Step 3 — Generate design artifact

Create `docs/plans/[feature-name]-design.md` with:

- Visual direction: describe the overall feel, not just colors
- Layout: describe the structure and hierarchy
- Key components: list each with its visual treatment and states (default, hover, active, error, empty)
- Copy: provide actual copy for every label, CTA, empty state, and error message — no placeholders
- Interaction patterns: describe how transitions and feedback work
- Responsive behavior: how it adapts from mobile to desktop

## Rules

- No emojis
- Provide actual copy for every text element — never write "add copy here"
- Describe visual direction in concrete terms — never write "make it look good"
- If reusing existing components, reference them by name
