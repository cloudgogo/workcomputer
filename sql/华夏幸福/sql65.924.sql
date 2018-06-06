select to_char(sysdate, 'yyyy') from dual; --年 
select to_char(sysdate, 'MM') from dual; --月 
select to_char(sysdate, 'dd') from dual; --日 
select to_char(sysdate, 'Q') from dual; --季 

-- 时间维度
select distinct period_year,
                period_quarter,
                period_month,
                week_nbr_in_month
  from dim_period
--年度
 where substr(period_year, 0, 4) = to_char(sysdate, 'yyyy')
      --季度
   and period_quarter = to_char(sysdate, 'Q') || '季度'
      --月度
   and period_month = to_char(sysdate, 'mm') || '月'
 order by cast(substr(period_quarter, 0, 1) as number),
          cast(substr(period_month, 0, 2) as number),
          cast(substr(week_nbr_in_month, 2, 1) as number);

-- 逻辑sql(old)

select acc.*, org.org_name
  from dm_mcl_acct_year acc, dim_org org, dim_index ind
 where acc.org_id = org.org_id
   and acc.index_id = ind.index_id
   and acc.data_year = to_char(sysdate, 'yyyy') -- pram2
   and ind.index_name = '签约' -- pram1
   and org_name in
       ('华夏幸福', '产业新城', '产业小镇', '孔雀城住宅', '物业')
union all
select acc.*, org.org_name || '全口径'
  from dm_mcl_acct_year acc, dim_org org, dim_index ind
 where acc.org_id = org.org_id
   and acc.index_id = ind.index_id
   and acc.data_year = to_char(sysdate, 'yyyy') -- pram2
   and ind.index_id = (select index_id
                         from (select *
                                 from dim_index i
                                start with i.index_name = '签约' -- pram1
                               connect by prior i.index_id = i.father_id) i
                        where i.index_name = '产业新城')
   and org_name = '产业新城'



select acc.target_value,acc.actual_value,acc.forecate_value,acc.last_actual_value,acc.last_rate_value, org.org_name
  from dm_mcl_acct acc, dim_org org, dim_index ind
 where acc.org_id = org.org_id
   and acc.index_id = ind.index_id
   and acc.data_year = to_char(sysdate, 'yyyy') -- pram2
   and ind.index_name = '签约' -- pram1
   and org_name in
       ('华夏幸福', '产业新城', '产业小镇', '孔雀城住宅', '物业')
