
-- 求合计值的部门

select *
  from (select o.org_id, o.org_sname, o.org_type, o.org_classify
          from dim_org o
         start with o.org_name = '产业新城（国内）'
        connect by prior o.org_id = o.father_id) orgres
 where orgres.org_type = '事业部'
--and orgres.org_classify='外埠'
;

--在条件中in 
select o.org_id
  from dim_org o
 start with o.org_name = '产业新城（国内）'
connect by prior o.org_id = o.father_id


-- 土地表
select * from dm_res_check_area a
;
select * from DM_RES_CHECK_REASON r
;

-- 1合计
select round(sum(res.usable_ind),2) 可用指标批复 
  from (select *
          from dm_res_check_area a
         where a.data_date = (select max(data_date) from dm_res_check_area)) res,
       (select *
          from (select o.org_id, o.org_sname, o.org_type, o.org_classify
                  from dim_org o
                 start with o.org_name = '产业新城（国内）'
                connect by prior o.org_id = o.father_id) orgres
         where orgres.org_type = '事业部') org
 where res.org_id = org.org_id
 ;
 
 
 -- list
 select *
   from (select round(sum(res.usable_ind), 2) 可用指标批复,
                org.org_sname 部门简称
           from (select *
                   from dm_res_check_area a
                  where a.data_date =
                        (select max(data_date) from dm_res_check_area)) res,
                (select *
                   from (select o.org_id,
                                o.org_sname,
                                o.org_type,
                                o.org_classify
                           from dim_org o
                          start with o.org_name = '产业新城（国内）'
                         connect by prior o.org_id = o.father_id) orgres
                  where orgres.org_type = '事业部') org
          where res.org_id = org.org_id
          group by org.org_sname
          order by nvl(sum(res.usable_ind), 0) desc) resulttable
  where rownum <= 10
  order by 可用指标批复 asc

-- title
-- 已确权未开工
select nvl(sum(res.no_in_right_uni), 0) + nvl(sum(res.no_out_right_uni), 0) 合计亩,
       nvl(sum(res.no_in_right_sq), 0) + nvl(sum(res.no_out_right_sq), 0) 合计万平,
       nvl(sum(res.no_in_right_uni), 0) 其中域内亩,
       nvl(sum(res.no_in_right_sq), 0) 其中域内万平,
       nvl(sum(res.no_out_right_uni), 0) 其中域外亩,
       nvl(sum(res.no_out_right_sq), 0) 其中域外万平
  from (select *
          from dm_res_check_area a
         where a.data_date = (select max(data_date) from dm_res_check_area)) res,
       (select *
          from (select o.org_id, o.org_sname, o.org_type, o.org_classify
                  from dim_org o
                 start with o.org_name = '产业新城（国内）'
                connect by prior o.org_id = o.father_id) orgres
         where orgres.org_type = '事业部') org
 where res.org_id = org.org_id

;
--已开工未预售
select nvl(sum(res.no_in_pre_uni), 0) + nvl(sum(res.no_out_pre_uni), 0) 合计亩,
       nvl(sum(res.no_in_pre_sq), 0) + nvl(sum(res.no_out_pre_sq), 0) 合计万平,
       nvl(sum(res.no_in_pre_uni), 0) 其中域内亩,
       nvl(sum(res.no_in_pre_sq), 0) 其中域内万平,
       nvl(sum(res.no_out_pre_uni), 0) 其中域外亩,
       nvl(sum(res.no_out_pre_sq), 0) 其中域外万平
  from (select *
          from dm_res_check_area a
         where a.data_date = (select max(data_date) from dm_res_check_area)) res,
       (select *
          from (select o.org_id, o.org_sname, o.org_type, o.org_classify
                  from dim_org o
                 start with o.org_name = '产业新城（国内）'
                connect by prior o.org_id = o.father_id) orgres
         where orgres.org_type = '事业部') org
 where res.org_id = org.org_id
;
-- 全部
select nvl(sum(res.no_in_right_uni), 0) + nvl(sum(res.no_out_right_uni), 0) +
       nvl(sum(res.no_in_pre_uni), 0) + nvl(sum(res.no_out_pre_uni), 0) 合计亩,
       nvl(sum(res.no_in_right_sq), 0) + nvl(sum(res.no_out_right_sq), 0) +
       nvl(sum(res.no_in_pre_sq), 0) + nvl(sum(res.no_out_pre_sq), 0) 合计万平,
       nvl(sum(res.no_in_right_uni), 0) + nvl(sum(res.no_in_pre_uni), 0) 其中域内亩,
       nvl(sum(res.no_in_right_sq), 0) + nvl(sum(res.no_in_pre_sq), 0) 其中域内万平,
       nvl(sum(res.no_out_right_uni), 0) + nvl(sum(res.no_out_pre_uni), 0) 其中域外亩,
       nvl(sum(res.no_out_right_sq), 0) + nvl(sum(res.no_out_pre_sq), 0) 其中域外万平
  from (select *
          from dm_res_check_area a
         where a.data_date = (select max(data_date) from dm_res_check_area)) res,
       (select *
          from (select o.org_id, o.org_sname, o.org_type, o.org_classify
                  from dim_org o
                 start with o.org_name = '产业新城（国内）'
                connect by prior o.org_id = o.father_id) orgres
         where orgres.org_type = '事业部') org
 where res.org_id = org.org_id
 
 
 -- list
select *
  from (select nvl(sum(res.no_in_pre_uni), 0) +
               nvl(sum(res.no_out_pre_uni), 0) 合计亩,
               org.org_sname 部门简称
          from (select *
                  from dm_res_check_area a
                 where a.data_date =
                       (select max(data_date) from dm_res_check_area)) res,
               (select *
                  from (select o.org_id,
                               o.org_sname,
                               o.org_type,
                               o.org_classify
                          from dim_org o
                         start with o.org_name = '产业新城（国内）'
                        connect by prior o.org_id = o.father_id) orgres
                 where orgres.org_type = '事业部') org
         where res.org_id = org.org_id
         group by org.org_sname
         order by nvl(sum(res.no_in_pre_uni), 0) +
                  nvl(sum(res.no_out_pre_uni), 0) desc)
 where rownum <= 10
 order by 合计亩 desc
 
 ;
 --1-type

 
 select sum(res.area_uni) 亩数, sum(res.area_sq) 万平数, res.reason 原因
   from (select r.*, rea.reason
           from DM_RES_CHECK_REASON r, dim_check_reason rea
          where r.data_date =
                (SELECT MAX(DATA_DATE) FROM DM_RES_CHECK_REASON)
            and r.house_sche_id = '已取证'
            and r.reason_id = rea.reason_id) res,
        (select *
           from (select o.org_id, o.org_sname, o.org_type, o.org_classify
                   from dim_org o
                  start with o.org_name = '产业新城（国内）'
                 connect by prior o.org_id = o.father_id) orgres
          where orgres.org_type = '事业部'
            and orgres.org_sname = '京南'
         --${if(len(deptment)=0,"", "and  orgres.org_sname='"+deptment+"'")}
         ) org
  where res.org_id = org.org_id
  group by res.reason
 
;
-- 房源 

select sum(f.store_value) store_value, f.formate_id
  from dm_res_check_formate f,dim_org o
 where f.data_date = (select max(data_date) from dm_res_check_formate)
 --and f.org_id=o.org_id
 group by f.formate_id
 

select sum(f.store_value) store_value, f.formate_id
  from dm_res_check_formate f,
 where f.data_date = (select max(data_date) from dm_res_check_formate)
 group by f.formate_id
select * from dm_res_check_formate f,dim_org o
where f.org_id=o.org_id



select *
  from (select nvl(sum(res.no_in_pre_uni), 0) +
               nvl(sum(res.no_out_pre_uni), 0) 合计亩,
               org.org_sname 部门简称
          from (select *
                  from dm_res_check_area a
                 where a.data_date =
                       (select max(data_date) from dm_res_check_area)) res,
               (select *
                  from (select o.org_id,
                               o.org_sname,
                               o.org_type,
                               o.org_classify
                          from dim_org o
                         start with o.org_name = '产业新城（国内）'
                        connect by prior o.org_id = o.father_id) orgres
                 where orgres.org_type = '区域') org,
                dim_org org_fa
         where res.org_id = org.org_id
         and org_fa.org_id=org.org_id
         group by org.org_sname
         order by nvl(sum(res.no_in_pre_uni), 0) +
                  nvl(sum(res.no_out_pre_uni), 0) desc)
 where rownum <= 10
 order by 合计亩 desc
 
 select max(datadate) from  DM_RES_CHECK_SALE_SIGN
 
 select * from  DM_RES_CHECK_SALE_SIGN s ,(select o.org_id
  from dim_org o
 start with o.org_name = '产业新城（国内）'
connect by prior o.org_id = o.father_id) o
where s.org_id=o.org_id 
and s.time_type_id='2017'
