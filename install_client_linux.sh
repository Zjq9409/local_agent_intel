###############################################
# 一、检测 Node.js 与 npm 环境（增强逻辑）
###############################################
if ! command -v node &> /dev/null; then
  echo "未检测到 Node.js，开始安装 Node.js + npm ..."

  if ! command -v curl &> /dev/null; then
    echo "未检测到 curl，正在安装 curl..."
    if command -v apt &> /dev/null; then
      sudo apt update -y && sudo apt install -y curl
    elif command -v yum &> /dev/null; then
      sudo yum install -y curl
    else
      echo "❌ 未找到 apt 或 yum，请手动安装 curl 再运行脚本"
      exit 1
    fi
  fi

  echo "正在安装 Node.js（使用官方 nodesource 仓库）..."
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  
  if command -v apt &> /dev/null; then
    sudo apt update -y && sudo apt install -y nodejs
  elif command -v yum &> /dev/null; then
    sudo yum install -y nodejs
  fi

  if ! command -v node &> /dev/null; then
    echo "❌ Node.js 安装失败，请手动安装: https://nodejs.org/"
    exit 1
  fi
fi

echo "✔ 检测到 Node.js，版本：$(node -v)"

if ! command -v npm &> /dev/null; then
  echo "未检测到 npm，尝试修复 npm..."
  sudo apt install -y npm 2>/dev/null || sudo yum install -y npm 2>/dev/null || true

  if ! command -v npm &> /dev/null; then
    echo "❌ npm 安装失败，请手动修复"
    exit 1
  fi
fi

echo "✔ 检测到 npm，版本：$(npm -v)"
echo "──────────────────────────────────────────────"
