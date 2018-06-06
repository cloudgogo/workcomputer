WITH DIM_DATEKJ AS
 (SELECT CASE
           WHEN &date = '当年' THEN
            PERIOD_YEAR
           WHEN &date = '当季' THEN
            PERIOD_QUARTER
           WHEN &date = '当月' THEN
            PERIOD_MONTH
         END AS CALIBER --找到我当前时间参数口径（当年、当季、当月）
    FROM DIM_PERIOD --时间维度
   WHERE PERIOD_KEY = to_char(sysdate - 1, 'yyyyMMdd')), --当前时间口径 年、季度、月份

DIM_DATEMX AS
 (SELECT DISTINCT CASE
                    WHEN &date = '当年' THEN
                     PERIOD_YEAR
                    WHEN &date = '当季' THEN
                     PERIOD_QUARTER
                    WHEN &date = '当月' THEN
                     PERIOD_MONTH
                  END AS DIM_CALIBER, --口径
                  CASE
                    WHEN &date = '当年' THEN
                     PERIOD_QUARTER
                    WHEN &date = '当季' THEN
                     PERIOD_MONTH
                    WHEN &date = '当月' THEN
                     WEEK_NBR_IN_MONTH
                  END AS DIM_CALIBER_S --口径2
    FROM DIM_PERIOD --时间维度
  ), --时间口径维度
DIM_DATES AS
 (SELECT CALIBER,
         CASE
           WHEN &date = '当年' THEN
            substr(CALIBER, 1, 4)
           WHEN &date = '当季' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'Q0' ||
            substr(CALIBER, 1, 1)
           WHEN &date = '当月' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(CALIBER, 1, 2)
         END as Statistical_time

    FROM DIM_DATEKJ
  UNION ALL
  SELECT b.DIM_CALIBER_S as CALIBER,
         CASE
           WHEN &date = '当年' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'Q0' ||
            substr(b.DIM_CALIBER_S, 1, 1)
           WHEN &date = '当季' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(b.DIM_CALIBER_S, 1, 2)
           WHEN &date = '当月' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 5, 2) || 'W' ||
            substr(b.DIM_CALIBER_S, 2, 1)
         END as Statistical_time
    FROM DIM_DATEKJ a
    LEFT JOIN DIM_DATEMX b
      ON a.CALIBER = b.DIM_CALIBER) --整理时间维度

--new

select *
  from (select acc.target_value,
               acc.actual_value,
               acc.forecate_value,
               acc.last_actual_value,
               acc.last_rate_value,
               
               decode(acc.target_value,0,0, acc.actual_value/acc.target_value) rate,
               case org.org_name 
                 when '孔雀城住宅' then
                  '住宅'
                 when '华夏幸福' then
                  '股份公司'
                 when '产业新城' then
                  '新城'
                 when '产业小镇' then
                  '小镇'
                 when '物业' then
                  '其他'
               end org_name,
               acc.period_type_id
          from dm_mcl_acct acc, dim_org org, dim_index ind
         where acc.org_id = org.org_id
           and acc.index_id = ind.index_id
           and ind.index_name = '签约' -- pram1
           and org.org_name in
               ('华夏幸福', '产业新城', '产业小镇', '孔雀城住宅', '物业')
        union all
        select acc.target_value,
               acc.actual_value,
               acc.forecate_value,
               acc.last_actual_value,
               acc.last_rate_value,
                decode(acc.target_value,0,0, acc.actual_value/acc.target_value) rate,
               '新城全口径' org_name,
               acc.period_type_id
          from dm_mcl_acct acc, dim_org org, dim_index ind
         where acc.org_id = org.org_id
           and acc.index_id = ind.index_id
           and ind.index_id =
               (select index_id
                  from (select *
                          from dim_index i
                         start with i.index_name = '签约'
                        connect by prior i.index_id = i.father_id) i
                 where i.index_name = '产业新城')
           and org.org_name = '产业新城') result
 right join DIM_DATES d
    on result.period_type_id in (d.Statistical_time)
    and result.org_name=&dept
 
order by d.Statistical_time
;
select acc.*, org.org_name
  from dm_mcl_acct_year acc, dim_org org, dim_index ind
 where acc.org_id = org.org_id
   and acc.index_id = ind.index_id
   and acc.data_year = to_char(sysdate - 1, 'yyyy') -- pram2
   and ind.index_name = '签约' -- pram1
   and org_name in
       ('华夏幸福', '产业新城', '产业小镇', '孔雀城住宅', '物业')
union all
select acc.*, org.org_name || '全口径'
  from dm_mcl_acct_year acc, dim_org org, dim_index ind
 where acc.org_id = org.org_id
   and acc.index_id = ind.index_id
   and acc.data_year = to_char(sysdate - 1, 'yyyy') -- pram2
   and ind.index_id = (select index_id
                         from (select *
                                 from dim_index i
                                start with i.index_name = '签约' -- pram1
                               connect by prior i.index_id = i.father_id) i
                        where i.index_name = '产业新城')
   and org_name = '产业新城'

;
