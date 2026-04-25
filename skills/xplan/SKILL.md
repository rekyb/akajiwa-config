---
name: xplan
description: Plan a feature or change before any code is written. Determines FE/BE scope, assesses difficulty per scope, and recommends the right vibe command and model. Opus recommended.
---

# Feature Planning

## Model check

Check the current model before proceeding. If not on Opus, output:

```
/xplan works best on Opus for deep reasoning and multi-step planning.
Current model: [detected model]
Switch with: /model claude-opus-4-7

Continue on current model, or switch first?
```

Wait for the user's response before continuing.

## Step 1 — Project context

Check for `.claude/CLAUDE.md` in the current directory.

If it does not exist:
- Ask the following setup questions one at a time:
  1. What is this project?
  2. Any stack differences from your global defaults (Next.js, Express, MongoDB)?
  3. Any existing conventions or features to know about?
- Read the existing codebase structure to detect patterns
- Create `.claude/CLAUDE.md` using the template at `~/.claude/templates/project-claude.md`
- Create `.claude/memory/memory.md` with an empty header
- Confirm: "Project config created. Now planning your feature..."

If it exists, read it silently before asking any questions.

## Step 2 — Features index

Read `~/.claude/memory/features-index.md`.

If relevant existing features are found based on what the user wants to build, surface them:

```
Relevant existing features found:

-> [Feature Name] ([project])
   [What it exposes that may be relevant]

Should the plan account for integration with these?
```

Wait for the user's response.

## Step 3 — Focused questions

Ask one question at a time. Minimum questions before planning:

1. What does this feature do from the user's perspective?
2. Any constraints or known edge cases?
3. Is there an existing design to follow?

Stop asking when you have enough to determine scope and write the plan.

## Step 4 — Scope and difficulty assessment

Determine scope:
- FE only: no data persistence, no API, UI and interaction changes only
- BE only: no UI changes, API, data, or service layer only
- Full stack: requires both API and UI changes

Assess difficulty per scope using these criteria:

Simple:
- Color, font, or spacing changes
- Basic CRUD endpoints
- Config changes
- Copy edits
- Renaming or restructuring
- Standard form components

Complex:
- Business logic, multi-step workflows
- Authentication or authorization flows
- State machines, data transformations
- Complex queries or aggregations
- Performance optimization
- Algorithm implementation

## Step 5 — Generate plan artifacts

Create `docs/plans/[feature-name]-context.md` with:
- What was found in the codebase relevant to this feature
- Existing components, APIs, or patterns that can be reused
- Constraints discovered during research

Create `docs/plans/[feature-name]-plan.md` with:
- Scope and difficulty assessment
- Data model changes (if any)
- API routes (if any): method, path, request body, response shape
- Component breakdown (if any): component name, props, responsibilities
- Implementation order (BE first for full stack)

## Step 6 — Update features index

Append to `~/.claude/memory/features-index.md`:

```md
## [Feature Name]
- Project: [project name from .claude/CLAUDE.md]
- Repo: [git remote url or local path]
- Planned: [today's date YYYY-MM-DD]
- What: [one sentence description]
- Exposes:
  - API: [routes, or "none"]
  - Component: [component names, or "none"]
  - Hook: [hook names, or "none"]
- Data: [key data model fields, or "none"]
```

## Step 7 — End with recommendation

Output the following summary block:

```
Scope: [FE only / BE only / Full stack]

Difficulty:
  BE: [Simple / Complex] — [one-line reason]
  FE: [Simple / Complex] — [one-line reason]

Recommended:
  [/xvibe-be on Haiku/Sonnet] — [reason]
  [/xvibe-fe on Haiku/Sonnet] — [reason]

For full stack: build BE first (data layer), then FE.
```

## Rules

- No emojis
- Ask one question at a time — never batch questions
- Never write any implementation code — this command produces plans only
- Scope must be explicitly stated before any recommendation
