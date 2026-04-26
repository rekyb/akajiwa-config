# Akajiwa — Claude Code Config

Senior Solo PM + Senior product engineer + Senior UI/UX designer config. Layered commands, automated RTK workflow, and a self-upgrading memory loop that reduces AI slop over time.

---

## Installation

### Prerequisites

- Claude Code installed
- Git installed
- Internet connection (RTK downloads automatically)

### Mac / Linux

```bash
git clone https://github.com/rekyb/akajiwa-config
cd akajiwa-config
chmod +x install.sh
./install.sh
```

### Windows

```powershell
git clone https://github.com/rekyb/akajiwa-config
cd akajiwa-config
./install.ps1
```

The installer:
- Merges global CLAUDE.md into `~/.claude/CLAUDE.md`
- Symlinks all commands into `~/.claude/skills/`
- Configures RTK auto-prefix hook (automatically prefixes commands with `rtk`)
- Configures the Stop hook (auto-retro on session end)
- Downloads and installs RTK for your OS and architecture
- Creates memory files at `~/.claude/memory/`

### Updating on an existing machine

```
/get-memory
```

---

## Commands

### Heavy — switch to Opus first.

| Command | What it does |
|---|---|
| `/xplan` | Plan a feature before building. Determines FE/BE scope, difficulty, and recommends which vibe command and model to use. Generates plan artifacts in `docs/plans/`. |
| `/xdesign` | UI/UX design brief with 4 execution modes (Explore, Prototype, Implement, Review). Loads design system and checks for component reuse. Generates design artifact in `docs/plans/`. |
| `/xreview` | Fresh-context code or design review. Reads the diff and flags issues against quality standards, SonarQube rules, and anti-slop standards. |

### Light — model determined by /xplan difficulty.

| Command | What it does |
|---|---|
| `/xvibe-fe` | Fast iteration for frontend — components, hooks, UI, styling. Haiku for simple, Sonnet for complex. |
| `/xvibe-be` | Fast iteration for backend — routes, models, middleware. Haiku for simple, Sonnet for complex. |
| `/xvibe-design` | Fast iteration for design — layout, visuals, copy. Auto-loads `/xdesign` artifacts and project design system. |
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
