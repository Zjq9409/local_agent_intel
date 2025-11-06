#!/usr/bin/env bash
set -e
set -o pipefail

echo "开始安装 Qwen 客户端依赖并检测配置目录..."
echo "──────────────────────────────────────────────"

###############################################
# 一、检测 Node.js 与 npm 环境
###############################################
if ! command -v npm &> /dev/null; then
  echo "未检测到 npm，正在自动安装 Node.js..."

  if ! command -v curl &> /dev/null; then
    echo "未检测到 curl，尝试使用 apt 或 yum 安装..."
    if command -v apt &> /dev/null; then
      sudo apt update -y && sudo apt install -y curl
    elif command -v yum &> /dev/null; then
      sudo yum install -y curl
    else
      echo "系统中未找到 apt 或 yum，请手动安装 curl。"
      exit 1
    fi
  fi

  echo "正在下载安装脚本并执行..."
  curl -qL https://www.npmjs.com/install.sh | bash

  if ! command -v npm &> /dev/null; then
    echo "Node.js 安装失败，请手动安装 Node.js (https://nodejs.org/)"
    exit 1
  fi

  echo "Node.js 已成功安装，版本：$(npm -v)"
else
  echo "检测到 npm，版本：$(npm -v)"
fi

echo "──────────────────────────────────────────────"

###############################################
# 二、安装 Node.js 本地依赖包
###############################################
echo "安装 npm 本地依赖..."
npm install @modelcontextprotocol/sdk \
            node-fetch \
            https-proxy-agent \
            axios \
            getenv \
            minimatch \
            diff \
            mammoth \
            minimist \
            pino \
            markmap-lib \
            markmap-render \
            open \
            xlsx \
            --save \
            --save-dev @types/node

echo "npm 本地依赖安装完成"
echo "──────────────────────────────────────────────"

###############################################
# 三、安装 Python 依赖
###############################################
if [ -f "requirements.txt" ]; then
  echo "检测到 requirements.txt，开始安装 Python 依赖..."
  if ! command -v pip &> /dev/null; then
    echo "未检测到 pip，请先安装 Python3 和 pip"
    exit 1
  fi
  pip install -r requirements.txt
  echo "Python 依赖安装完成"
else
  echo "未检测到 requirements.txt，跳过 Python 安装"
fi

echo "──────────────────────────────────────────────"

###############################################
# 四、全局安装 Qwen CLI 客户端
###############################################
echo "正在全局安装 Qwen CLI 工具..."
sudo npm install -g @qwen-code/qwen-code@latest

if command -v qwen-code &> /dev/null; then
  echo "Qwen CLI 安装成功，版本：$(qwen-code --version)"
else
  echo "未检测到 qwen-code 命令，请检查 npm 全局路径。"
fi

echo "──────────────────────────────────────────────"

###############################################
# 五、查找 Qwen 全局配置目录
###############################################
QWEN_DIR="${QWEN_HOME:-$HOME/.qwen}"

echo "Qwen 配置目录应位于：$QWEN_DIR"

if [ ! -d "$QWEN_DIR" ]; then
  read -p "是否要创建该目录？(y/n): " yn
  [[ $yn =~ [Yy] ]] && mkdir -p "$QWEN_DIR" && echo "📂 已创建：$QWEN_DIR"
fi

echo "──────────────────────────────────────────────"

###############################################
# 六、拷贝 settings.json
###############################################
if [ -f "settings.json" ]; then
  read -p "是否要将 settings.json 拷贝到 $QWEN_DIR ？(y/n): " copyyn
  [[ $copyyn =~ [Yy] ]] && cp -f "settings.json" "$QWEN_DIR/" && echo "✅ 已复制 settings.json"
else
  echo "未找到 settings.json，请手动复制到 $QWEN_DIR"
fi

echo "──────────────────────────────────────────────"
echo "当前 .qwen 目录内容："
ls -al "$QWEN_DIR"

echo "环境初始化完成！Qwen 客户端依赖与配置已准备就绪。"
echo "你现在可以直接运行： qwen-code"

