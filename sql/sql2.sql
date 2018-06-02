
select acc_y.data_year,
       acc_y.target_value,
       acc_y.actual_value,
       acc_y.forecate_value,
       acc_y.last_actual_value,
       acc_y.last_rate_value,
       org.org_name
  from  dim_org org, dim_index ind,dm_mcl_acct_year acc_y,dm_mcl_acct_month acc_m
 where acc_y.org_id = org.org_id
   and acc_y.index_id = ind.index_id
   and acc_y.data_year = to_char(sysdate, 'yyyy') -- pram2
   and ind.index_name = 'ǩԼ' -- pram1
   and org_name in
       ('�����Ҹ�', '��ҵ�³�', '��ҵС��', '��ȸ��סլ', '��ҵ')
union all
select acc_y.data_year,
       acc_y.target_value,
       acc_y.actual_value,
       acc_y.forecate_value,
       acc_y.last_actual_value,
       acc_y.last_rate_value,
       org.org_name || 'ȫ�ھ�'
  from dm_mcl_acct_year acc_y, dim_org org, dim_index ind
 where acc_y.org_id = org.org_id
   and acc_y.index_id = ind.index_id
   and acc_y.data_year = to_char(sysdate, 'yyyy') -- pram2
   and ind.index_id = (select index_id
                         from (select *
                                 from dim_index i
                                start with i.index_name = 'ǩԼ' -- pram1
                               connect by prior i.index_id = i.father_id) i
                        where i.index_name = '��ҵ�³�')
   and org_name = '��ҵ�³�'
