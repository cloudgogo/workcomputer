with factdate as
 (select substr(data_date, 1, 6)
    from dm_mcl_acct
   where data_date is not null
     and rownum = 1),
RESULT as (
--当年
select *
  from (select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '1' type1,
               substr(a.factdate, 1, 4)||'年' type2,
               a.year_target_val target_val,
               a.year_val val,
               a.year_target_rate target_rate,
               a.lst_year_val lst_val,
               a.year_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and a.factdate = (select * from factdate)
        
        union all
        
        select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '1' type1,
               case
                 when to_number(substr(a.factdate, 5, 2)) = 1 then
                  '1季度'
                 when to_number(substr(a.factdate, 5, 2)) = 4 then
                  '2季度'
                 when to_number(substr(a.factdate, 5, 2)) = 7 then
                  '3季度'
                 when to_number(substr(a.factdate, 5, 2)) = 10 then
                  '4季度'
               end type2,
               
               a.quarter_target_val  target_val,
               a.quarter_val         val,
               a.quarter_target_rate target_rate,
               a.lst_quarter_val     lst_val,
               a.quarter_rate        rate
        
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and to_number(substr(a.factdate, 5, 2)) in (1, 4, 7, 10))
 where 1 = 1
   and type1 = '1' --type1 = '${dim_cal}'

union all
--当季
select *
  from (select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '2' type1,
               substr(a.factdate, 1, 4) type2,
               a.year_target_val target_val,
               a.year_val val,
               a.year_target_rate target_rate,
               a.lst_year_val lst_val,
               a.year_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and a.factdate = (select * from factdate)
        union all
        select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '2' type1,
               ceil(to_number(substr(a.factdate, 5, 2)) / 3) || '季度' type2,
               a.quarter_target_val target_val,
               a.quarter_val val,
               a.quarter_target_rate target_rate,
               a.lst_quarter_val lst_val,
               a.quarter_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and a.factdate = (select * from factdate)
        
        union all
        
        select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '2' type1,
               to_number(substr(a.factdate, 5, 2)) || '月' type2,
               a.month_target_val target_val,
               a.month_val val,
               a.month_target_rate target_rate,
               a.lst_month_val lst_val,
               a.month_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and to_char(to_date((select * from factdate), 'YYYYMM'), 'yyyyq') =
               to_char(to_date(factdate, 'yyyymm'), 'yyyyq'))
 where 1 = 1 and type1 = '1'   --type1 = '${dim_cal}'

union all
--当月
select *
  from (select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '3' type1,
               substr(a.factdate, 1, 4) type2,
               a.year_target_val target_val,
               a.year_val val,
               a.year_target_rate target_rate,
               a.lst_year_val lst_val,
               a.year_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and a.factdate = (select * from factdate)
        
        union all
        
        select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '3' type1,
               ceil(to_number(substr(a.factdate, 5, 2)) / 3) || '季度' type2,
               a.quarter_target_val target_val,
               a.quarter_val val,
               a.quarter_target_rate target_rate,
               a.lst_quarter_val lst_val,
               a.quarter_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and a.factdate = (select * from factdate)
        
        union all
        
        select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '3' type1,
               to_number(substr(a.factdate, 5, 2)) || '月' type2,
               a.month_target_val target_val,
               a.month_val val,
               a.month_target_rate target_rate,
               a.lst_month_val lst_val,
               a.month_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and a.factdate = (select * from factdate))
 where 1 = 1 and type1 = '1' --type1 = '${dim_cal}'
) 
,org as  (select org_id, org_name,/*lpad(org_name,length(org_name)+2*org_level)*/ case when org_level=2 then '  '||org_name  when org_level=3 then '    '||org_name else  org_name  end orgshowname,  parentid father_id, org_num order_key , org_code
from dim_org_jxjl o
where 1=1
and org_code like ( select org_code|| '%' from dim_org_jxjl where org_id='E0A3D386-D5C8-FB22-18DE-4424D49363B1'  )  --( select org_code|| '%' from dim_org_jxjl where org_id='${org}'  )
and isshow=1
order by to_number(org_num))


select *
  from (select r.*,
               o.orgshowname,
               o.order_key deptorderkey,
               case
                 when type2 like '%年' then
                  TO_CHAR(to_date(factdate, 'yyyyMM'), 'yyyy')
                 when type2 like '%季度' then
                  TO_CHAR(to_date(factdate, 'yyyyMM'), 'yyyyQ')
                 when type2 like '%月' then
                  TO_CHAR(to_date(factdate, 'yyyyMM'), 'yyyyQMM')
               END periodorderkey,
               case
                 when target_name like '%亩%' then
                  1
                 else
                  2
               end targetorder
          from result r, org o
         where r.org_id = o.org_id) res
 order by res.deptorderkey,res.periodorderkey,res.order_key,res.targetorder

/*

select TO_CHAR(to_date('201810','yyyyMM'),'yyyy') FROM  DUAL
select TO_CHAR(to_date('201810','yyyyMM'),'yyyyQ') FROM  DUAL
select TO_CHAR(to_date('201809','yyyyMM'),'yyyyQMM') FROM  DUAL

select lpad('abcde',length('abcde')+2) from dual

*/
/*
select org_id,
       org_name,
       length(org_name) + 2 * org_level,
       lpad(org_name, lengthb(org_name) + 2 * org_level) orgshowname,
       parentid father_id,
       org_num order_key,
       org_code
  from dim_org_jxjl o
 where 1 = 1
   and org_code like
       (select org_code || '%'
          from dim_org_jxjl
         where org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B1') --( select org_code|| '%' from dim_org_jxjl where org_id='${org}'  )
   and isshow = 1
order by to_number(org_num)
*/
