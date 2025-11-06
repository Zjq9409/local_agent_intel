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

3. 在 all_in_one 文件夹下启动 qwen，启动成功可以输入以下prompt：
   
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
娱乐场景
```
生成重庆两日游攻略并导出为HTML，内容包括行程安排，评分4.7分以上景点和餐饮推荐.
我想选择地铁出行，第一天从重庆北站出发，第二天从洪崖洞出发请规划下两天的线路。
根据攻略，帮我生成小红书的参考文案。
```
教育场景
```
1. 使用WebFetch工具汇总中考历史考点并绘制思维导图
2. 总结中考历史考点并绘制思维导图
3. 总结中考语文文学尝试知识点并绘制思维导图
```
