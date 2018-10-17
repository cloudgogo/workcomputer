select cast (to_char(sysdate,'mm') as number)    as nowMonth from dual;   --获取时间的月   
select cast (to_char(sysdate,'dd') as number)   as nowDay    from dual;   --获取时间

select *
  from dim_period d
 order by cast(to_char(d.period_date, 'yyyy') as number) asc,
          cast(to_char(d.period_date, 'mm') as number) desc,
          cast(to_char(d.period_date, 'dd') as number) asc
