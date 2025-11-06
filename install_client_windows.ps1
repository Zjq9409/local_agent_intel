Write-Host "📦 开始安装 Qwen 客户端依赖并检测配置目录..."
Write-Host "──────────────────────────────────────────────"

# 一、检测 Node.js 与 npm 环境
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "❌ 未检测到 npm，请先安装 Node.js"
    exit 1
} else {
    $npmVersion = npm -v
    Write-Host "✅ 检测到 npm，版本：$npmVersion"
}

# 二、安装 Node.js 依赖
Write-Host "🚀 安装 npm 依赖..."
npm install @modelcontextprotocol/sdk `
            node-fetch `
            https-proxy-agent `
            axios `
            getenv `
            minimatch `
            diff `
            mammoth `
            minimist `
            pino `
            markmap-lib `
            markmap-render `
            open `
            xlsx `
            --save `
            --save-dev @types/node

Write-Host "✅ npm 依赖安装完成"
Write-Host "──────────────────────────────────────────────"

# 三、安装 Python 依赖
if (Test-Path "requirements.txt") {
    Write-Host "🐍 检测到 requirements.txt，开始安装 Python 依赖..."
    if (-not (Get-Command pip -ErrorAction SilentlyContinue)) {
        Write-Host "❌ 未检测到 pip，请先安装 Python3 和 pip"
        exit 1
    }
    pip install -r requirements.txt
    Write-Host "✅ Python 依赖安装完成"
} else {
    Write-Host "⚠️ 未检测到 requirements.txt，跳过 Python 安装"
}
Write-Host "──────────────────────────────────────────────"

# 四、查找 Qwen 全局配置目录
if ($env:QWEN_HOME) {
    $QWEN_DIR = $env:QWEN_HOME
} else {
    $QWEN_DIR = "$env:USERPROFILE\.qwen"
}
Write-Host "📁 Qwen 配置目录应位于：$QWEN_DIR"

if (-not (Test-Path $QWEN_DIR)) {
    $create = Read-Host "未找到 .qwen 目录，是否要创建？(y/n)"
    if ($create -match "^[Yy]") {
        New-Item -ItemType Directory -Force -Path $QWEN_DIR | Out-Null
        Write-Host "📂 已创建：$QWEN_DIR"
    } else {
        Write-Host "🚫 已取消创建。"
    }
}
Write-Host "──────────────────────────────────────────────"

# 五、复制 settings.json
if (Test-Path "settings.json") {
    $copy = Read-Host "检测到 settings.json，是否复制到 $QWEN_DIR？(y/n)"
    if ($copy -match "^[Yy]") {
        Copy-Item -Force "settings.json" -Destination $QWEN_DIR
        Write-Host "✅ 已复制 settings.json"
    } else {
        Write-Host "🚫 已跳过复制 settings.json。"
    }
} else {
    Write-Host "⚠️ 当前目录下未找到 settings.json，请手动复制。"
}
Write-Host "──────────────────────────────────────────────"

# 六、显示结果
if (Test-Path $QWEN_DIR) {
    Write-Host "📦 当前 .qwen 目录内容："
    Get-ChildItem $QWEN_DIR
}

Write-Host "🎉 环境初始化完成！Qwen 客户端依赖与配置已准备就绪。"

