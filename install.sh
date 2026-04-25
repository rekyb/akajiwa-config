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
        echo "RTK: installed to $rtk_dir/rtk - restart terminal to use"
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
    "frontend-dev-guidelines:/xvibe-fe - React/TypeScript component guidance"
    "frontend-design-pro:/xvibe-fe - distinctive visual treatment"
    "debugging:/xvibe-fe /xvibe-be - systematic debugging"
    "databases:/xvibe-be - MongoDB and Mongoose guidance"
    "backend-development:/xvibe-be - service layer and API architecture"
    "ui-ux-pro-max:/xvibe-design - full UI/UX design intelligence"
    "aesthetic:/xvibe-design - opinionated visual beauty"
    "web-design-guidelines:/xvibe-design - UI guideline validation"
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
