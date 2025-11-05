#!/bin/bash
set -e  # 一旦出错立即退出
set -o pipefail

echo "📦 开始安装客户端依赖包..."

# 检查 Node.js 和 npm 是否安装
if ! command -v npm &> /dev/null; then
  echo "❌ 未检测到 npm，请先安装 Node.js"
  exit 1
fi

# 安装 npm 包
echo "🚀 安装 npm 依赖..."
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

echo "✅ npm 依赖安装完成"

# 安装 Python 依赖（requirements.txt）
if [ -f "requirements.txt" ]; then
  echo "🐍 检测到 requirements.txt，开始安装 Python 依赖..."
  if ! command -v pip &> /dev/null; then
    echo "❌ 未检测到 pip，请先安装 Python3 和 pip"
    exit 1
  fi
  pip install -r requirements.txt
  echo "✅ Python 依赖安装完成"
else
  echo "⚠️ 未检测到 requirements.txt，跳过 Python 依赖安装"
fi

echo "🎉 所有依赖安装完成！"
