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
# 1. Ensure uv is installed
# ---------------------------------------------------------------------------

if ! command -v uv &>/dev/null; then
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

UV_VER=$(uv --version 2>&1 | head -1 || true)
success "uv ready (${UV_VER:-unknown version})"

# ---------------------------------------------------------------------------
# 2. Install or upgrade proseoutline
# ---------------------------------------------------------------------------

if uv tool list 2>/dev/null | grep -q '^proseoutline '; then
    info "Upgrading proseoutline..."
    uv tool upgrade proseoutline
else
    info "Installing proseoutline..."
    uv tool install proseoutline --python 3.11
fi

success "proseoutline ready"

# ---------------------------------------------------------------------------
# 3. Ensure PATH is correct
# ---------------------------------------------------------------------------

TOOLS_BIN="$(uv tool dir --bin 2>/dev/null || echo "$HOME/.local/bin")"

if [[ ":$PATH:" != *":$TOOLS_BIN:"* ]]; then
    echo ""
    warn "$TOOLS_BIN is not on your PATH."
    warn "Add this to your shell config (~/.zshrc or ~/.bashrc):"
    echo ""
    echo -e "    ${BOLD}export PATH=\"$TOOLS_BIN:\$PATH\"${RESET}"
    echo ""
else
    echo ""
fi

# ---------------------------------------------------------------------------
# 4. Final check
# ---------------------------------------------------------------------------

if command -v proseoutline &>/dev/null; then
    echo -e "${GREEN}${BOLD}All done!${RESET} Run ${BOLD}proseoutline${RESET} to launch."
else
    warn "proseoutline is installed but not on PATH yet."
    warn "Restart your terminal or update PATH."
fi

echo ""