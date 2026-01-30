#!/bin/bash
# ----------------------------------------
# Qwen Client Full Auto Install Script (Linux)
# ----------------------------------------

echo "Starting Qwen client automated installation..."
echo "------------------------------------------------"

###############################################
# Step 1: Detect and Install Node.js and npm
###############################################
if ! command -v node &> /dev/null; then
  echo "Node.js not found. Installing Node.js + npm ..."

  if ! command -v curl &> /dev/null; then
    echo "curl not found. Installing curl..."
    if command -v apt &> /dev/null; then
      sudo apt update -y && sudo apt install -y curl
    elif command -v yum &> /dev/null; then
      sudo yum install -y curl
    else
      echo "❌ Neither apt nor yum found. Please install curl manually and rerun the script"
      exit 1
    fi
  fi

  echo "Installing Node.js (using official nodesource repository)..."
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  
  if command -v apt &> /dev/null; then
    sudo apt update -y && sudo apt install -y nodejs
  elif command -v yum &> /dev/null; then
    sudo yum install -y nodejs
  fi

  if ! command -v node &> /dev/null; then
    echo "❌ Node.js installation failed. Please install manually: https://nodejs.org/"
    exit 1
  fi
fi

echo "✔ Node.js detected. Version: $(node -v)"

if ! command -v npm &> /dev/null; then
  echo "npm not found. Attempting to fix npm..."
  sudo apt install -y npm 2>/dev/null || sudo yum install -y npm 2>/dev/null || true

  if ! command -v npm &> /dev/null; then
    echo "❌ npm installation failed. Please fix manually"
    exit 1
  fi
fi

echo "✔ npm detected. Version: $(npm -v)"
echo "──────────────────────────────────────────────"

###############################################
# Step 2: Detect and Install Python 3
###############################################
if ! command -v python3 &> /dev/null; then
  echo "Python3 not found. Installing..."
  
  if command -v apt &> /dev/null; then
    sudo apt update -y && sudo apt install -y python3 python3-pip
  elif command -v yum &> /dev/null; then
    sudo yum install -y python3 python3-pip
  else
    echo "❌ Neither apt nor yum found. Please install Python3 manually"
    exit 1
  fi

  if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 installation failed"
    exit 1
  fi
fi

echo "✔ Python3 detected. Version: $(python3 --version)"
echo "──────────────────────────────────────────────"

###############################################
# Step 3: Set Project Directory to Current Directory
###############################################
PROJECT_DIR=$(pwd)
echo "✔ Using current directory as project directory: $PROJECT_DIR"
echo "──────────────────────────────────────────────"

###############################################
# Step 4: Install npm Local Dependencies
###############################################
echo "Installing npm dependencies to $PROJECT_DIR ..."
npm install @modelcontextprotocol/sdk node-fetch https-proxy-agent axios getenv minimatch diff mammoth minimist pino markmap-lib markmap-render open xlsx --save --save-dev @types/node

if [ $? -eq 0 ]; then
  echo "✔ npm dependencies installed successfully"
else
  echo "❌ npm dependencies installation failed"
  exit 1
fi
echo "──────────────────────────────────────────────"

###############################################
# Step 5: Install Python Dependencies
###############################################
if [ -f "$PROJECT_DIR/requirements.txt" ]; then
  echo "Installing Python dependencies from requirements.txt..."
  pip3 install -r "$PROJECT_DIR/requirements.txt"
  
  if [ $? -eq 0 ]; then
    echo "✔ Python dependencies installed successfully"
  else
    echo "❌ Python dependencies installation failed"
    exit 1
  fi
else
  echo "⚠ requirements.txt not found. Skipping Python dependencies installation"
fi
echo "──────────────────────────────────────────────"

###############################################
# Step 6: Install Qwen CLI Globally (if not installed)
###############################################
if command -v qwen-code &> /dev/null; then
  echo "✔ Qwen CLI already installed. Version: $(qwen-code --version)"
  echo "Skipping installation"
else
  echo "Installing Qwen CLI globally..."
  npm install -g @qwen-code/qwen-code@latest
  
  if command -v qwen &> /dev/null; then
    echo "✔ Qwen CLI installed successfully. Version: $(qwen-code --version)"
  else
    echo "❌ Qwen CLI installation failed. Please check npm global path"
    exit 1
  fi
fi
echo "──────────────────────────────────────────────"

###############################################
# Step 7: Copy settings.json to .qwen Directory
###############################################
QWEN_DIR="$HOME/.qwen"

if [ ! -d "$QWEN_DIR" ]; then
  echo "Creating .qwen directory: $QWEN_DIR"
  mkdir -p "$QWEN_DIR"
fi

SETTINGS_FILE="$PROJECT_DIR/settings.json"
if [ -f "$SETTINGS_FILE" ]; then
  read -p "Do you want to copy settings.json to $QWEN_DIR? (Y/N): " COPY_CHOICE
  if [[ "$COPY_CHOICE" =~ ^[Yy]$ ]]; then
    cp "$SETTINGS_FILE" "$QWEN_DIR/"
    echo "✔ settings.json copied to $QWEN_DIR"
  else
    echo "Skipping copy of settings.json"
  fi
else
  echo "⚠ settings.json not found in current directory. Skipping copy"
fi

echo "──────────────────────────────────────────────"
echo "✅ Qwen client environment setup complete!"
echo "Navigating to 'cli_agent' directory and launching qwen..."

# # Navigate to cli_agent directory and launch qwen
# CLI_AGENT_DIR="$PROJECT_DIR/cli_agent"
# if [ -d "$CLI_AGENT_DIR" ]; then
#   cd "$CLI_AGENT_DIR"
#   echo "Current directory: $(pwd)"
#   exec qwen
# else
#   echo "❌ cli_agent directory not found at $CLI_AGENT_DIR"
#   exit 1
# fi
