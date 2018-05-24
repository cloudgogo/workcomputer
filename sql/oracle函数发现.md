
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