# vscode terminal 设置(用户配置文件)


1. 首先win自带的终端自我认为比较垃圾，可以先下载Cmder.exe
2. 下载完并安装完成后，拷贝Cmder应用路径
3. 打开vscode，并找到‘’用户设置‘’文件，搜索：terminal.integrated.shell.windows之后将后面的路径修改为，之前Cmder应用路径即可，
4. vscode默认打开终端快捷键是Ctrl + ` ，当然也可自己修改。


> 使用bash
```
{
    "workbench.colorTheme": "Quiet Light",
    "git.autofetch": true,
    "window.zoomLevel": 0,
    "terminal.integrated.shell.windows": "C:\\Program Files\\Git\\bin\\bash.exe"
    
}
```
