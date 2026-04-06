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
# 1. Ensure uv
# ---------------------------------------------------------------------------

if ! command -v uv &>/dev/null; then
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

UV_VER=$(uv --version 2>&1 | head -1 || true)
success "uv ready (${UV_VER:-unknown})"

# ---------------------------------------------------------------------------
# 2. Install OR upgrade proseoutline
# ---------------------------------------------------------------------------

if uv tool list 2>/dev/null | grep -q '^proseoutline '; then
    info "Updating proseoutline..."
    if uv tool upgrade proseoutline 2>&1 | grep -q "Nothing to upgrade"; then
        success "proseoutline already up to date"
    else
        success "proseoutline updated"
    fi
else
    info "Installing proseoutline..."
    uv tool install proseoutline --python 3.11
    success "proseoutline installed"
fi

# ---------------------------------------------------------------------------
# 3. Ensure PATH (immediate + persistent)
# ---------------------------------------------------------------------------

TOOLS_BIN="$(uv tool dir --bin 2>/dev/null || echo "$HOME/.local/bin")"

# Make it work in THIS session
export PATH="$TOOLS_BIN:$PATH"

# Persist it for future sessions
SHELL_RC="$HOME/.zshrc"
[[ -n "${BASH_VERSION:-}" ]] && SHELL_RC="$HOME/.bashrc"

if ! grep -q "$TOOLS_BIN" "$SHELL_RC" 2>/dev/null; then
    info "Adding ProseOutline to your PATH"
    echo "export PATH=\"$TOOLS_BIN:\$PATH\"" >> "$SHELL_RC"
    success "Saved to $SHELL_RC"
fi

# ---------------------------------------------------------------------------
# 4. Final experience
# ---------------------------------------------------------------------------

echo ""
success "ProseOutline is ready"

if command -v proseoutline &>/dev/null; then
    info "Launching ProseOutline..."
    proseoutline || true
else
    warn "Something went wrong — try restarting your terminal"
fi

echo ""