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
