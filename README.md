1. 客户端安装脚本，在当前目录下执行
```
   bash ./install_client_linux.sh    #linux平台
   ./install_client_windows.ps1     #windows平台
```

2. 在服务器端安装PaddleOCR的MCP（可选，不用OCR则可以不用安装），https://github.com/PaddlePaddle/PaddleOCR/blob/main/docs/version3.x/deployment/serving.md
```
python -m pip install paddlepaddle
pip install "paddlex[base]"
paddlex --install serving
paddlex --install hpi-cpu
paddlex --serve --pipeline /home/intel/PP-StructureV3.yaml --use_hpip --port 32004
```
PaddleOCR mcp 可以参考官网安装链接： https://github.com/PaddlePaddle/PaddleOCR/blob/main/docs/version3.x/deployment/mcp_server.md#%E6%A8%A1%E5%BC%8F%E5%9B%9B%E8%87%AA%E6%89%98%E7%AE%A1%E6%9C%8D%E5%8A%A1

3. 到cli_agent 目录下执行qwen 或者 qwen --yolo（执行工具不需要用户确认） 命令，启动成功可以输入以下prompt:
   
- 调用PaddleOCR识别图片内容
```
帮我把这个图片 demo.png 变成可编辑的markdown格式保存到当前目录下，保留原来的格式。
以上md文件不需要使用 LaTeX 格式保存。
```
- 使用WORD 制作PPT
```
根据 24.10.12_Gaudi2D-test_report.docx文档制作1份PPT。     ######（需要联网）
```
- 调用excel分析以及图表绘制
```
读 ev_adoption_dataset_translated_chinese.xlsx 文件内容，输出列名称。  
对比中国和德国最近五年政府补贴金额数量。
将以上中国和德国政府补贴数据绘制成折线图。             ######（需要联网） 
```
- 娱乐场景
```
生成重庆两日游攻略并导出为HTML，内容包括行程安排，评分4.7分以上景点和餐饮推荐.
我想选择地铁出行，第一天从重庆北站出发，第二天从洪崖洞出发请规划下两天的线路。
根据攻略，帮我生成小红书的参考文案。
```
- 教育场景
```
1. 使用WebFetch工具汇总中考历史考点并绘制思维导图
2. 总结中考历史考点并绘制思维导图
3. 总结中考语文文学尝试知识点并绘制思维导图
```
