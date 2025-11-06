# ----------------------------------------
# Qwen Client Full Auto Install Script (Windows)
# ----------------------------------------

# Temporarily set execution policy
Set-ExecutionPolicy Bypass -Scope Process -Force

Write-Host "Starting Qwen client automated installation..."
Write-Host "------------------------------------------------"

# -----------------------------
# Step 1: Check and install Node.js LTS
# -----------------------------
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "npm not found. Installing Node.js LTS via WinGet..."
    winget install OpenJS.NodeJS.LTS -e --silent
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        Write-Host "Node.js installation failed. Please check WinGet availability."
        exit 1
    }
    Write-Host "Node.js installed successfully. Version: $(node -v)"
} else {
    Write-Host "npm detected. Version: $(npm -v)"
}

Write-Host "------------------------------------------------"

# -----------------------------
# Step 2: Check and install Python 3
# -----------------------------
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Python not found. Installing Python 3 via WinGet..."
    winget install Python.Python.3 -e --silent
    if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
        Write-Host "Python installation failed. Please check WinGet availability."
        exit 1
    }
    Write-Host "Python installed successfully. Version: $(python --version)"
} else {
    Write-Host "Python detected. Version: $(python --version)"
}

Write-Host "------------------------------------------------"

# -----------------------------
# Step 3: Set project directory to current directory
# -----------------------------
$projectDir = Get-Location
Write-Host "Using current directory as project directory: $projectDir"

# -----------------------------
# Step 4: Install npm local dependencies
# -----------------------------
Write-Host "Installing npm dependencies in $projectDir ..."
npm install @modelcontextprotocol/sdk node-fetch https-proxy-agent axios getenv minimatch diff mammoth minimist pino markmap-lib markmap-render open xlsx --save --save-dev @types/node
Write-Host "npm dependencies installed."
Write-Host "------------------------------------------------"

# -----------------------------
# Step 5: Install Python dependencies
# -----------------------------
if (Test-Path "$projectDir\requirements.txt") {
    Write-Host "Installing Python dependencies from requirements.txt ..."
    pip install -r "$projectDir\requirements.txt"
    Write-Host "Python dependencies installed."
} else {
    Write-Host "requirements.txt not found. Skipping Python dependencies."
}

Write-Host "------------------------------------------------"

# -----------------------------
# Step 6: Install Qwen CLI globally (only if not installed)
# -----------------------------
if (Get-Command qwen-code -ErrorAction SilentlyContinue) {
    Write-Host "Qwen CLI is already installed. Skipping installation."
    Write-Host "Version: $(qwen-code --version)"
} else {
    Write-Host "Installing Qwen CLI globally via npm ..."
    npm install -g @qwen-code/qwen-code@latest
    if (Get-Command qwen-code -ErrorAction SilentlyContinue) {
        Write-Host "Qwen CLI installed successfully. Version: $(qwen-code --version)"
    } else {
        Write-Host "Qwen CLI installation failed. Please check npm global path."
    }
}

# -----------------------------
# Step 7: Copy settings.json to .qwen directory (ask user first)
# -----------------------------
$qwenDir = Join-Path $env:USERPROFILE ".qwen"

if (-not (Test-Path $qwenDir)) {
    Write-Host "Creating .qwen directory at $qwenDir ..."
    New-Item -ItemType Directory -Path $qwenDir | Out-Null
}

$settingsFile = Join-Path $projectDir "settings.json"
if (Test-Path $settingsFile) {
    $copyChoice = Read-Host "Do you want to copy settings.json to $qwenDir? (Y/N)"
    if ($copyChoice -match "^[Yy]") {
        Copy-Item -Path $settingsFile -Destination $qwenDir -Force
        Write-Host "settings.json copied to $qwenDir"
    } else {
        Write-Host "Skipping copy of settings.json."
    }
} else {
    Write-Host "settings.json not found in current directory. Skipping copy."
}

Write-Host "------------------------------------------------"
Write-Host "Qwen client environment setup complete!"
Write-Host "Now You can goto 'cli_agent' directory to run: qwen"

