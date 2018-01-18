# git 改动
## git的改动都需要stage过程后才能commit。当git中有大量改动时就需要能够批量操作在方便。改动分三种：

1 .modify: 有文件修改add: 有文件增加rm: 有文件删除
> 对于修改，不需要手动commmit。对于add，可以git add "*"搞定。对于rm，则可以通过如下命令得到要被删除的文件：   

2 .git status | greb deleted > del.txt
> 需要把这个列表每行前面几个字符册掉。用vim很容易做。Ctrl+v进入纵向选择模式，选中要删除的内容，按d删除。然后可以得到了个干净的要删除的文件列表。检查一下是否真的要删除。确实要删除就执行下面的命令：

3 .cat del.txt | xargs git rm
> 这样就把要删除的文件全部放入stage，可以commit了。

# 正确方法
add所有文件：
```
git add .
```
add并rm所有(不需要用上面的方法来delete)：
```
git add -A
```
提交modify和rm（新加的文件不会自动提交）
```
git commit -a
```