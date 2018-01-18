# 链接跳转
```excel
=HYPERLINK(CONCATENATE(MID(CELL("filename"),FIND("[",CELL("filename")),FIND("]",CELL("filename"))-FIND("[",CELL("filename"))+1),"sheet2!A1"),"跳转")
```

1. HYPERLINK 超链接
2. CONCATENATE 文本拼接
3. MID 文本截取
4. FIND 寻找文本指定位置
5. CELL 获取信息
