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
