WITH usedate as
 (select to_date(data_date, 'yyyyMMdd') usedate
    from dm_mcl_acct
   where rownum = 1),

-- ����ʱ��ά��

datetable as
 (
  --������ۺ�ʱ����Ҫ��ʾ
  select to_char(usedate, 'yyyy') code,
          to_char(usedate, 'yyyy') || '��' description,
          to_char(usedate, 'yyyy') ordercode
    from usedate
  union all
  --����������
select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') CODE,
                to_char(p.period_date, 'Q')||'����' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') ordercode
  from usedate u,dim_period p
 where to_char(p.period_date, 'yyyy') = to_char(u.usedate, 'yyyy') 
 and &periodtype='����'
union all
  --���ȼ��ȼ��¶ȵ����
select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') CODE,
                to_char(p.period_date, 'Q')||'����' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') ordercode
  from usedate u,dim_period p
 where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ') 
 and (&periodtype='����' or &periodtype='����')
 union all
  --�¶ȼ������
select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                to_char(p.period_date, 'MM') CODE,
                TO_CHAR(TO_NUMBER(to_char(p.period_date, 'MM')))||'��' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q')|| 'M' ||
                to_char(p.period_date, 'MM') ordercode
  from usedate u,dim_period p
 where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ') 
 and &periodtype='����'
union all
  --�¶��¶����
select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                to_char(p.period_date, 'MM') CODE,
                TO_NUMBER(to_char(p.period_date, 'MM'))||'��' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q')|| 'M' ||
                to_char(p.period_date, 'MM') ordercode
  from usedate u,dim_period p
 where to_char(p.period_date, 'yyyyMM') = to_char(u.usedate, 'yyyyMM') 
 and &periodtype='����'
UNION ALL
 --���µ���
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
    and &periodtype = '����'
 
  )
select * from datetable


;
 --����������
select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') CODE,
                to_char(p.period_date, 'Q')||'����' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') ordercode
  from dim_period p
 where to_char(p.period_date, 'yyyy') = to_char(sysdate, 'yyyy') 
 and &periodtype='����'
union all
  --���ȼ��ȼ��¶ȵ����
select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') CODE,
                to_char(p.period_date, 'Q')||'����' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q') ordercode
  from dim_period p
 where to_char(p.period_date, 'yyyyQ') = to_char(sysdate, 'yyyyQ') 
 and (&periodtype='����' or &periodtype='����')
 ;
  --�¶ȼ������
select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                to_char(p.period_date, 'MM') CODE,
                TO_CHAR(TO_NUMBER(to_char(p.period_date, 'MM')))||'��' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q')|| 'M' ||
                to_char(p.period_date, 'MM') ordercode
  from dim_period p
 where to_char(p.period_date, 'yyyyQ') = to_char(sysdate, 'yyyyQ') 
 and &periodtype='����'
union all
  --�¶��¶����
select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                to_char(p.period_date, 'MM') CODE,
                TO_NUMBER(to_char(p.period_date, 'MM'))||'��' description,
                to_char(p.period_date, 'yyyy') || 'Q0' ||
                to_char(p.period_date, 'Q')|| 'M' ||
                to_char(p.period_date, 'MM') ordercode
  from dim_period p
 where to_char(p.period_date, 'yyyyMM') = to_char(sysdate, 'yyyyMM') 
 and &periodtype='����'
 
;
 
 --���µ���
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
    and &periodtype = '����'
 
