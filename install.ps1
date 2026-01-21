# IdeaRalph MCP Installer for Windows
# Usage: irm https://raw.githubusercontent.com/vibeforge1111/vibeship-idearalph/main/install.ps1 | iex
# With Spawner: $env:WITH_SPAWNER="true"; irm https://raw.githubusercontent.com/vibeforge1111/vibeship-idearalph/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

# Check for --with-spawner in args or env var
$WithSpawner = $env:WITH_SPAWNER -eq "true"

Write-Host ""
Write-Host "╔═══════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║        IdeaRalph MCP Installer        ║" -ForegroundColor Blue
Write-Host "╚═══════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""

# Check for Node.js
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "✗ Node.js is required but not installed." -ForegroundColor Red
    Write-Host "  Install from: https://nodejs.org"
    exit 1
}

# Check for Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "✗ Git is required but not installed." -ForegroundColor Red
    exit 1
}

# Determine install location
$InstallDir = Join-Path $env:USERPROFILE ".idearalph"
$McpServerDir = Join-Path $InstallDir "mcp-server"

# Step 1: Create install directory
Write-Host "[1/4]" -ForegroundColor Cyan -NoNewline
Write-Host " Setting up installation directory..."

if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# Step 2: Clone or update MCP server
Write-Host "[2/4]" -ForegroundColor Cyan -NoNewline
Write-Host " Downloading IdeaRalph MCP..."

if (Test-Path $McpServerDir) {
    Write-Host "  Updating existing installation..." -ForegroundColor Yellow
    Push-Location $McpServerDir
    git pull --quiet
    Pop-Location
} else {
    $TempDir = Join-Path $InstallDir "temp"
    git clone --depth 1 --quiet https://github.com/vibeforge1111/vibeship-idearalph.git $TempDir
    Move-Item (Join-Path $TempDir "mcp-server") $McpServerDir
    Remove-Item $TempDir -Recurse -Force
}
Write-Host "✓ Downloaded IdeaRalph MCP" -ForegroundColor Green

# Step 3: Build MCP server
Write-Host "[3/4]" -ForegroundColor Cyan -NoNewline
Write-Host " Building MCP server..."

Push-Location $McpServerDir
npm install --silent 2>$null
npm run build --silent 2>$null
Pop-Location
Write-Host "✓ Built MCP server" -ForegroundColor Green

# Step 4: Configure Claude Code
Write-Host "[4/4]" -ForegroundColor Cyan -NoNewline
Write-Host " Configuring Claude Code..."

$McpPath = Join-Path $McpServerDir "dist\index.js"

# Try using claude CLI first
$claudeExists = Get-Command claude -ErrorAction SilentlyContinue
if ($claudeExists) {
    try {
        claude mcp add idearalph -- node $McpPath 2>$null
        Write-Host "✓ Added IdeaRalph to Claude Code" -ForegroundColor Green
    } catch {
        Write-Host "! Could not add via CLI, trying manual config..." -ForegroundColor Yellow
    }
}

# Manual config
$ConfigDir = Join-Path $env:APPDATA "Claude"
$ConfigFile = Join-Path $ConfigDir "claude_desktop_config.json"

if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

$config = @{ mcpServers = @{} }

if (Test-Path $ConfigFile) {
    try {
        $config = Get-Content $ConfigFile -Raw | ConvertFrom-Json -AsHashtable
        if (-not $config.mcpServers) {
            $config.mcpServers = @{}
        }
    } catch {
        $config = @{ mcpServers = @{} }
    }
}

$config.mcpServers.idearalph = @{
    command = "node"
    args = @($McpPath)
}

$config | ConvertTo-Json -Depth 10 | Set-Content $ConfigFile
Write-Host "✓ Updated Claude config" -ForegroundColor Green

# Optional: Install Spawner
if ($WithSpawner) {
    Write-Host ""
    Write-Host "Installing Spawner Skills..." -ForegroundColor Blue
    Write-Host ""
    try {
        npx github:vibeforge1111/vibeship-spawner-skills install --mcp
    } catch {
        Write-Host "✗ Failed to install Spawner" -ForegroundColor Red
        Write-Host "  You can install it manually later:"
        Write-Host "  npx github:vibeforge1111/vibeship-spawner-skills install --mcp" -ForegroundColor Cyan
    }
}

# Done!
Write-Host ""
Write-Host "╔═══════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║          Installation Complete!       ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Restart Claude Code" -NoNewline
Write-Host " to use IdeaRalph."
Write-Host ""
Write-Host "Try it:"
Write-Host '  "Help me brainstorm startup ideas in AI"'
Write-Host '  "Validate my idea: [your idea]"'
Write-Host '  "Create a PRD for this"'
Write-Host ""
Write-Host "Installed to: " -ForegroundColor Cyan -NoNewline
Write-Host $McpServerDir
Write-Host ""

if (-not $WithSpawner) {
    Write-Host "Tip:" -ForegroundColor Yellow -NoNewline
    Write-Host " For the best building experience, also install Spawner:"
    Write-Host "  npx github:vibeforge1111/vibeship-spawner-skills install --mcp" -ForegroundColor Cyan
    Write-Host ""
}
