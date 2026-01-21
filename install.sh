#!/bin/bash

# IdeaRalph MCP Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/vibeforge1111/vibeship-idearalph/main/install.sh | bash
# With Spawner: curl -fsSL https://raw.githubusercontent.com/vibeforge1111/vibeship-idearalph/main/install.sh | bash -s -- --with-spawner

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Parse arguments
WITH_SPAWNER=false
for arg in "$@"; do
  case $arg in
    --with-spawner|-s)
      WITH_SPAWNER=true
      ;;
    --help|-h)
      echo ""
      echo -e "${BOLD}IdeaRalph MCP Installer${NC}"
      echo ""
      echo "Usage:"
      echo "  curl -fsSL https://raw.githubusercontent.com/vibeforge1111/vibeship-idearalph/main/install.sh | bash"
      echo ""
      echo "Options:"
      echo "  --with-spawner, -s   Also install Spawner skills (recommended)"
      echo "  --help, -h           Show this help message"
      echo ""
      echo "Examples:"
      echo -e "  ${CYAN}# Install IdeaRalph only${NC}"
      echo "  curl -fsSL https://idearalph.dev/install.sh | bash"
      echo ""
      echo -e "  ${CYAN}# Install IdeaRalph + Spawner (recommended)${NC}"
      echo "  curl -fsSL https://idearalph.dev/install.sh | bash -s -- --with-spawner"
      exit 0
      ;;
  esac
done

echo ""
echo -e "${BOLD}${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${BLUE}║        IdeaRalph MCP Installer        ║${NC}"
echo -e "${BOLD}${BLUE}╚═══════════════════════════════════════╝${NC}"
echo ""

# Check for required tools
if ! command -v node &> /dev/null; then
  echo -e "${RED}✗ Node.js is required but not installed.${NC}"
  echo "  Install from: https://nodejs.org"
  exit 1
fi

if ! command -v git &> /dev/null; then
  echo -e "${RED}✗ Git is required but not installed.${NC}"
  exit 1
fi

# Determine install location
INSTALL_DIR="$HOME/.idearalph"
MCP_SERVER_DIR="$INSTALL_DIR/mcp-server"

# Step 1: Create install directory
echo -e "${CYAN}[1/4]${NC} Setting up installation directory..."
mkdir -p "$INSTALL_DIR"

# Step 2: Clone or update MCP server
echo -e "${CYAN}[2/4]${NC} Downloading IdeaRalph MCP..."

if [ -d "$MCP_SERVER_DIR" ]; then
  echo -e "  ${YELLOW}Updating existing installation...${NC}"
  cd "$MCP_SERVER_DIR"
  git pull --quiet
else
  git clone --depth 1 --quiet https://github.com/vibeforge1111/vibeship-idearalph.git "$INSTALL_DIR/temp"
  mv "$INSTALL_DIR/temp/mcp-server" "$MCP_SERVER_DIR"
  rm -rf "$INSTALL_DIR/temp"
fi
echo -e "${GREEN}✓${NC} Downloaded IdeaRalph MCP"

# Step 3: Build MCP server
echo -e "${CYAN}[3/4]${NC} Building MCP server..."
cd "$MCP_SERVER_DIR"
npm install --silent
npm run build --silent
echo -e "${GREEN}✓${NC} Built MCP server"

# Step 4: Configure Claude Code
echo -e "${CYAN}[4/4]${NC} Configuring Claude Code..."

MCP_PATH="$MCP_SERVER_DIR/dist/index.js"

# Try using claude CLI first
if command -v claude &> /dev/null; then
  claude mcp add idearalph -- node "$MCP_PATH" 2>/dev/null && \
    echo -e "${GREEN}✓${NC} Added IdeaRalph to Claude Code" || \
    echo -e "${YELLOW}! Could not add via CLI, trying manual config...${NC}"
else
  echo -e "${YELLOW}! Claude CLI not found, configuring manually...${NC}"
fi

# Manual config as fallback
CONFIG_DIR="$HOME/.claude"
CONFIG_FILE="$CONFIG_DIR/claude_desktop_config.json"

mkdir -p "$CONFIG_DIR"

if [ -f "$CONFIG_FILE" ]; then
  # Add to existing config using node
  node -e "
    const fs = require('fs');
    const config = JSON.parse(fs.readFileSync('$CONFIG_FILE', 'utf-8'));
    if (!config.mcpServers) config.mcpServers = {};
    config.mcpServers.idearalph = { command: 'node', args: ['$MCP_PATH'] };
    fs.writeFileSync('$CONFIG_FILE', JSON.stringify(config, null, 2));
  " 2>/dev/null && echo -e "${GREEN}✓${NC} Updated Claude config" || true
else
  # Create new config
  echo '{
  "mcpServers": {
    "idearalph": {
      "command": "node",
      "args": ["'"$MCP_PATH"'"]
    }
  }
}' > "$CONFIG_FILE"
  echo -e "${GREEN}✓${NC} Created Claude config"
fi

# Optional: Install Spawner
if [ "$WITH_SPAWNER" = true ]; then
  echo ""
  echo -e "${BOLD}${BLUE}Installing Spawner Skills...${NC}"
  echo ""
  npx github:vibeforge1111/vibeship-spawner-skills install --mcp || {
    echo -e "${RED}✗ Failed to install Spawner${NC}"
    echo -e "  You can install it manually later:"
    echo -e "  ${CYAN}npx github:vibeforge1111/vibeship-spawner-skills install --mcp${NC}"
  }
fi

# Done!
echo ""
echo -e "${BOLD}${GREEN}╔═══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║          Installation Complete!       ║${NC}"
echo -e "${BOLD}${GREEN}╚═══════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}Restart Claude Code${NC} to use IdeaRalph."
echo ""
echo -e "${BOLD}Try it:${NC}"
echo '  "Help me brainstorm startup ideas in AI"'
echo '  "Validate my idea: [your idea]"'
echo '  "Create a PRD for this"'
echo ""
echo -e "${CYAN}Installed to:${NC} $MCP_SERVER_DIR"
echo ""

if [ "$WITH_SPAWNER" = false ]; then
  echo -e "${YELLOW}Tip:${NC} For the best building experience, also install Spawner:"
  echo -e "  ${CYAN}npx github:vibeforge1111/vibeship-spawner-skills install --mcp${NC}"
  echo ""
fi
