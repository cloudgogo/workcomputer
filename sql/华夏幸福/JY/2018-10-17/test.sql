select cast (to_char(sysdate,'mm') as number)    as nowMonth from dual;   --��ȡʱ�����   
select cast (to_char(sysdate,'dd') as number)   as nowDay    from dual;   --��ȡʱ��

select *
  from dim_period d
 order by cast(to_char(d.period_date, 'yyyy') as number) asc,
          cast(to_char(d.period_date, 'mm') as number) desc,
          cast(to_char(d.period_date, 'dd') as number) asc
