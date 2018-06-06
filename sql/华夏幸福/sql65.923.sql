   
   select * from  (
   select acc.target_value,
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
           and org.org_name = '产业新城')result
           where  result.period_type_id=to_char(sysdate-1,'yyyy')
           and  org_name=''
           
 
select 
