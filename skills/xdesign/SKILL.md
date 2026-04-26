---
name: xdesign
description: UI/UX design brief and direction. Checks for existing components and design system files before proposing new ones. Requires execution mode. Generates a structured design artifact in docs/plans/. Opus recommended.
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

## Step 1 — Execution mode

Before any other step, ask the user:

```
What mode?

  Explore    — 3 named concept directions with different hierarchies or tones
  Prototype  — 1 recommended direction + up to 2 alternates
  Implement  — single highest-confidence direction, fully specified for code
  Review     — critique against brand, guardrails, and accessibility
```

Wait for the user's response. The mode determines what Step 4 produces.

## Step 2 — Design system files

Look for the following files in the project and read any that exist:

- `docs/brand-guidelines.md`
- `docs/design-guardrails.md`
- `docs/copy-guardrails.md`
- `docs/design-system.md`
- `docs/TOKENS.md`
- `docs/DESIGN.md`

If found, summarize the constraints that are relevant to the design work:

```
Design system constraints loaded:

-> [Constraint or token]
   [How it applies]
```

If none are found, note that no design system files were found and proceed.

## Step 3 — Features index check

Read `~/.claude/memory/features-index.md`.

If existing components or design patterns are found that relate to what the user wants to design, surface them:

```
Existing components found that may be relevant:

-> [Component name] from [project]
   [What it does, props it accepts]

Should the design reuse or extend these?
```

## Step 4 — Focused questions

Ask one at a time:

1. What screen or component are we designing?
2. What is the user trying to accomplish on this screen?
3. Any existing brand or visual reference to follow? (skip if design system files were loaded)
4. Mobile, desktop, or both?
5. Any copy constraints or tone guidelines?

If any question is skipped or the answer is thin, state your assumption explicitly before generating the artifact:

```
Assumptions:
- [Assumption made due to missing input]
```

## Step 5 — Generate design artifact

Create `docs/plans/[feature-name]-design.md`.

The structure depends on the execution mode:

**Explore mode:** Produce 3 named concept directions. Each direction includes visual direction, layout, and a representative component example. Do not produce full specs.

**Prototype mode:** Produce 1 recommended direction with full spec below, plus up to 2 alternate directions with visual direction and layout only.

**Implement mode:** Produce 1 fully specified direction using the structure below. Reference design system tokens where applicable.

**Review mode:** Evaluate the existing design against brand files, guardrails, and accessibility. List what passes, what fails, and what needs a decision.

---

Full spec structure (used in Prototype and Implement modes):

- Visual direction: describe the overall feel in concrete terms — shape language, weight, density, tone
- Layout: describe the structure and hierarchy
- Key components: list each with its visual treatment and states (default, hover, focus, active, disabled, loading, error, empty)
- Copy: provide actual copy for every label, CTA, empty state, and error message — no placeholders
- Motion: declare entrance behavior, success acknowledgment, loading state character, and reduced-motion fallback
- Responsive behavior: how it adapts from mobile to desktop
- Design system references: list any tokens, components, or patterns referenced from loaded design system files

## Step 6 — Quality gate

Before presenting the artifact, verify:

- Every component state has copy — no placeholders remain
- Visual direction is described in concrete terms, not adjectives like "clean" or "modern"
- Motion intent is declared for all non-trivial interactions
- Mobile constraints are applied in the spec, not just mentioned
- Any deviation from the loaded design system is intentional and explained
- No emojis anywhere in the output

If any check fails, fix it before presenting.

## Rules

- No emojis
- Provide actual copy for every text element — never write "add copy here"
- Describe visual direction in concrete terms — never write "make it look good"
- If reusing existing components, reference them by name
- State assumptions explicitly when the brief is incomplete
- Reference design system tokens when available instead of hardcoding values
