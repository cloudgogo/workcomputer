WITH DIM_DATEKJ AS
 (SELECT CASE
           WHEN &date = '����' THEN
            PERIOD_YEAR
           WHEN &date = '����' THEN
            PERIOD_QUARTER
           WHEN &date = '����' THEN
            PERIOD_MONTH
         END AS CALIBER --�ҵ��ҵ�ǰʱ������ھ������ꡢ���������£�
    FROM DIM_PERIOD --ʱ��ά��
   WHERE PERIOD_KEY = to_char(sysdate - 1, 'yyyyMMdd')), --��ǰʱ��ھ� �ꡢ���ȡ��·�

DIM_DATEMX AS
 (SELECT DISTINCT CASE
                    WHEN &date = '����' THEN
                     PERIOD_YEAR
                    WHEN &date = '����' THEN
                     PERIOD_QUARTER
                    WHEN &date = '����' THEN
                     PERIOD_MONTH
                  END AS DIM_CALIBER, --�ھ�
                  CASE
                    WHEN &date = '����' THEN
                     PERIOD_QUARTER
                    WHEN &date = '����' THEN
                     PERIOD_MONTH
                    WHEN &date = '����' THEN
                     WEEK_NBR_IN_MONTH
                  END AS DIM_CALIBER_S --�ھ�2
    FROM DIM_PERIOD --ʱ��ά��
  ), --ʱ��ھ�ά��
DIM_DATES AS
 (SELECT CALIBER,
         CASE
           WHEN &date = '����' THEN
            substr(CALIBER, 1, 4)
           WHEN &date = '����' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'Q0' ||
            substr(CALIBER, 1, 1)
           WHEN &date = '����' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(CALIBER, 1, 2)
         END as Statistical_time

    FROM DIM_DATEKJ
  UNION ALL
  SELECT b.DIM_CALIBER_S as CALIBER,
         CASE
           WHEN &date = '����' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'Q0' ||
            substr(b.DIM_CALIBER_S, 1, 1)
           WHEN &date = '����' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(b.DIM_CALIBER_S, 1, 2)
           WHEN &date = '����' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 5, 2) || 'W' ||
            substr(b.DIM_CALIBER_S, 2, 1)
         END as Statistical_time
    FROM DIM_DATEKJ a
    LEFT JOIN DIM_DATEMX b
      ON a.CALIBER = b.DIM_CALIBER) --����ʱ��ά��

--new

select *
  from (select acc.target_value,
               acc.actual_value,
               acc.forecate_value,
               acc.last_actual_value,
               acc.last_rate_value,
               
               decode(acc.target_value,0,0, acc.actual_value/acc.target_value) rate,
               case org.org_name 
                 when '��ȸ��סլ' then
                  'סլ'
                 when '�����Ҹ�' then
                  '�ɷݹ�˾'
                 when '��ҵ�³�' then
                  '�³�'
                 when '��ҵС��' then
                  'С��'
                 when '��ҵ' then
                  '����'
               end org_name,
               acc.period_type_id
          from dm_mcl_acct acc, dim_org org, dim_index ind
         where acc.org_id = org.org_id
           and acc.index_id = ind.index_id
           and ind.index_name = 'ǩԼ' -- pram1
           and org.org_name in
               ('�����Ҹ�', '��ҵ�³�', '��ҵС��', '��ȸ��סլ', '��ҵ')
        union all
        select acc.target_value,
               acc.actual_value,
               acc.forecate_value,
               acc.last_actual_value,
               acc.last_rate_value,
                decode(acc.target_value,0,0, acc.actual_value/acc.target_value) rate,
               '�³�ȫ�ھ�' org_name,
               acc.period_type_id
          from dm_mcl_acct acc, dim_org org, dim_index ind
         where acc.org_id = org.org_id
           and acc.index_id = ind.index_id
           and ind.index_id =
               (select index_id
                  from (select *
                          from dim_index i
                         start with i.index_name = 'ǩԼ'
                        connect by prior i.index_id = i.father_id) i
                 where i.index_name = '��ҵ�³�')
           and org.org_name = '��ҵ�³�') result
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
   and ind.index_name = 'ǩԼ' -- pram1
   and org_name in
       ('�����Ҹ�', '��ҵ�³�', '��ҵС��', '��ȸ��סլ', '��ҵ')
union all
select acc.*, org.org_name || 'ȫ�ھ�'
  from dm_mcl_acct_year acc, dim_org org, dim_index ind
 where acc.org_id = org.org_id
   and acc.index_id = ind.index_id
   and acc.data_year = to_char(sysdate - 1, 'yyyy') -- pram2
   and ind.index_id = (select index_id
                         from (select *
                                 from dim_index i
                                start with i.index_name = 'ǩԼ' -- pram1
                               connect by prior i.index_id = i.father_id) i
                        where i.index_name = '��ҵ�³�')
   and org_name = '��ҵ�³�'

;
