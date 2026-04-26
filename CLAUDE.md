# Akajiwa — Project Config

This extends the global `~/.claude/CLAUDE.md`. Only project-specific overrides and additions below.

## Code Standards (Project Overrides)

- **React components:** Use `'use client'` only for components that require browser APIs, event handlers, or React state. Never at the page level.
- **Default parameters:** Exception: React component prop destructuring is allowed.
- **Function length:** Logic/utility functions under 30 lines. JSX/render functions can be longer if well-structured.
- **Accessibility:** Always use semantic HTML (`<button>` not `<div onClick>`). Ensure keyboard navigability and correct ARIA states for all custom UI components.

## Stack Defaults

- Frontend: Next.js (App Router, prefer Server Components), strict TypeScript, MUI v7
- Backend: Express + Node, strict TypeScript
- Database: MongoDB + Mongoose
  - Use `.lean()` for read-only queries with strict projection
  - Define indexes in schema files, not ad hoc
  - Use schema-level validation for required fields
  - Never use raw `collection.` calls — always go through the model
- Testing: Playwright (E2E), Vitest (unit)
- Package manager: pnpm

## Project Navigation & Skills

- Custom skills located in `/skills` directory (`xplan`, `xdesign`, `xvibe-be`, `xvibe-fe`). Always check and invoke the appropriate skill before starting corresponding tasks.
- **Context Boundary:** Identify task domain as frontend, backend, or shared before searching/editing.
  - **Frontend:** `src/app/`, `src/components/`, `src/hooks/`, client-side logic
  - **Backend:** `src/api/`, `src/lib/`, `src/db/`, server-side logic
  - **Shared:** `src/types/`, `src/utils/`, `src/constants/`, `src/shared/`, used by both frontend and backend

## File & Folder Structure

- **Components:** `src/components/[ComponentName]/index.tsx` (co-locate styles, tests)
- **Hooks:** `src/hooks/use[Name].ts`
- **Types:** Co-locate with module; use `src/types/` only for types shared across domains
- **Utilities:** `src/utils/[domain]/` grouped by feature or domain
- **Constants:** `src/constants.ts` for global; `src/[domain]/constants.ts` for domain-specific
- **Tests:** Co-locate with source files: `src/components/Button/Button.test.tsx`

## Next.js Data Fetching & Server Actions

- **Reads in Server Components:** Use direct DB/service calls, avoid fetch when possible
- **Mutations:** Use Server Actions (`'use server'`) called from Client Components
- **Client-side state:** Only for UI state, not data that should be server-rendered
- **API routes:** Reserve `/api` for third-party webhooks or external consumers; internal code uses Server Actions
- **Caching:** Use `revalidateTag()` and `revalidatePath()` for mutations; ISR for static-regenerating pages

## API Design

- **Response shape:** Consistent structure for all endpoints
  ```typescript
  {
    data: T | null,
    error?: { code: string; message: string },
    meta?: { page: number; total: number }
  }
  ```
- **Error codes:** Machine-readable strings (e.g., `INVALID_INPUT`, `NOT_FOUND`, `AUTH_REQUIRED`), not natural language
- **HTTP status codes:** 200 (success), 201 (created), 400 (validation), 401 (auth), 403 (forbidden), 404 (not found), 500 (server error)
- **Pagination:** Use `page` and `limit` query params, return `meta: { page, total, hasMore }`

## Environment Variables

- Prefix public vars with `NEXT_PUBLIC_` (accessible in browser)
- Prefix private vars with no prefix (backend only)
- Validate all env vars at app startup using Zod
- Never log or commit `.env` files

## Execution & Validation Workflow

- **Plan first:** Before implementing a complex feature, write a plan or invoke `xplan` skill
- **Test-Driven:** After code changes, run Vitest: `rtk vitest run`
  - Enforce 80% coverage on new files before marking task complete
  - If coverage drops below 80%, do not mark task done
- **Build check:** If touching Next.js config or routing, run `rtk next build` to verify no SSR/RSC violations
- **Error Recovery:** Analyze error output completely before attempting fix. Do not blindly retry. Do not scatter `console.log` — use structured logging or debugger.

## Git & Commits

- Use Conventional Commits: `feat:`, `fix:`, `chore:`, `refactor:`, `test:`, `docs:`
- Keep commits atomic — one logical change per commit
- **Branch naming:** `type/short-description` (e.g., `feat/user-auth`, `fix/login-redirect`)
  - Use ticket ID prefix if applicable: `feat/PROJ-123-user-auth`
- Always propose draft commit message before autonomously committing

## Environment & Secrets

- Never log, print, or commit secrets or API keys
- Validate all environment variables at app boundary using Zod
- Use `.env.example` with placeholder values (no real secrets)
