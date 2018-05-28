
# oracle 函数发现
## 左补空格  lpad
```sql
select lpad('1',3,'0') from dual
```
- 第一个参数为原始字符串

- 第二个参数为需补位数

- 第三个参数为需补字符

result
```
001
```

> 说明
```
这里主要用到Lpad()函数
lpad函数将左边的字符串填充一些特定的字符
1.语法格式如下：  
     lpad(string,n,[pad_string])
参数说明：
     string：    字符串或者列名。
     n：         字符串总长度。如果这个值比原字符串的长度还要短，lpad函数将会把字符串截取成从左到右的n个字符;
     pad_string：要填充的字符串，默认为填充空格。

补充：rpad（）函数跟lpad（）完全一样就是变成右侧填充，以下为示例


rpad函数将右边的字符串填充一些特定的字符其语法格式如下：rpad(string,n,[pad_string])

string
字符或者参数

n
字符的长度，是返回的字符串的数量，如果这个数量比原字符串的长度要短，lpad函数将会把字符串截取成从左到右的n个字符;

pad_string
可选参数，这个字符串是要粘贴到string的右边，如果这个参数未写，lpad函数将会在string的右边粘贴空格。

rpad('tech', 7); 将返回' tech'
rpad('tech', 2); 将返回'te'
rpad('tech', 8, '0'); 将返回'tech0000'
rpad('tech on the net', 15, 'z'); 将返回'tech on the net'
rpad('tech on the net', 16, 'z'); 将返回'tech on the netz'
```