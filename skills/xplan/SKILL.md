---
name: xplan
description: Create structured execution plan with confidence scoring and risk assessment. Determines FE/BE scope, assesses difficulty, and recommends models. Opus recommended.
---

# Structured Feature Planning

## Step 0 — Force model switch to Opus

Run this before anything else:

```bash
python3 -c "
import json, pathlib
p = pathlib.Path('.claude/settings.json')
s = json.loads(p.read_text())
s['model'] = 'claude-opus-4-7'
p.write_text(json.dumps(s, indent=2))
print('Model set to claude-opus-4-7')
"
```

Confirm with: `Model: OPUS | Status: Planning`

## Step 1 — Project context & Scope Clarification

Check for `.claude/CLAUDE.md`. If missing, run setup as defined in `/xinit`.

**Multi-repo detection (Claude decides, does not ask):**
- Task involves any new or changed API endpoint → BE repo is in scope
- Task involves any UI component or page → FE repo is in scope
- Both → multi-repo task: verify both repos are accessible, confirm `.env`/`.env.local` exist, and require API Contract to be written before any implementation step

If ANY of these are ambiguous regarding the request, ask (one at a time):
```
Who?      [which user roles/personas?]
When?     [what triggers the feature?]
Output?   [one concrete example of expected behavior]
Boundary? [what is explicitly out of scope for this plan]
```

If the user provided enough context, skip — do NOT ask.

## Step 2 — Features index & Discovery

Read `~/.claude/memory/features-index.md`.
Surface relevant existing features if they can be reused or require integration.

## Step 3 — Research Phase (NEVER skip)

Systematically trace the feature impact:
- Read ALL related files.
- Trace the full path: UI Component → Hook → API Endpoint → Service Layer → Data Model.
- Identify exact file paths and function names for every layer.
- Write findings to `docs/plans/[feature-name]-context.md`.

## Step 4 — Plan Construction

Create `docs/plans/[feature-name]-plan.md` with:

- **Scope & Difficulty:** [FE only / BE only / Full stack] and [Simple / Complex].
- **API Contract:** (Required before implementation steps) method, path, request/response shapes.
- **User Role Coverage:** Matrix of which roles are affected and how per implementation step.
- **Plan Wiring:** Full call chains — UI → Hook → API → Service → DB — for every user-facing flow.
- **Component Breakdown:** Name, props, state, and responsibilities.
- **Implementation Steps:** Exact file paths, function names, and specific changes.
- **Test Plan (Mandatory):** For every implementation step (service, hook, component), list the test file path and exactly what it will assert.

## Step 5 — Self-Review

Before scoring, check every item:
- No vague steps — every step names exact file, function, and change
- No missing file paths
- Auth guards present on all protected endpoints
- Error paths documented for every external call
- Empty states handled in every UI component
- Wiring gaps — every call chain is complete end-to-end
- API Contract present and placed before implementation steps (multi-repo: both repos)
- No step writes "update X" without specifying exactly what changes

Fix any gaps before proceeding to scoring.

## Step 6 — Confidence Scoring

Calculate and include in the plan:
```
Base Score = (steps_with_zero_unknowns / total_steps) * 100
Deductions:
-3 per unchecked research item
-5 per MEDIUM unknown
-10 per HIGH unknown (ambiguity/missing docs)
Final Confidence: [Score]%
```

**Hard gate:** If there are more than 2 unresolved unknowns, stop. Do not present the plan. Surface the unknowns and ask the user to clarify or do more research before continuing.

## Step 7 — Update features index

Append the new feature to `~/.claude/memory/features-index.md` as soon as the plan is finalized.

## Step 8 — End with recommendation

Output the following summary block:

```
Scope: [FE only / BE only / Full stack]

Difficulty:
  BE: [Simple / Complex] — [one-line reason]
  FE: [Simple / Complex] — [one-line reason]

Confidence: [Score]% — [Reason for score and top risk]

Recommended:
  [/xvibe-be on Haiku/Sonnet] — [reason]
  [/xvibe-fe on Haiku/Sonnet] — [reason]

For full stack: build BE first (data layer), then FE.
```

If Confidence is < 85%, add:
"Recommendation: Perform more research or clarify [specific item] before building."

## Rules

- No emojis.
- NEVER skip the research phase.
- NEVER skip the self-review step.
- NEVER write "update X" — name exact file, function, and nature of the change.
- NEVER produce a plan without a corresponding test plan step for every implementation step.
- NEVER present a plan with more than 2 unresolved unknowns — surface them and stop.
- Ask one question at a time — never batch questions.
- Never write any implementation code — this command produces plans only.
- If Confidence is Low (< 70%), warn the user clearly before finishing the plan.
- Multi-repo: API Contract must appear in the plan before any implementation step.
