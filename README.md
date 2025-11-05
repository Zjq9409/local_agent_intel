1. 新建conda环境，客户端执行依赖安装脚本
```
   bash  install_client.sh
```

2. 需要PaddleOCR的MCP，则在服务器端需要安装服务 
```
python -m pip install paddlepaddle==3.0.0 -i https://www.paddlepaddle.org.cn/packages/stable/cpu/
pip install "paddlex[base]"
paddlex --serve --pipeline /home/intel/PP-StructureV3.yaml --use_hpip --port 32004
```

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

1. 使用WebFetch工具汇总中考历史考点并绘制思维导图
2. 总结中考历史考点并绘制思维导图
3. 总结中考语文文学尝试知识点并绘制思维导图
