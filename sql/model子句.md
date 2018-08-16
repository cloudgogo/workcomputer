## oracle model子句

**制作表格数据，用传统sql来实现的话，一般通过多个表的自联结实现，而model的出现则使得不用自联结就能实现表格，因为model拥有了跨行应用能力。**
> 对这句话的理解就是通过model子句，不必再按照表之间通过对应关系的相等或其他条件，出到一行中进行计算。model子句可以按照规则进行跨行的数据结果。（自我感觉有点类似于excel中的vlookup函数的意思）

#### 语法
```sql
　MODEL
　　　　[]
　　　　[]
　　　　[MAIN ]
  　　　 [PARTITION BY ()]
  　　    DIMENSION BY ()
  　　    MEASURES ()
  　　　 []
  　　　 [RULES]
  　　　 (, ,.., )
  　　　 ::=
 　　　  ::= RETURN {ALL|UPDATED} ROWS
  　　　 ::=
  　　　 [IGNORE NAV | [KEEP NAV]
  　　　 [UNIQUE DIMENSION | UNIQUE SINGLE REFERENCE]
  　　　 ::=
  　　　 [UPDATE | UPSERT | UPSERT ALL]
  　　　 [AUTOMATIC ORDER | SEQUENTIAL ORDER]
  　　　 [ITERATE ()  [UNTIL ]]
  　　　 ::= REFERENCE ON ON ()
  　　　 DIMENSION BY () MEASURES ()
```

#### 学习测试用例

- **创建表**
```sql
-- 创建表
create table ademo(
       id number(18) primary key,
       year varchar2(4),
       week number(8),
       sale number(8,2),
       area varchar2(100)
);
comment on table ademo is '测试经济类的表';
comment on column ademo.id is '主键';
comment on column ademo.year is '年份';
comment on column ademo.week is 'xxx周';
comment on column ademo.sale is '销售额';
comment on column ademo.area is '地区';
```
*or*
```sql
-- Create table
create table ADEMO
(
  id   NUMBER(18) not null,
  year VARCHAR2(4),
  week NUMBER(8),
  sale NUMBER(8,2),
  area VARCHAR2(100)
)
tablespace SYSTEM
  pctfree 10
  pctused 40
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table ADEMO
  is '测试经济类的表';
-- Add comments to the columns 
comment on column ADEMO.id
  is '主键';
comment on column ADEMO.year
  is '年份';
comment on column ADEMO.week
  is 'xxx周';
comment on column ADEMO.sale
  is '销售额';
comment on column ADEMO.area
  is '地区';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ADEMO
  add primary key (ID)
  using index 
  tablespace SYSTEM
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );

```

- **创建序列**
```sql
create sequence seq_ademo_id 
minvalue 1
start with 1
increment by 1
nomaxvalue
nocache
nocycle;
```

- **创建触发器**
```sql
create or replace trigger trigger_ademo_id
before insert on ademo for each row when (new.id is null)
begin 
  select seq_ademo_id.nextval into :new.id from dual;
end;

```


- **插入数据**
```sql
-- 初始化数据
insert into ademo (AREA, YEAR, WEEK, SALE)
values ('astiya', '2000', 1, 52.12);

insert into  ademo (AREA, YEAR, WEEK, SALE)
values ('astiya', '2001', 1, 110.12);

insert into ademo (AREA, YEAR, WEEK, SALE)
values ('astiya', '2001', 2, 110.12);

insert into ademo (AREA, YEAR, WEEK, SALE)
values ('astiya', '2001', 3, 1210.12);

insert into ademo (AREA, YEAR, WEEK, SALE)
values ('astiya', '2002', 1, 170.12);

insert into ademo (AREA, YEAR, WEEK, SALE)
values ('astiya', '2002', 2, 680.12);

insert into ademo (AREA, YEAR, WEEK, SALE)
values ('astiya', '2002', 3, 680.12);

insert into  ademo (AREA, YEAR, WEEK, SALE)
values ('anter', '2001', 1, 80.12);

insert into ademo (AREA, YEAR, WEEK, SALE)
values ('anter', '2001', 2, 56.72);

insert into ademo (AREA, YEAR, WEEK, SALE)
values ('anter', '2001', 3, 156.72);

insert into ademo (AREA, YEAR, WEEK, SALE)
values ('anter', '2002', 1, 640.12);

insert into ademo (AREA, YEAR, WEEK, SALE)
values ('anter', '2002', 2, 980.12);

insert into ademo (AREA, YEAR, WEEK, SALE)
values ('anter', '2002', 3, 1980.12);

commit;
```


#### *example:*

- exmp1：
```sql
-- 例子1
select year,week,sale,area,up_sale
from ademo
model return updated rows    -- model 语句
partition by (area)　　　　　　-- 分组
dimension by (year,week)　　　-- 维度列
measures(sale,0 up_sale)　　　-- 度量值列
rules(　　　　　　　　　　　　　 -- 规则
    up_sale[year,week]=sale[cv(year),cv(week)]*10,
    up_sale[1999,1]=100.00　　
)order by year,week;
```