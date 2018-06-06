   
   select * from  (
   select acc.target_value,
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
           and org.org_name = '��ҵ�³�')result
           where  result.period_type_id=to_char(sysdate-1,'yyyy')
           and  org_name=''
           
 
select 
