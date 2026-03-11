#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${BOLD}  →${RESET} $*"; }
success() { echo -e "${GREEN}  ✓${RESET} $*"; }
warn()    { echo -e "${YELLOW}  !${RESET} $*"; }

echo ""
echo -e "${BOLD}ProseOutline installer${RESET}"
echo "────────────────────────────────────────"
echo ""

# ---------------------------------------------------------------------------
# 1. Install uv if not present
# ---------------------------------------------------------------------------

if ! command -v uv &>/dev/null; then
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # The uv installer adds ~/.local/bin to PATH for new shells; source it now
    export PATH="$HOME/.local/bin:$PATH"
fi

UV_VER=$(uv --version 2>&1 | head -1)
success "uv ready ($UV_VER)"

# ---------------------------------------------------------------------------
# 2. Install proseoutline as a uv tool
#    uv will pull Python 3.11 automatically if needed and create an
#    isolated venv — no manual venv management required.
# ---------------------------------------------------------------------------

info "Installing proseoutline (uv will fetch Python 3.11 if needed)..."
uv tool install proseoutline --python 3.11
success "proseoutline installed"

# ---------------------------------------------------------------------------
# 3. Ensure the uv tools bin is on PATH
# ---------------------------------------------------------------------------

TOOLS_BIN=$(uv tool dir --bin 2>/dev/null || echo "$HOME/.local/bin")

if [[ ":$PATH:" != *":$TOOLS_BIN:"* ]]; then
    echo ""
    warn "$TOOLS_BIN is not on your PATH yet."
    warn "Add this to your ~/.zshrc (or ~/.bashrc) and restart your terminal:"
    echo ""
    echo -e "    ${BOLD}export PATH=\"$TOOLS_BIN:\$PATH\"${RESET}"
    echo ""
else
    echo ""
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

echo -e "${GREEN}${BOLD}All done!${RESET} Run ${BOLD}proseoutline${RESET} to launch the app."
echo ""

