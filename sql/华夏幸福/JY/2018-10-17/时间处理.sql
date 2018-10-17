WITH usedate as
 (select to_date(data_date, 'yyyyMMdd') usedate
    from dm_mcl_acct
   where rownum = 1),

-- 处理时间维度

datetable as
 (
  --年度无论何时都需要显示
  select to_char(usedate, 'yyyy') code,
          to_char(usedate, 'yyyy') || '年' description,
          to_char(usedate, 'yyyy') ordercode
    from usedate
  union all
  --季度年度情况
select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') CODE,
                to_char(p.period_date, 'Q')||'季度' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') ordercode
  from usedate u,dim_period p
 where to_char(p.period_date, 'yyyy') = to_char(u.usedate, 'yyyy') 
 and &periodtype='当年'
union all
  --季度季度及月度的情况
select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') CODE,
                to_char(p.period_date, 'Q')||'季度' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') ordercode
  from usedate u,dim_period p
 where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ') 
 and (&periodtype='当季' or &periodtype='当月')
 union all
  --月度季度情况
select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                to_char(p.period_date, 'MM') CODE,
                TO_CHAR(TO_NUMBER(to_char(p.period_date, 'MM')))||'月' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q')|| 'M' ||
                to_char(p.period_date, 'MM') ordercode
  from usedate u,dim_period p
 where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ') 
 and &periodtype='当季'
union all
  --月度月度情况
select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                to_char(p.period_date, 'MM') CODE,
                TO_NUMBER(to_char(p.period_date, 'MM'))||'月' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q')|| 'M' ||
                to_char(p.period_date, 'MM') ordercode
  from usedate u,dim_period p
 where to_char(p.period_date, 'yyyyMM') = to_char(u.usedate, 'yyyyMM') 
 and &periodtype='当月'
UNION ALL
 --当月的周
 select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                 to_char(p.period_date, 'MM') || 'W' ||
                 SUBSTR(P.WEEK_IN_MONTH, 2, 1) CODE,
                 P.WEEK_IN_MONTH description,
                 to_char(p.period_date, 'yyyy') || 'Q0' ||
                 to_char(p.period_date, 'Q') || 'M' ||
                 to_char(p.period_date, 'MM') || 'W' ||
                 SUBSTR(P.WEEK_IN_MONTH, 2, 1) ordercode
   from usedate u,dim_period p
  where to_char(p.period_date, 'yyyyMM') = to_char(U.usedate, 'yyyyMM')
    and &periodtype = '当月'
 
  )
select * from datetable


;
 --季度年度情况
select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') CODE,
                to_char(p.period_date, 'Q')||'季度' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') ordercode
  from dim_period p
 where to_char(p.period_date, 'yyyy') = to_char(sysdate, 'yyyy') 
 and &periodtype='当年'
union all
  --季度季度及月度的情况
select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') CODE,
                to_char(p.period_date, 'Q')||'季度' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') ordercode
  from dim_period p
 where to_char(p.period_date, 'yyyyQ') = to_char(sysdate, 'yyyyQ') 
 and (&periodtype='当季' or &periodtype='当月')
 ;
  --月度季度情况
select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                to_char(p.period_date, 'MM') CODE,
                TO_CHAR(TO_NUMBER(to_char(p.period_date, 'MM')))||'月' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q')|| 'M' ||
                to_char(p.period_date, 'MM') ordercode
  from dim_period p
 where to_char(p.period_date, 'yyyyQ') = to_char(sysdate, 'yyyyQ') 
 and &periodtype='当季'
union all
  --月度月度情况
select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                to_char(p.period_date, 'MM') CODE,
                TO_NUMBER(to_char(p.period_date, 'MM'))||'月' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q')|| 'M' ||
                to_char(p.period_date, 'MM') ordercode
  from dim_period p
 where to_char(p.period_date, 'yyyyMM') = to_char(sysdate, 'yyyyMM') 
 and &periodtype='当月'
 
;
 
 --当月的周
 select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                 to_char(p.period_date, 'MM') || 'W' ||
                 SUBSTR(P.WEEK_IN_MONTH, 2, 1) CODE,
                 P.WEEK_IN_MONTH description,
                 to_char(p.period_date, 'yyyy') || 'Q0' ||
                 to_char(p.period_date, 'Q') || 'M' ||
                 to_char(p.period_date, 'MM') || 'W' ||
                 SUBSTR(P.WEEK_IN_MONTH, 2, 1) ordercode
   from dim_period p
  where to_char(p.period_date, 'yyyyMM') = to_char(sysdate, 'yyyyMM')
    and &periodtype = '当月'
 
