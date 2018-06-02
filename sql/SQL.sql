
select  to_char(sysdate, 'yyyy' )  from dual; --�� 
select  to_char(sysdate, 'MM' )  from dual; --�� 
select  to_char(sysdate, 'dd' )  from dual; --�� 
select  to_char(sysdate, 'Q')  from dual; --�� 

select substr('2018Q01 ',0,4) from dual;


select * from dm_mcl_acct_quarter;


select * from  dm_mcl_acct_month;
select * from  dim_period;

select * 

select distinct period_quarter from dim_period where ;


-- result1
select *
  from (select result.*,
               case result.org_name
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
                 when '��ҵ�³�ȫ�ھ�' then
                  '�³�ȫ�ھ�'
               end org_name_o
          from (select acc.*, org.org_name
                  from dm_mcl_acct_year acc, dim_org org, dim_index ind
                 where acc.org_id = org.org_id
                   and acc.index_id = ind.index_id
                   and acc.data_year = to_char(sysdate, 'yyyy')
                   and ind.index_name = 'ǩԼ'
                   and org_name in ('�����Ҹ�',
                                    '��ҵ�³�',
                                    '��ҵС��',
                                    '��ȸ��סլ',
                                    '��ҵ')
                union all
                select acc.*, org.org_name || 'ȫ�ھ�'
                  from dm_mcl_acct_year acc, dim_org org, dim_index ind
                 where acc.org_id = org.org_id
                   and acc.index_id = ind.index_id
                   and acc.data_year = to_char(sysdate, 'yyyy')
                   and ind.index_id =
                       (select index_id
                          from (select *
                                  from dim_index i
                                 start with i.index_name = 'ǩԼ'
                                connect by prior i.index_id = i.father_id) i
                         where i.index_name = '��ҵ�³�')
                   and org_name = '��ҵ�³�') result) res
 where res.org_name_o = '�³�';
 
 
 --result2 
 --���
select res.*,'����' period,'����' periodtype
  from (select result.*,
               case result.org_name
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
                 when '��ҵ�³�ȫ�ھ�' then
                  '�³�ȫ�ھ�'
               end org_name_o
          from (select acc.*, org.org_name
                  from dm_mcl_acct_year acc, dim_org org, dim_index ind
                 where acc.org_id = org.org_id
                   and acc.index_id = ind.index_id
                   and acc.data_year = to_char(sysdate, 'yyyy')
                   and ind.index_name = 'ǩԼ'
                   and org_name in ('�����Ҹ�',
                                    '��ҵ�³�',
                                    '��ҵС��',
                                    '��ȸ��סլ',
                                    '��ҵ')
                union all
                select acc.*, org.org_name || 'ȫ�ھ�'
                  from dm_mcl_acct_year acc, dim_org org, dim_index ind
                 where acc.org_id = org.org_id
                   and acc.index_id = ind.index_id
                   and acc.data_year = to_char(sysdate, 'yyyy')
                   and ind.index_id =
                       (select index_id
                          from (select *
                                  from dim_index i
                                 start with i.index_name = 'ǩԼ'
                                connect by prior i.index_id = i.father_id) i
                         where i.index_name = '��ҵ�³�')
                   and org_name = '��ҵ�³�') result) res
 where res.org_name_o = '�³�'
 
union all 
 --��ȶ�Ӧ�ļ���
 select res.*,  CASE substr(res.data_quarter,6,2) WHEN '01' THEN  'һ' when '02' then '��' when '03' then '��' when '04' then '��' end ||'����' period,'����' periodtype
  from (select result.*,
               case result.org_name
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
                 when '��ҵ�³�ȫ�ھ�' then
                  '�³�ȫ�ھ�'
               end org_name_o
          from (select acc.*, org.org_name
                  from dm_mcl_acct_quarter acc, dim_org org, dim_index ind
                 where acc.org_id = org.org_id
                   and acc.index_id = ind.index_id
                   and acc.data_year = to_char(sysdate, 'yyyy')
                   and ind.index_name = 'ǩԼ'
                   and org_name in ('�����Ҹ�',
                                    '��ҵ�³�',
                                    '��ҵС��',
                                    '��ȸ��סլ',
                                    '��ҵ')
                union all
                select acc.*, org.org_name || 'ȫ�ھ�'
                  from dm_mcl_acct_quarter acc, dim_org org, dim_index ind
                 where acc.org_id = org.org_id
                   and acc.index_id = ind.index_id
                   and acc.data_year = to_char(sysdate, 'yyyy')
                   and ind.index_id =
                       (select index_id
                          from (select *
                                  from dim_index i
                                 start with i.index_name = 'ǩԼ'
                                connect by prior i.index_id = i.father_id) i
                         where i.index_name = '��ҵ�³�')
                   and org_name = '��ҵ�³�') result) res
 where res.org_name_o = '�³�'
 
 union all 
 --����
 

 --���ȶ�Ӧ���¶�
  select res.*,  '����' period,'����' periodtype
  from (select result.*,
               case result.org_name
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
                 when '��ҵ�³�ȫ�ھ�' then
                  '�³�ȫ�ھ�'
               end org_name_o
          from (select acc.*, org.org_name
                  from dm_mcl_acct_month acc, dim_org org, dim_index ind
                 where acc.org_id = org.org_id
                   and acc.index_id = ind.index_id
                   and acc.data_quarter= to_char(sysdate, 'Q')||'����'||' '  
                   and ind.index_name = 'ǩԼ'
                   and org_name in ('�����Ҹ�',
                                    '��ҵ�³�',
                                    '��ҵС��',
                                    '��ȸ��סլ',
                                    '��ҵ')
                union all
                select acc.*, org.org_name || 'ȫ�ھ�'
                  from dm_mcl_acct_month acc, dim_org org, dim_index ind
                 where acc.org_id = org.org_id
                   and acc.index_id = ind.index_id
                   and acc.data_quarter= to_char(sysdate, 'Q')||'����'||' '
                   and ind.index_id =
                       (select index_id
                          from (select *
                                  from dim_index i
                                 start with i.index_name = 'ǩԼ'
                                connect by prior i.index_id = i.father_id) i
                         where i.index_name = '��ҵ�³�')
                   and org_name = '��ҵ�³�') result) res
 where res.org_name_o = '�³�';
 
 -- ʱ��ά��
 select distinct period_year,
                 period_quarter,
                 period_month,
                 week_nbr_in_month
   from dim_period
  --���
  where substr(period_year, 0, 4) = to_char(sysdate, 'yyyy')
  --����
  and period_quarter= to_char(sysdate, 'Q')||'����'
  --�¶�
  and period_month=to_char(sysdate, 'mm')||'��'
  order by cast(substr(period_quarter, 0, 1) as number),
           cast(substr(period_month, 0, 2) as number),
           cast(substr(week_nbr_in_month, 2, 1) as number)
 ;
 
 
 select distinct period_type_id from dm_mcl_acct 
 
 
 