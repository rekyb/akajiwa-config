# Akajiwa Config Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a complete Claude Code personal config system with global standards, 12 slash commands, a self-upgrading memory loop, and a cross-platform installer with automatic RTK setup.

**Architecture:** Layered config (global CLAUDE.md → project .claude/CLAUDE.md) with task-specific skills as markdown instruction files. The installer symlinks skills into `~/.claude/skills/`, merges hooks into `settings.json`, and auto-installs RTK. Memory files live in the config repo and are synced via git.

**Tech Stack:** Markdown (config + skills), Bash (Mac/Linux installer), PowerShell (Windows installer), JSON (settings.json), Git (memory sync), Python3 (settings.json merge in install.sh — pre-installed on Mac and most Linux distros)

---

## File Map

```
akajiwa/
├── CLAUDE.md                          <- global config
├── settings.json                      <- Stop hook + RTK PreToolUse hook
├── README.md                          <- how-to guide
├── templates/
│   └── project-claude.md             <- project CLAUDE.md template used by /xinit and /xplan
├── memory/
│   ├── memory.md                     <- shared universal standards (empty on first install)
│   └── features-index.md            <- cross-project feature map (empty on first install)
├── skills/
│   ├── xplan/SKILL.md
│   ├── xdesign/SKILL.md
│   ├── xreview/SKILL.md
│   ├── xvibe-fe/SKILL.md
│   ├── xvibe-be/SKILL.md
│   ├── xvibe-design/SKILL.md
│   ├── xqa/SKILL.md
│   ├── xinit/SKILL.md
│   ├── xretro/SKILL.md
│   ├── xreflect/SKILL.md
│   ├── update-memory/SKILL.md
│   └── get-memory/SKILL.md
├── install.sh
├── install.ps1
├── uninstall.sh
└── uninstall.ps1
```

---

## Task 1: Repository Setup

**Files:**
- Create: `akajiwa/.gitignore`
- Create: `akajiwa/memory/memory.md`
- Create: `akajiwa/memory/features-index.md`
- Create: `akajiwa/templates/project-claude.md`

- [ ] **Step 1: Initialize git repo**

```bash
cd /d/Projects/akajiwa
git init
```

Expected: `Initialized empty Git repository in .../akajiwa/.git/`

- [ ] **Step 2: Create .gitignore**

Create `D:/Projects/akajiwa/.gitignore`:

```
.DS_Store
Thumbs.db
*.swp
```

- [ ] **Step 3: Create memory/memory.md**

Create `D:/Projects/akajiwa/memory/memory.md`:

```md
# Shared Memory — Akajiwa Config

Universal standards promoted from in-session corrections. Run /xretro to add entries. Run /xreflect to promote patterns.

---
```

- [ ] **Step 4: Create memory/features-index.md**

Create `D:/Projects/akajiwa/memory/features-index.md`:

```md
# Features Index — Akajiwa Config

Cross-project feature map. Updated automatically by /xplan when a plan is generated. Read on-demand by /xplan and /xdesign.

---
```

- [ ] **Step 5: Create templates/project-claude.md**

Create `D:/Projects/akajiwa/templates/project-claude.md`:

```md
# [Project Name]

## What this is
One sentence describing the project purpose.

## Stack
- Frontend: Next.js / React + TypeScript
- Backend: Express + Node + TypeScript
- Database: MongoDB + Mongoose
- Testing: Playwright (E2E), Vitest (unit)

## Key conventions
- [Patterns specific to this codebase]
- [Naming conventions that differ from global defaults]
- [Folder structure notes]

## Data models
- [Core entities and their relationships]

## Existing features
- [List of implemented features with brief description]
- [Links to docs/plans/ artifacts if they exist]

## Out of scope
- [Things explicitly not in this project]

## Known constraints
- [External API limits, legacy decisions, performance requirements]
```

- [ ] **Step 6: Commit**

```bash
git add .gitignore memory/ templates/
git commit -m "chore: initialize repo with memory files and project template"
```

---

## Task 2: Global CLAUDE.md

**Files:**
- Create: `akajiwa/CLAUDE.md`

- [ ] **Step 1: Create CLAUDE.md**

Create `D:/Projects/akajiwa/CLAUDE.md`:

```md
# Akajiwa — Global Claude Code Config

## Identity

Senior Solo PM + Senior product engineer + Senior UI/UX designer. Builds web products across the full stack. Standards apply across code, design, and product work.

## Code standards

- Strict TypeScript everywhere — no `any`, no untyped variables
- Functional programming preferred, OOP only for external connectors
- Pure functions only — never mutate inputs or global state
- No default parameter values — all params explicit
- No silent error handling — always raise with context
- No fallbacks unless explicitly asked
- All imports at top of file
- Functions under 30 lines — if longer, it is doing too much
- No comments unless the WHY is non-obvious
- Explicit return types on all functions
- Proper type definitions for all complex data structures

## Stack defaults

- Frontend: Next.js / React, strict TypeScript
- Backend: Express + Node, strict TypeScript
- Database: MongoDB + Mongoose
- Testing: Playwright (E2E), Vitest (unit)
- Package manager: pnpm

## SonarQube quality gate (new code)

- New bugs and vulnerabilities: 0
- Security hotspots reviewed: 100%
- Coverage on new code: >= 80%
- Duplicated lines on new code: <= 3%

## SonarQube critical rules

- Re-exports (S4328): always `export { x } from './y'` — never import then export
- Cognitive complexity: functions must stay <= 15
- DRY strings (S1192): no repeated string literals — extract to constants
- MUI v7: use `slotProps.input` not `inputProps`

## Anti-slop standards

- No generic placeholder copy ("No items yet", "Click here to get started")
- No transactional CTAs ("Submit", "Create Account") — prefer action-forward tone
- No AI-looking UI patterns — flat hierarchies, generous whitespace, intentional typography
- API error responses must be machine-readable codes, not natural language strings
- Hitboxes in game or interactive projects reduced to ~80% of visual size for feel
- Playtest physics constants before hardcoding them

## Token efficiency

- Use `rtk` prefix for all terminal commands
- Keep responses focused — no trailing summaries, no re-explaining what was just done
- Small focused files — if a file grows large, flag it as doing too much
- Prefer reading source code over guessing library behavior

## No emojis

Never use emojis in any output, config file, skill output, artifact, or generated document.
```

- [ ] **Step 2: Verify**

Open Claude Code in any directory and confirm these rules are active by asking: "What is my stack default?" Expected response should mention Next.js, Express, MongoDB.

- [ ] **Step 3: Commit**

```bash
git add CLAUDE.md
git commit -m "feat: add global CLAUDE.md with stack defaults and quality standards"
```

---

## Task 3: settings.json

**Files:**
- Create: `akajiwa/settings.json`

- [ ] **Step 1: Create settings.json**

Create `D:/Projects/akajiwa/settings.json`:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "claude /xretro"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo \"RTK reminder: prefix terminal commands with rtk for token savings\""
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add settings.json
git commit -m "feat: add settings.json with Stop hook and RTK PreToolUse reminder"
```

---

## Task 4: xplan Skill

**Files:**
- Create: `akajiwa/skills/xplan/SKILL.md`

- [ ] **Step 1: Create skill directory and SKILL.md**

Create `D:/Projects/akajiwa/skills/xplan/SKILL.md`:

```md
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
```

- [ ] **Step 2: Commit**

```bash
git add skills/xplan/
git commit -m "feat: add /xplan skill"
```

---

## Task 5: xdesign Skill

**Files:**
- Create: `akajiwa/skills/xdesign/SKILL.md`

- [ ] **Step 1: Create SKILL.md**

Create `D:/Projects/akajiwa/skills/xdesign/SKILL.md`:

```md
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
```

- [ ] **Step 2: Commit**

```bash
git add skills/xdesign/
git commit -m "feat: add /xdesign skill"
```

---

## Task 6: xreview Skill

**Files:**
- Create: `akajiwa/skills/xreview/SKILL.md`

- [ ] **Step 1: Create SKILL.md**

Create `D:/Projects/akajiwa/skills/xreview/SKILL.md`:

```md
---
name: xreview
description: Fresh-context code or design review. Reads the current diff and flags issues against quality standards, SonarQube rules, and anti-slop standards. Opus recommended.
---

# Code and Design Review

## Model check

Check the current model before proceeding. If not on Opus, output:

```
/xreview works best on Opus for thorough analysis.
Current model: [detected model]
Switch with: /model claude-opus-4-7

Continue on current model, or switch first?
```

Wait for the user's response before continuing.

## Review process

Read the current git diff: `git --no-pager diff HEAD`

If no diff, read the last commit: `git --no-pager show`

Review against these categories in order:

**1. Correctness**
- Logic errors or edge cases not handled
- Missing error handling on async operations
- Type mismatches or unsafe type assertions

**2. SonarQube rules**
- Re-exports using import + export instead of `export { x } from './y'`
- Cognitive complexity > 15 in any function
- Repeated string literals that should be constants
- `inputProps` used instead of `slotProps.input` in MUI v7
- Functions longer than 30 lines

**3. TypeScript**
- Any use of `any` type
- Missing explicit return types on functions
- Untyped function parameters

**4. Security**
- Unsanitized user input reaching the database
- Secrets or credentials in code
- Missing auth middleware on protected routes
- SQL/NoSQL injection vectors

**5. Anti-slop**
- Generic placeholder copy ("No items yet", "Loading...")
- Transactional CTAs ("Submit", "Create Account")
- Natural language API error strings instead of machine-readable codes

**6. Architecture**
- Functions doing more than one thing
- Files growing too large (flag if > 200 lines)
- Logic duplicated more than twice

## Output format

Group findings by category. For each finding:

```
[Category] [file:line]
Issue: [what is wrong]
Fix: [what to change, with the corrected code if applicable]
```

If nothing is found in a category, skip it.

End with a one-line summary: "N issues found across M categories."

## Rules

- No emojis
- Read the diff with no assumptions from prior conversation context
- Show corrected code for every fix where code is involved
- Do not rewrite working code that has no issue
```

- [ ] **Step 2: Commit**

```bash
git add skills/xreview/
git commit -m "feat: add /xreview skill"
```

---

## Task 7: xvibe-fe Skill

**Files:**
- Create: `akajiwa/skills/xvibe-fe/SKILL.md`

- [ ] **Step 1: Create SKILL.md**

Create `D:/Projects/akajiwa/skills/xvibe-fe/SKILL.md`:

```md
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
```

- [ ] **Step 2: Commit**

```bash
git add skills/xvibe-fe/
git commit -m "feat: add /xvibe-fe skill"
```

---

## Task 8: xvibe-be Skill

**Files:**
- Create: `akajiwa/skills/xvibe-be/SKILL.md`

- [ ] **Step 1: Create SKILL.md**

Create `D:/Projects/akajiwa/skills/xvibe-be/SKILL.md`:

```md
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
```

- [ ] **Step 2: Commit**

```bash
git add skills/xvibe-be/
git commit -m "feat: add /xvibe-be skill"
```

---

## Task 9: xvibe-design Skill

**Files:**
- Create: `akajiwa/skills/xvibe-design/SKILL.md`

- [ ] **Step 1: Create SKILL.md**

Create `D:/Projects/akajiwa/skills/xvibe-design/SKILL.md`:

```md
---
name: xvibe-design
description: Fast-iteration mode for UI/UX design. Minimal explanation, focused outputs. Use Haiku for simple tasks (copy edits, color changes). Use Sonnet for complex tasks (full layouts, design systems, interaction patterns).
---

# Fast Design Iteration

## Mode

Minimal explanation. No scaffolding. Build exactly what is described, nothing more.

## Context

You are working on design decisions:
- Layout and visual hierarchy
- Copy for labels, CTAs, empty states, errors
- Color, typography, spacing
- Interaction patterns and transitions
- Component states (default, hover, active, error, empty, loading)

Read `.claude/CLAUDE.md` and any design artifact in `docs/plans/` for project conventions.

## Model guide

/xplan determines difficulty and recommends the model. Follow that recommendation:
- Simple tasks (copy edits, color changes, spacing adjustments): Haiku
- Complex tasks (full layout design, interaction patterns, design systems): Sonnet

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
```

- [ ] **Step 2: Commit**

```bash
git add skills/xvibe-design/
git commit -m "feat: add /xvibe-design skill"
```

---

## Task 10: xqa Skill

**Files:**
- Create: `akajiwa/skills/xqa/SKILL.md`

- [ ] **Step 1: Create SKILL.md**

Create `D:/Projects/akajiwa/skills/xqa/SKILL.md`:

```md
---
name: xqa
description: Generate a Playwright test plan for a flow. Covers happy path, edge cases, error states, and persistence. Generates a test file scaffold alongside the plan.
---

# QA Test Plan

## Process

Read `.claude/CLAUDE.md` and any plan artifact in `docs/plans/` for the feature being tested.

Ask if not clear: "Which flow or feature should I write tests for?"

## Test plan structure

For the described flow, generate tests covering:

1. Happy path — the main success scenario end to end
2. Edge cases — boundary conditions, empty inputs, maximum values
3. Error states — what happens when things fail (network error, validation error, server error)
4. Persistence — state that should survive page reload or re-login
5. Auth boundary — does the flow require login, and is it blocked without it?

## Output

Generate two things:

**1. Test plan (prose)** — list every scenario with a one-line description

**2. Playwright test scaffold** — actual test file with:
- Correct file path following project conventions (`tests/e2e/[feature].spec.ts`)
- All scenarios as `test()` blocks with descriptive names
- `page.goto()` calls with correct routes
- `expect()` assertions for each scenario
- `test.beforeEach()` for shared setup (login, seed data)

Use `data-testid` attributes for element selectors. If the feature has no `data-testid` attributes yet, note which elements need them.

## Rules

- No emojis
- Every test block must have at least one assertion
- Never use `page.waitForTimeout()` — use `page.waitForSelector()` or `expect().toBeVisible()`
- Test names must describe the expected behavior, not the implementation
```

- [ ] **Step 2: Commit**

```bash
git add skills/xqa/
git commit -m "feat: add /xqa skill"
```

---

## Task 11: xinit Skill

**Files:**
- Create: `akajiwa/skills/xinit/SKILL.md`

- [ ] **Step 1: Create SKILL.md**

Create `D:/Projects/akajiwa/skills/xinit/SKILL.md`:

```md
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
```

- [ ] **Step 2: Commit**

```bash
git add skills/xinit/
git commit -m "feat: add /xinit skill"
```

---

## Task 12: xretro Skill

**Files:**
- Create: `akajiwa/skills/xretro/SKILL.md`

- [ ] **Step 1: Create SKILL.md**

Create `D:/Projects/akajiwa/skills/xretro/SKILL.md`:

```md
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
```

- [ ] **Step 2: Commit**

```bash
git add skills/xretro/
git commit -m "feat: add /xretro skill"
```

---

## Task 13: xreflect Skill

**Files:**
- Create: `akajiwa/skills/xreflect/SKILL.md`

- [ ] **Step 1: Create SKILL.md**

Create `D:/Projects/akajiwa/skills/xreflect/SKILL.md`:

```md
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
```

- [ ] **Step 2: Commit**

```bash
git add skills/xreflect/
git commit -m "feat: add /xreflect skill"
```

---

## Task 14: update-memory Skill

**Files:**
- Create: `akajiwa/skills/update-memory/SKILL.md`

- [ ] **Step 1: Create SKILL.md**

Create `D:/Projects/akajiwa/skills/update-memory/SKILL.md`:

```md
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
```

- [ ] **Step 2: Commit**

```bash
git add skills/update-memory/
git commit -m "feat: add /update-memory skill"
```

---

## Task 15: get-memory Skill

**Files:**
- Create: `akajiwa/skills/get-memory/SKILL.md`

- [ ] **Step 1: Create SKILL.md**

Create `D:/Projects/akajiwa/skills/get-memory/SKILL.md`:

```md
---
name: get-memory
description: Pull latest shared memory and config updates from the config repo. Re-symlinks skills if anything changed. Reports what was updated.
---

# Pull Shared Memory

## Process

Read the config repo path from `~/.claude/.akajiwa-config-path`.

If the file does not exist, output:

```
Config repo path not found at ~/.claude/.akajiwa-config-path.
Re-run the installer to set it up: ./install.sh or ./install.ps1
```

Run in the config repo directory:

```bash
git pull
```

After pulling, compare the updated files with their installed versions:

- If `CLAUDE.md` changed: copy to `~/.claude/CLAUDE.md` (merge if user has local additions)
- If `memory/memory.md` changed: copy to `~/.claude/memory/memory.md`
- If `memory/features-index.md` changed: copy to `~/.claude/memory/features-index.md`
- If any skill changed: re-symlink that skill

Report what changed:

```
Updated: memory/memory.md (+N new entries)
Updated: skills/xretro (new version)
No changes: CLAUDE.md, 10 other skills
```

If nothing changed: "Already up to date."

## Rules

- No emojis
- Never overwrite local additions to CLAUDE.md — merge by appending remote changes
- Report every changed file — do not silently update
```

- [ ] **Step 2: Commit**

```bash
git add skills/get-memory/
git commit -m "feat: add /get-memory skill"
```

---

## Task 16: install.sh and uninstall.sh

**Files:**
- Create: `akajiwa/install.sh`
- Create: `akajiwa/uninstall.sh`

- [ ] **Step 1: Create install.sh**

Create `D:/Projects/akajiwa/install.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_HOME="$HOME/.claude"
SKILLS_DIR="$CLAUDE_HOME/skills"
MEMORY_DIR="$CLAUDE_HOME/memory"
TEMPLATES_DIR="$CLAUDE_HOME/templates"
SETTINGS_FILE="$CLAUDE_HOME/settings.json"
CONFIG_PATH_FILE="$CLAUDE_HOME/.akajiwa-config-path"

echo "Akajiwa Claude Code Config - Installer"
echo "======================================="
echo ""

# 1. Create directories
mkdir -p "$SKILLS_DIR" "$MEMORY_DIR" "$TEMPLATES_DIR"

# 2. Save config repo path
echo "$SCRIPT_DIR" > "$CONFIG_PATH_FILE"
echo "Config path saved: $SCRIPT_DIR"

# 3. Merge CLAUDE.md
CLAUDE_MD="$CLAUDE_HOME/CLAUDE.md"
if [ -f "$CLAUDE_MD" ]; then
    if grep -q "Akajiwa" "$CLAUDE_MD" 2>/dev/null; then
        echo "CLAUDE.md: already configured"
    else
        printf "\n" >> "$CLAUDE_MD"
        cat "$SCRIPT_DIR/CLAUDE.md" >> "$CLAUDE_MD"
        echo "CLAUDE.md: merged"
    fi
else
    cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_MD"
    echo "CLAUDE.md: created"
fi

# 4. Copy project template
cp "$SCRIPT_DIR/templates/project-claude.md" "$TEMPLATES_DIR/project-claude.md"
echo "Template: project-claude.md installed"

# 5. Symlink skills
for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    skill_name="$(basename "$skill_dir")"
    target="$SKILLS_DIR/$skill_name"
    [ -L "$target" ] && rm "$target"
    [ -d "$target" ] && rm -rf "$target"
    ln -s "$skill_dir" "$target"
    echo "Skill: $skill_name linked"
done

# 6. Merge settings.json
HOOK_CONFIG="$(cat <<'EOF'
{
  "hooks": {
    "Stop": [{"matcher": "", "hooks": [{"type": "command", "command": "claude /xretro"}]}],
    "PreToolUse": [{"matcher": "Bash", "hooks": [{"type": "command", "command": "echo \"RTK reminder: prefix terminal commands with rtk\""}]}]
  }
}
EOF
)"

if [ -f "$SETTINGS_FILE" ]; then
    python3 - <<PYEOF
import json

with open('$SETTINGS_FILE', 'r') as f:
    existing = json.load(f)

new_hooks = {
    "Stop": [{"matcher": "", "hooks": [{"type": "command", "command": "claude /xretro"}]}],
    "PreToolUse": [{"matcher": "Bash", "hooks": [{"type": "command", "command": "echo 'RTK reminder: prefix terminal commands with rtk'"}]}]
}

if 'hooks' not in existing:
    existing['hooks'] = {}

for hook_type, hook_list in new_hooks.items():
    if hook_type not in existing['hooks']:
        existing['hooks'][hook_type] = hook_list
    else:
        existing_cmds = [
            h.get('hooks', [{}])[0].get('command', '')
            for h in existing['hooks'][hook_type]
        ]
        for hook in hook_list:
            cmd = hook.get('hooks', [{}])[0].get('command', '')
            if cmd not in existing_cmds:
                existing['hooks'][hook_type].append(hook)

with open('$SETTINGS_FILE', 'w') as f:
    json.dump(existing, f, indent=2)
PYEOF
    echo "settings.json: hooks merged"
else
    echo "$HOOK_CONFIG" > "$SETTINGS_FILE"
    echo "settings.json: created"
fi

# 7. Initialize memory files
if [ ! -f "$MEMORY_DIR/memory.md" ]; then
    cp "$SCRIPT_DIR/memory/memory.md" "$MEMORY_DIR/memory.md"
    echo "memory/memory.md: created"
else
    echo "memory/memory.md: already exists, skipping"
fi

if [ ! -f "$MEMORY_DIR/features-index.md" ]; then
    cp "$SCRIPT_DIR/memory/features-index.md" "$MEMORY_DIR/features-index.md"
    echo "memory/features-index.md: created"
else
    echo "memory/features-index.md: already exists, skipping"
fi

# 8. Install RTK
install_rtk() {
    if command -v rtk &>/dev/null; then
        echo "RTK: already installed ($(rtk --version 2>/dev/null || echo 'version unknown'))"
        return 0
    fi

    local os arch os_name binary_name url version rtk_dir

    os="$(uname -s | tr '[:upper:]' '[:lower:]')"
    arch="$(uname -m)"

    case "$arch" in
        x86_64)  arch="x86_64" ;;
        arm64|aarch64) arch="aarch64" ;;
        *)
            echo "RTK: unsupported architecture $arch"
            echo "     Install manually: https://github.com/rtk-ai/rtk/releases"
            return 0
            ;;
    esac

    case "$os" in
        darwin) os_name="apple-darwin" ;;
        linux)  os_name="unknown-linux-gnu" ;;
        *)
            echo "RTK: unsupported OS $os"
            echo "     Install manually: https://github.com/rtk-ai/rtk/releases"
            return 0
            ;;
    esac

    echo "RTK: fetching latest version..."
    version="$(curl -fsSL https://api.github.com/repos/rtk-ai/rtk/releases/latest \
        | grep '"tag_name"' \
        | sed 's/.*"tag_name": *"\(.*\)".*/\1/')" || {
        echo "RTK: could not reach GitHub"
        echo "     Install manually: https://github.com/rtk-ai/rtk/releases"
        return 0
    }

    binary_name="rtk-${arch}-${os_name}"
    url="https://github.com/rtk-ai/rtk/releases/download/${version}/${binary_name}"

    if [ -w "/usr/local/bin" ]; then
        rtk_dir="/usr/local/bin"
    else
        rtk_dir="$HOME/.local/bin"
        mkdir -p "$rtk_dir"
        if [[ ":$PATH:" != *":$rtk_dir:"* ]]; then
            echo "export PATH=\"\$PATH:$rtk_dir\"" >> "$HOME/.bashrc"
            echo "export PATH=\"\$PATH:$rtk_dir\"" >> "$HOME/.zshrc" 2>/dev/null || true
            echo "RTK: added $rtk_dir to PATH in .bashrc / .zshrc"
        fi
    fi

    echo "RTK: downloading $version ($arch-$os_name)..."
    curl -fsSL "$url" -o "$rtk_dir/rtk" || {
        echo "RTK: download failed"
        echo "     Install manually: https://github.com/rtk-ai/rtk/releases"
        return 0
    }
    chmod +x "$rtk_dir/rtk"

    if "$rtk_dir/rtk" --version &>/dev/null; then
        echo "RTK: installed ($("$rtk_dir/rtk" --version))"
    else
        echo "RTK: installed to $rtk_dir/rtk — restart terminal to use"
    fi
}

install_rtk

echo ""
echo "======================================="
echo "Installation complete."
echo ""
echo "Commands available:"
echo "  Heavy (Opus recommended):"
echo "    /xplan         Plan a feature before building"
echo "    /xdesign       UI/UX design brief"
echo "    /xreview       Code or design review"
echo ""
echo "  Light (Sonnet / Haiku):"
echo "    /xvibe-fe      Fast iteration - frontend"
echo "    /xvibe-be      Fast iteration - backend"
echo "    /xvibe-design  Fast iteration - design"
echo "    /xqa           Playwright test plan"
echo "    /xinit         Set up project config"
echo "    /xretro        Session retrospective (auto on session end)"
echo "    /xreflect      Promote patterns to global config"
echo "    /update-memory Push project memory"
echo "    /get-memory    Pull latest shared memory"

# Check optional co-op skills
COOP_SKILLS=(
    "frontend-dev-guidelines:/xvibe-fe — React/TypeScript component guidance"
    "frontend-design-pro:/xvibe-fe — distinctive visual treatment"
    "debugging:/xvibe-fe /xvibe-be — systematic debugging"
    "databases:/xvibe-be — MongoDB and Mongoose guidance"
    "backend-development:/xvibe-be — service layer and API architecture"
    "ui-ux-pro-max:/xvibe-design — full UI/UX design intelligence"
    "aesthetic:/xvibe-design — opinionated visual beauty"
    "web-design-guidelines:/xvibe-design — UI guideline validation"
)

MISSING_COOPS=()
for entry in "${COOP_SKILLS[@]}"; do
    skill="${entry%%:*}"
    desc="${entry#*:}"
    if [ ! -d "$SKILLS_DIR/$skill" ]; then
        MISSING_COOPS+=("  $skill  ->  $desc")
    fi
done

echo ""
if [ ${#MISSING_COOPS[@]} -eq 0 ]; then
    echo "All optional co-op skills found."
else
    echo "Optional co-op skills not found (your config works without them):"
    for item in "${MISSING_COOPS[@]}"; do
        echo "$item"
    done
fi
```

- [ ] **Step 2: Make install.sh executable**

```bash
chmod +x /d/Projects/akajiwa/install.sh
```

- [ ] **Step 3: Create uninstall.sh**

Create `D:/Projects/akajiwa/uninstall.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

CLAUDE_HOME="$HOME/.claude"
SKILLS_DIR="$CLAUDE_HOME/skills"

echo "Akajiwa Claude Code Config - Uninstaller"
echo "========================================="
echo ""

SKILLS=(xplan xdesign xreview xvibe-fe xvibe-be xvibe-design xqa xinit xretro xreflect update-memory get-memory)

for skill in "${SKILLS[@]}"; do
    target="$SKILLS_DIR/$skill"
    if [ -L "$target" ] || [ -d "$target" ]; then
        rm -rf "$target"
        echo "Removed: $skill"
    fi
done

rm -f "$CLAUDE_HOME/.akajiwa-config-path"
echo "Removed: config path file"

echo ""
echo "Done."
echo "CLAUDE.md, settings.json hooks, and memory files were not removed."
echo "Remove them manually if needed:"
echo "  ~/.claude/CLAUDE.md"
echo "  ~/.claude/memory/"
echo "  ~/.claude/settings.json (remove the Stop and PreToolUse hooks)"
```

- [ ] **Step 4: Make uninstall.sh executable**

```bash
chmod +x /d/Projects/akajiwa/uninstall.sh
```

- [ ] **Step 5: Commit**

```bash
git add install.sh uninstall.sh
git commit -m "feat: add Mac/Linux installer and uninstaller"
```

---

## Task 17: install.ps1 and uninstall.ps1

**Files:**
- Create: `akajiwa/install.ps1`
- Create: `akajiwa/uninstall.ps1`

- [ ] **Step 1: Create install.ps1**

Create `D:/Projects/akajiwa/install.ps1`:

```powershell
$ErrorActionPreference = "Stop"

$ScriptDir    = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ClaudeHome   = Join-Path $env:USERPROFILE ".claude"
$SkillsDir    = Join-Path $ClaudeHome "skills"
$MemoryDir    = Join-Path $ClaudeHome "memory"
$TemplatesDir = Join-Path $ClaudeHome "templates"
$SettingsFile = Join-Path $ClaudeHome "settings.json"
$ConfigPathFile = Join-Path $ClaudeHome ".akajiwa-config-path"

Write-Host "Akajiwa Claude Code Config - Installer"
Write-Host "======================================="
Write-Host ""

# 1. Create directories
New-Item -ItemType Directory -Force -Path $SkillsDir    | Out-Null
New-Item -ItemType Directory -Force -Path $MemoryDir    | Out-Null
New-Item -ItemType Directory -Force -Path $TemplatesDir | Out-Null

# 2. Save config repo path
Set-Content -Path $ConfigPathFile -Value $ScriptDir -Encoding utf8
Write-Host "Config path saved: $ScriptDir"

# 3. Merge CLAUDE.md
$ClaudeMdPath = Join-Path $ClaudeHome "CLAUDE.md"
if (Test-Path $ClaudeMdPath) {
    $existing = Get-Content $ClaudeMdPath -Raw -Encoding utf8
    if ($existing -match "Akajiwa") {
        Write-Host "CLAUDE.md: already configured"
    } else {
        $newContent = Get-Content (Join-Path $ScriptDir "CLAUDE.md") -Raw -Encoding utf8
        Add-Content -Path $ClaudeMdPath -Value "`n$newContent" -Encoding utf8
        Write-Host "CLAUDE.md: merged"
    }
} else {
    Copy-Item (Join-Path $ScriptDir "CLAUDE.md") $ClaudeMdPath
    Write-Host "CLAUDE.md: created"
}

# 4. Copy project template
Copy-Item (Join-Path $ScriptDir "templates\project-claude.md") (Join-Path $TemplatesDir "project-claude.md") -Force
Write-Host "Template: project-claude.md installed"

# 5. Symlink skills (junction for directories on Windows)
$SkillsSource = Join-Path $ScriptDir "skills"
Get-ChildItem $SkillsSource -Directory | ForEach-Object {
    $skillName = $_.Name
    $target = Join-Path $SkillsDir $skillName
    if (Test-Path $target) { Remove-Item $target -Recurse -Force }
    New-Item -ItemType Junction -Path $target -Target $_.FullName | Out-Null
    Write-Host "Skill: $skillName linked"
}

# 6. Merge settings.json
$newHooks = @{
    Stop = @(@{
        matcher = ""
        hooks = @(@{ type = "command"; command = "claude /xretro" })
    })
    PreToolUse = @(@{
        matcher = "Bash"
        hooks = @(@{ type = "command"; command = "echo RTK reminder: prefix terminal commands with rtk" })
    })
}

if (Test-Path $SettingsFile) {
    $raw = Get-Content $SettingsFile -Raw -Encoding utf8
    $existing = $raw | ConvertFrom-Json

    if (-not $existing.PSObject.Properties['hooks']) {
        $existing | Add-Member -NotePropertyName hooks -NotePropertyValue ([PSCustomObject]@{})
    }

    foreach ($hookType in $newHooks.Keys) {
        if (-not $existing.hooks.PSObject.Properties[$hookType]) {
            $existing.hooks | Add-Member -NotePropertyName $hookType -NotePropertyValue $newHooks[$hookType]
        }
    }

    $existing | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile -Encoding utf8
    Write-Host "settings.json: hooks merged"
} else {
    @{ hooks = $newHooks } | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile -Encoding utf8
    Write-Host "settings.json: created"
}

# 7. Memory files
$memoryMd     = Join-Path $MemoryDir "memory.md"
$featuresIdx  = Join-Path $MemoryDir "features-index.md"

if (-not (Test-Path $memoryMd)) {
    Copy-Item (Join-Path $ScriptDir "memory\memory.md") $memoryMd
    Write-Host "memory/memory.md: created"
} else {
    Write-Host "memory/memory.md: already exists, skipping"
}

if (-not (Test-Path $featuresIdx)) {
    Copy-Item (Join-Path $ScriptDir "memory\features-index.md") $featuresIdx
    Write-Host "memory/features-index.md: created"
} else {
    Write-Host "memory/features-index.md: already exists, skipping"
}

# 8. Install RTK
function Install-RTK {
    if (Get-Command rtk -ErrorAction SilentlyContinue) {
        $ver = & rtk --version 2>$null
        Write-Host "RTK: already installed ($ver)"
        return
    }

    Write-Host "RTK: fetching latest version..."

    try {
        $release = Invoke-RestMethod "https://api.github.com/repos/rtk-ai/rtk/releases/latest" -UseBasicParsing
        $version = $release.tag_name
    } catch {
        Write-Host "RTK: could not reach GitHub"
        Write-Host "     Install manually: https://github.com/rtk-ai/rtk/releases"
        return
    }

    $is64 = [System.Environment]::Is64BitOperatingSystem
    $arch = if ($is64) { "x86_64" } else { "i686" }
    $binaryName = "rtk-${arch}-pc-windows-msvc.exe"
    $url = "https://github.com/rtk-ai/rtk/releases/download/$version/$binaryName"

    $rtkDir  = "C:\tools\rtk"
    $rtkPath = Join-Path $rtkDir "rtk.exe"
    New-Item -ItemType Directory -Force -Path $rtkDir | Out-Null

    Write-Host "RTK: downloading $version ($arch)..."

    try {
        Invoke-WebRequest -Uri $url -OutFile $rtkPath -UseBasicParsing
    } catch {
        Write-Host "RTK: download failed"
        Write-Host "     Install manually: https://github.com/rtk-ai/rtk/releases"
        return
    }

    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$rtkDir*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$rtkDir", "User")
        $env:Path = "$env:Path;$rtkDir"
        Write-Host "RTK: added $rtkDir to user PATH"
    }

    Write-Host "RTK: installed ($version)"
}

Install-RTK

Write-Host ""
Write-Host "======================================="
Write-Host "Installation complete."
Write-Host ""
Write-Host "Commands available:"
Write-Host "  Heavy (Opus recommended):"
Write-Host "    /xplan         Plan a feature before building"
Write-Host "    /xdesign       UI/UX design brief"
Write-Host "    /xreview       Code or design review"
Write-Host ""
Write-Host "  Light (Sonnet / Haiku):"
Write-Host "    /xvibe-fe      Fast iteration - frontend"
Write-Host "    /xvibe-be      Fast iteration - backend"
Write-Host "    /xvibe-design  Fast iteration - design"
Write-Host "    /xqa           Playwright test plan"
Write-Host "    /xinit         Set up project config"
Write-Host "    /xretro        Session retrospective (auto on session end)"
Write-Host "    /xreflect      Promote patterns to global config"
Write-Host "    /update-memory Push project memory"
Write-Host "    /get-memory    Pull latest shared memory"

# Check optional co-op skills
$coopSkills = @(
    @{ name = "frontend-dev-guidelines"; desc = "/xvibe-fe — React/TypeScript component guidance" }
    @{ name = "frontend-design-pro";     desc = "/xvibe-fe — distinctive visual treatment" }
    @{ name = "debugging";               desc = "/xvibe-fe /xvibe-be — systematic debugging" }
    @{ name = "databases";               desc = "/xvibe-be — MongoDB and Mongoose guidance" }
    @{ name = "backend-development";     desc = "/xvibe-be — service layer and API architecture" }
    @{ name = "ui-ux-pro-max";           desc = "/xvibe-design — full UI/UX design intelligence" }
    @{ name = "aesthetic";               desc = "/xvibe-design — opinionated visual beauty" }
    @{ name = "web-design-guidelines";   desc = "/xvibe-design — UI guideline validation" }
)

$missingCoops = $coopSkills | Where-Object { -not (Test-Path (Join-Path $SkillsDir $_.name)) }

Write-Host ""
if ($missingCoops.Count -eq 0) {
    Write-Host "All optional co-op skills found."
} else {
    Write-Host "Optional co-op skills not found (your config works without them):"
    foreach ($skill in $missingCoops) {
        Write-Host "  $($skill.name)  ->  $($skill.desc)"
    }
}
```

- [ ] **Step 2: Create uninstall.ps1**

Create `D:/Projects/akajiwa/uninstall.ps1`:

```powershell
$ClaudeHome  = Join-Path $env:USERPROFILE ".claude"
$SkillsDir   = Join-Path $ClaudeHome "skills"
$ConfigPathFile = Join-Path $ClaudeHome ".akajiwa-config-path"

Write-Host "Akajiwa Claude Code Config - Uninstaller"
Write-Host "========================================="
Write-Host ""

$skills = @("xplan","xdesign","xreview","xvibe-fe","xvibe-be","xvibe-design","xqa","xinit","xretro","xreflect","update-memory","get-memory")

foreach ($skill in $skills) {
    $target = Join-Path $SkillsDir $skill
    if (Test-Path $target) {
        Remove-Item $target -Recurse -Force
        Write-Host "Removed: $skill"
    }
}

if (Test-Path $ConfigPathFile) {
    Remove-Item $ConfigPathFile -Force
    Write-Host "Removed: config path file"
}

Write-Host ""
Write-Host "Done."
Write-Host "CLAUDE.md, settings.json hooks, and memory files were not removed."
Write-Host "Remove them manually if needed:"
Write-Host "  $ClaudeHome\CLAUDE.md"
Write-Host "  $ClaudeHome\memory\"
Write-Host "  $ClaudeHome\settings.json (remove Stop and PreToolUse hooks)"
```

- [ ] **Step 3: Commit**

```bash
git add install.ps1 uninstall.ps1
git commit -m "feat: add Windows installer and uninstaller"
```

---

## Task 18: README.md

**Files:**
- Create: `akajiwa/README.md`

- [ ] **Step 1: Create README.md**

Create `D:/Projects/akajiwa/README.md`:

```md
# Akajiwa — Claude Code Config

Personal Claude Code config for a solo PM + product engineer + UX designer. Layered config, task-specific commands, and a self-upgrading memory loop that reduces AI slop over time.

---

## Installation

### Prerequisites

- Claude Code installed
- Git installed
- Internet connection (RTK downloads automatically)

### Mac / Linux

```bash
git clone https://github.com/yourname/akajiwa-config
cd akajiwa-config
chmod +x install.sh
./install.sh
```

### Windows

```powershell
git clone https://github.com/yourname/akajiwa-config
cd akajiwa-config
./install.ps1
```

The installer:
- Merges global CLAUDE.md into `~/.claude/CLAUDE.md`
- Symlinks all commands into `~/.claude/skills/`
- Configures the Stop hook (auto-retro on session end)
- Downloads and installs RTK for your OS and architecture
- Creates memory files at `~/.claude/memory/`

### Updating on an existing machine

```
/get-memory
```

---

## Commands

### Heavy — switch to Opus first. Commands will remind you if you forget.

| Command | What it does |
|---|---|
| `/xplan` | Plan a feature before building. Determines FE/BE scope, difficulty, and recommends which vibe command and model to use. Generates plan artifacts in `docs/plans/`. |
| `/xdesign` | UI/UX design brief. Checks for existing components before proposing new ones. Generates design artifact in `docs/plans/`. |
| `/xreview` | Fresh-context code or design review. Reads the diff and flags issues against quality standards, SonarQube rules, and anti-slop standards. |

### Light — model is determined by /xplan difficulty assessment.

| Command | What it does |
|---|---|
| `/xvibe-fe` | Fast iteration for frontend — components, hooks, UI, styling. Haiku for simple, Sonnet for complex. |
| `/xvibe-be` | Fast iteration for backend — routes, models, middleware. Haiku for simple, Sonnet for complex. |
| `/xvibe-design` | Fast iteration for design — layout, visuals, copy. Haiku for simple, Sonnet for complex. |
| `/xqa` | Generate a Playwright test plan and scaffold for a flow. |
| `/xinit` | Set up project config for an existing project without planning a feature. |
| `/xretro` | Session retrospective. Captures corrections, patterns, and discoveries to memory. Runs automatically at session end. |
| `/xreflect` | Promote recurring patterns (3+) to global CLAUDE.md. Commits and pushes to this repo on approval. |
| `/update-memory` | Commit and push project memory to the project repo. |
| `/get-memory` | Pull latest shared memory and config updates from this repo. |

---

## Workflow

### Any project (new or existing)

1. Open Claude Code in your project folder
2. Run `/xplan` and describe what you want to build
   - First time in this project: setup runs automatically, no `/xinit` needed
3. Follow the model recommendation from `/xplan`
4. Build using `/xvibe-fe`, `/xvibe-be`, or `/xvibe-design`
5. Run `/xqa` before finishing a flow
6. Run `/xreview` before committing
7. End the session — `/xretro` fires automatically

### Setting up an existing project without a feature to plan

Run `/xinit` once. Then use `/xplan` for all future sessions.

### How the config gets smarter over time

- Corrections you make during sessions are captured by `/xretro` automatically
- Patterns that repeat 3 or more times: `/xreflect` proposes a config update
- You approve — the change is committed and pushed to this repo
- Other machines run `/get-memory` to receive the update

### Model guide

| Model | Commands |
|---|---|
| Opus | `/xplan`, `/xdesign`, `/xreview` |
| Sonnet | `/xqa`, `/xinit`, `/xretro`, `/xreflect`, complex `/xvibe-*` tasks |
| Haiku | `/update-memory`, `/get-memory`, simple `/xvibe-*` tasks |

---

## Memory architecture

| Layer | Location | Scope |
|---|---|---|
| Shared standards | `memory/memory.md` in this repo | All projects, all machines |
| Features index | `memory/features-index.md` in this repo | Cross-project feature awareness |
| Project learnings | `.claude/memory/memory.md` in each project repo | That project only |

---

## Uninstall

### Mac / Linux

```bash
./uninstall.sh
```

### Windows

```powershell
./uninstall.ps1
```
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: add README with installation, commands, and workflow guide"
```

---

## Task 19: Final verification

- [ ] **Step 1: Verify folder structure**

```bash
find /d/Projects/akajiwa -not -path '*/.git/*' | sort
```

Expected output should show all files from the file map at the top of this plan.

- [ ] **Step 2: Run installer on current machine**

```bash
cd /d/Projects/akajiwa
./install.sh
```

Expected:
- All skills linked in `~/.claude/skills/`
- settings.json has Stop hook and PreToolUse hook
- memory files exist at `~/.claude/memory/`
- RTK installed or already present

- [ ] **Step 3: Verify skills are discoverable**

Open Claude Code and run:

```
/xplan  test
```

Expected: model check output appears, then setup questions begin.

- [ ] **Step 4: Verify Stop hook**

End a Claude Code session naturally. Check that `/xretro` output appears.

- [ ] **Step 5: Final commit**

```bash
git add -A
git commit -m "chore: final structure verification"
```

- [ ] **Step 6: Push to GitHub**

Create a new GitHub repository named `akajiwa-config` (private), then:

```bash
git remote add origin https://github.com/yourname/akajiwa-config.git
git branch -M main
git push -u origin main
```
```
