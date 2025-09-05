npm依赖包安装：
```
需要在当前目录下安装以下包，然后将安装完成的node_modules 移动到上级目录
npm install @modelcontextprotocol/sdk
npm install  node-fetch
npm install https-proxy-agent
npm install axios
npm install getenv
npm install minimatch
npm install diff
npm install  mammoth
npm install --save-dev @types/node
```
python依赖包安装，在conda环境下安装
```
pip install https://paddle-model-ecology.bj.bcebos.com/paddlex/PaddleX3.0/mcp/paddleocr_mcp/releases/v0.2.0/paddleocr_mcp-0.2.0-py3-none-any.whl
python -m pip install paddlepaddle==3.0.0 -i https://www.paddlepaddle.org.cn/packages/stable/cpu/
python -m pip install paddleocr
python -m pip install uv
```

**需要在安装以上依赖的conda环境下启动qwen**

prompt设计
- 调用PaddleOCR识别MCP
```
帮我把这个图片 demo.png 变成可编辑的markdown格式，保留原来的格式，使用filesystem__write_file工具保存文件。
以上md文件不需要使用 LaTeX 格式保存。
```
- 调用PPT制作MCP工具
```
根据 24.10.12_Gaudi2D-test_report.docx文档制作1份PPT。     ######（需要联网）
```
- 调用excel分析以及图表绘制MCP
```
读 ev_adoption_dataset_translated_chinese.xlsx 文件内容，输出列名称。  
对比中国和德国最近五年政府补贴金额数量。
将以上中国和德国政府补贴数据绘制成折线图。             ######（需要联网） 
```
