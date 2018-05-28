
select nvl(a.target_value, 0) target_value,
       nvl(a.actual_value, 0) target_value,
       nvl(a.forecate_value, 0) target_value,
       nvl(a.last_actual_value, 0) target_value,
       nvl(a.last_rate_value, 0) target_value,
       a.period_type_id,
       i.*
  from (select *
          from dm_mcl_acct a
         right join
        
         (select * from dim_org o where o.org_name = '华夏幸福') o
            on a.org_id = o.org_id
        
        ) a
 right join (select *
               from dim_index i
              where i.index_name in ('无形资产投资', '固定资产投资')) i
    on a.index_id = i.index_id

;
select *
  from dm_mcl_acct a, dim_org o, dim_index i
 where a.org_id = o.org_id
   and a.index_id = i.index_id
   and i.index_name = '净现金流'
   and a.period_type_id = '年'
   and o.org_classify in  (&area)
   and o.org_name in (select org_name
                        from (select *
                                from dim_org o
                               start with org_name = &project
                              connect by prior o.org_id = o.father_id) o
                       where o.org_type = '区域')
   and o.org_name != &project
