#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Configuring Git..."
git config --global user.email 'kazemi.soroush@gmail.com'
git config --global user.name 'Soroush Kazemi'
git config --global --add safe.directory /workspaces/harness

echo "Installing Persian fonts (Vazirmatn + Noto Arabic)..."
sudo apt-get update -qq && sudo apt-get install -y -qq fonts-farsiweb fonts-noto-core fonts-noto-extra 2>/dev/null
mkdir -p ~/.local/share/fonts
curl -sL -o /tmp/vazirmatn.zip "https://github.com/rastikerdar/vazirmatn/releases/download/v33.003/vazirmatn-v33.003.zip"
unzip -qo /tmp/vazirmatn.zip -d ~/.local/share/fonts
rm -f /tmp/vazirmatn.zip
fc-cache -f

if [ -f requirements.txt ]; then
    echo "Installing Python dependencies..."
    python3 -m pip install --break-system-packages -r requirements.txt
else
    echo "No requirements.txt found, skipping Python deps."
fi

echo "Installing SuperClaude Framework..."
if ! command -v pipx &>/dev/null; then
    python3 -m pip install --user --quiet pipx
    export PATH="$HOME/.local/bin:$PATH"
fi
pipx install superclaude
superclaude install

echo "Configuring Claude Code statusline..."
mkdir -p "$HOME/.claude"
install -m 0755 "$SCRIPT_DIR/statusline.sh" "$HOME/.claude/statusline.sh"

python3 - <<'PY'
import json, os
path = os.path.expanduser("~/.claude/settings.json")
data = {}
if os.path.exists(path):
    try:
        with open(path) as f:
            data = json.load(f)
    except Exception:
        data = {}
data["statusLine"] = {
    "type": "command",
    "command": "bash ~/.claude/statusline.sh",
    "padding": 0,
}
with open(path, "w") as f:
    json.dump(data, f, indent=2)
print(f"Wrote statusLine config to {path}")
PY
