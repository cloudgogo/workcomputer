# Oracle 层级树（子选父，父选子）

- 现有数据结构及数据如下：
```sql
[sql] view plain copy
create table TEST_TREE  
(  
  id VARCHAR2(32),  
  name VARCHAR2(32),  
  pid VARCHAR2(32),  
  type VARCHAR2(32),  
  lev VARCHAR2(32)  
);  
comment on column TEST_TREE.name  
  is '名称';  
comment on column TEST_TREE.pid  
  is '父ID';  
comment on column TEST_TREE.type  
  is '种类';  
comment on column TEST_TREE.lev  
  is '级别';  
insert into TEST_TREE (id, name, pid, type, lev)  
values ('0001', '中国', null, null, '0');  
insert into TEST_TREE (id, name, pid, type, lev)  
values ('000101', '北京', '0001', '1', '1');  
insert into TEST_TREE (id, name, pid, type, lev)  
values ('000102', '湖南省', '0001', '2', '1');  
insert into TEST_TREE (id, name, pid, type, lev)  
values ('000103', '河南省', '0001', '2', '1');  
insert into TEST_TREE (id, name, pid, type, lev)  
values ('00010101', '东城区', '000101', '1', '2');  
insert into TEST_TREE (id, name, pid, type, lev)  
values ('00010102', '西城区', '000101', '2', '2');  
insert into TEST_TREE (id, name, pid, type, lev)  
values ('00010103', '崇文区', '000101', '4', '2');  
insert into TEST_TREE (id, name, pid, type, lev)  
values ('00010201', '长沙市', '000102', '1', '2');  
insert into TEST_TREE (id, name, pid, type, lev)  
values ('00010202', '岳阳市', '000102', '3', '2');  
insert into TEST_TREE (id, name, pid, type, lev)  
values ('00010203', '怀化市', '000102', '1', '2');  
insert into TEST_TREE (id, name, pid, type, lev)  
values ('00010301', '郑州市', '000103', '1', '2');  
insert into TEST_TREE (id, name, pid, type, lev)  
values ('00010302', '开封市', '000103', '2', '2');  
insert into TEST_TREE (id, name, pid, type, lev)  
values ('00010303', '洛阳市', '000103', '4', '2');  
```

> 问题如下：

- 要求根据id和type，查询当前节点下所有子节点的type为4的完整行政区划，完整行政区划要从当前查询的节点开始，以下为2种查询的效果
```
（1）查询条件：id='0001',type='4'
查询后的结果如下：
0001 中国   
000101 北京 0001 1
00010103 崇文区 000101 4
000103 河南省 0001 2
00010303 洛阳市 000103 4
```
```
（2）查询条件：id='000103',type='4'
查询后的结果如下：
000103 河南省 0001 2
00010303 洛阳市 000103 4
```
=============================

- 这个问题不难，有两种解决方法：
1. 先找出type=4的所有父节点，再在这个结果集中找出节点为id='0001'的所有子节点，即可。
2. 先找出节点为id='0001'的所有子节点，再在这个结果集中找出节点type=4的所有父节点，最后的这个结果集即是。

- 这两种方法本质上一样。要么从父找到子，要么从子找到父。
- 其实这是个追溯问题。
- 了解：
```sql

[sql] view plain copy
--从父亲找子  
select t.*,level     
from t  
start with t.pid='0001' --定位父节点  
connect by prior t.id=t.pid; --追溯子节点  
  
--从子找父  
select t.*,level   
from t  
start with t.type=4 --定位子节点  
connect by prior t.pid=t.id;--追溯父节点  
```
解决代码如下：
```sql

[sql] view plain copy
with temp as(  
  select t.*  
  from test_tree t  
  start with t.type=4  
  connect by prior t.pid=t.id  
)  
select * from temp t  
start with t.id='000103'  
connect by prior t.id=t.pid  
```
> result
```
----结果：  
       ID    NAME    PID    TYPE    LEV  
1    000103    河南省    0001    2    1  
2    00010303 洛阳市    000103    4    2  
```

```sql
[sql] view plain copy
id='0001' ,type=4  
---------------------  
with temp as(  
  select * from test_tree t  
  start with t.id='0001'  
  connect by prior t.id=t.pid  
)  
select distinct t.*  
from temp t  
start with t.type=4  
connect by prior t.pid=t.id  
order by id;  
```
>result
```
-----------结果：  
       ID    NAME    PID    TYPE    LEV  
1    0001    中国            0  
2    000101    北京    0001    1    1  
3    00010103    崇文区    000101    4    2  
4    000103    河南省    0001    2    1  
5    00010303    洛阳市    000103    4    2  
```

