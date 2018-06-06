select G.DATA_DATE,
       o.org_id,
       o.org_name,
       o.org_sname,
       G.BUSI_DATE,
       sum(g.area_land) areanum
  from DM_RES_HANG_GER g, dim_org o
 where g.org_id = o.org_id
   and o.org_type = '区域'
   and g.hang_type = '计划挂牌'
 group by o.org_id, o.org_name, o.org_sname, G.DATA_DATE, G.BUSI_DATE;
/*
select * from dim_org

select distinct s.time_type_id from  DM_RES_CHECK_SALE_SIGN s
select  * from  DM_RES_CHECK_TREND_WEEK
*/

SELECT nvl(s.sign_target, 0) sign_target,
       nvl(s.sign_actual, 0) sign_actual,
       nvl(s.sign_actual / s.sign_target, 0) rate,
       nvl(s.sign_rate,0) time_rate,
       o.org_id,
       o.org_name,
       o.org_sname,
       nvl(sum(s.sign_actual) over() / sum(s.sign_target) over(), 0) rateall

  from DM_RES_CHECK_SALE_SIGN s, dim_org o
 where s.org_id = o.org_id
 ;
 
 select * from  DM_RES_CHECK_SALE_SIGN where  org_id= '050aa75f-dd93-4b29-bf6e-7c7ffc128443';
 
 
 SELECT * FROM DM_RES_CHECK_TREND_WEEK ;
 select sum(nvl(s.sign_target, 0)) sign_target,
       sum(nvl(s.sign_actual, 0)) sign_actual,
       sum(nvl(s.partner_target, 0)) partner_target,
       sum(nvl(s.partner_actual, 0)) partner_actual,
       case when length(s.time_type_id)=4 then '当年' else '当季' end period
  from DM_RES_CHECK_SALE_SIGN s, dim_org o
 where s.org_id = o.org_id
 --and s.time_type_id in ('2017','2017Q02')
   AND S.DATA_DATE= (SELECT MAX(DATA_DATE) FROM DM_RES_CHECK_SALE_SIGN)
   and s.time_type_id in  
       (to_char(sysdate, 'yyyy'),
        to_char(sysdate, 'yyyy') || 'Q0' || to_char(sysdate, 'Q')) 
 group by s.time_type_id

 ;
 
 select *
   from (select datetype, org_classify_id, WEEK_START, sum(amount) amount
           from (SELECT REPLACE(TO_CHAR(W.WEEK_START, 'MM') || '.' ||
                                TO_CHAR(W.WEEK_START, 'dd') || '-' ||
                                TO_CHAR(W.WEEK_END, 'MM') || '.' ||
                                TO_CHAR(W.WEEK_END, 'dd'),
                                '0',
                                '') datetype,
                        W.WEEK_START,
                        w.org_classify_id,
                        
                        w.amount
                   FROM DM_RES_CHECK_TREND_WEEK W
                  WHERE 1 = 1
                       --and w.ind_type='认购'
                    and org_classify_id in ('外埠', '环京')
                    AND W.DATA_DATE =
                        (SELECT MAX(DATA_DATE) FROM DM_RES_CHECK_SALE_SIGN)) res
          group by datetype, org_classify_id, WEEK_START
         
          ORDER BY res.WEEK_START desc) res
  where rownum <= 24
  order by res.datetype;
  select * from  DM_ACCOUNTS_RECEIVABLE
  ;
  select * from  (
  select o.org_name, o.org_sname, s.*
    from DM_RES_CHECK_STORE_SELL s, dim_org o
   where s.org_id = o.org_id
     and s.data_date = (SELECT MAX(DATA_DATE) FROM DM_RES_CHECK_STORE_SELL)
     order by STORE_SALE_RATE --${if(ordertype="前十名","desc","asc")}
     )res
     where rownum<=10
     
      select * from  (
  select o.org_name, o.org_sname, s.*
    from DM_RES_CHECK_SUPPLY_SELL s, dim_org o
   where s.org_id = o.org_id
     and s.data_date = (SELECT MAX(DATA_DATE) FROM DM_RES_CHECK_STORE_SELL)
     order by s.cycle --${if(ordertype="前十名","desc","asc")}
     )res
     where rownum<=10
     
     ;
     select * from  DM_RES_CHECK_SUPPLY_SELL s 
     
     ;
     select * from  DM_RES_CHECK_REASON
     ;
     
     select * from  DM_RES_RISK_RESOURCE;
     
     -- 土地1标题
     
     select sum(r.area_uni) area_uni,sum(r.area_sq) area_sq from  DM_RES_CHECK_REASON r,
     dim_org o,
     dim_check_reason rea
     where  r.data_date = (SELECT MAX(DATA_DATE) FROM DM_RES_CHECK_REASON)
     and  r.house_sche_id='未取地'
     and  o.org_id=r.org_id
     and  o.org_type=&orgtype
     and  r.reason_id=rea.reason_id
     
     
     -- 土地1
     select * from  DM_RES_RISK_RESOURCE;
     select r.house_sche_id,sum(r.area_uni) area_uni,sum(r.area_sq) area_sq,o.org_name,o.org_sname from  DM_RES_CHECK_REASON r,
     dim_org o,
     dim_check_reason rea
     where  r.data_date = (SELECT MAX(DATA_DATE) FROM DM_RES_CHECK_REASON)
     and  r.house_sche_id='未取地'
     and  o.org_id=r.org_id
     and  o.org_type=&orgtype
     and  r.reason_id=rea.reason_id
     
     group by r.house_sche_id,o.org_name,o.org_sname
    -- select * from  ;
    
    -- 土地2
     select r.house_sche_id,r.reason_id,sum(r.area_uni) area_uni,sum(r.area_sq) area_sq,o.org_name,o.org_sname,rea.reason from  DM_RES_CHECK_REASON r,
     dim_org o,
     dim_check_reason rea
     where  r.data_date = (SELECT MAX(DATA_DATE) FROM DM_RES_CHECK_REASON)
     and  r.house_sche_id='未取地'
     and  o.org_id=r.org_id
     and  o.org_sname=&orgsname
     and  o.org_type=&orgtype
     and  r.reason_id=rea.reason_id
     
     group by r.house_sche_id,r.reason_id,o.org_name,o.org_sname,rea.reason
     
     -- 土地3标题
     
     
     select sum(a.usable_ind) usable_ind,
            sum(a.no_in_right_uni) no_in_right_uni,
            sum(a.no_in_right_sq) no_in_right_sq,
            sum(a.no_out_right_uni) no_out_right_uni,
            sum(a.no_out_right_sq) no_out_right_sq,
            sum(a.no_in_pre_uni) no_in_pre_uni,
            sum(a.no_in_pre_sq) no_in_pre_sq,
            sum(a.no_out_pre_uni) no_out_pre_uni,
            sum(a.no_out_pre_sq) no_out_pre_sq/*,
            o.org_name org_name,
            o.org_sname org_sname*/
       from DM_RES_CHECK_AREA a, dim_org o
      where a.org_id = o.org_id
     
     
     -- 土地3
     select * from (
     select * from (
      select sum(a.no_in_right_uni) uni,
             sum(a.no_in_right_sq) sq,
             o.org_name org_name,
             o.org_sname org_sname,
             '域内' area,
             '已确权未开工' type
        from DM_RES_CHECK_AREA a, dim_org o
       where a.org_id = o.org_id
       and o.org_type=&orgtype
       and a.data_date=(select max(data_date) from DM_RES_CHECK_AREA)
       group by o.org_name, o.org_sname
      union all
      select sum(a.no_out_right_uni) uni,
             sum(a.no_out_right_sq) sq,
             o.org_name org_name,
             o.org_sname org_sname,
             '域外' area,
             '已确权未开工' type
        from DM_RES_CHECK_AREA a, dim_org o
       where a.org_id = o.org_id
       and o.org_type=&orgtype
       and a.data_date=(select max(data_date) from DM_RES_CHECK_AREA)
       group by o.org_name, o.org_sname
      union all
      select
      
       sum(a.no_in_pre_uni) uni,
       sum(a.no_in_pre_sq) sq,
       o.org_name org_name,
       o.org_sname org_sname,
       '域内' area,
       '已开工未预售' type
        from DM_RES_CHECK_AREA a, dim_org o
       where a.org_id = o.org_id
       and o.org_type=&orgtype
       and a.data_date=(select max(data_date) from DM_RES_CHECK_AREA)
       group by o.org_name, o.org_sname
      union all
      select
      
       sum(a.no_out_pre_uni) uni,
       sum(a.no_out_pre_sq) sq,
       o.org_name org_name,
       o.org_sname org_sname,
       '域内' area,
       '已开工未预售' type
        from DM_RES_CHECK_AREA a, dim_org o
       where a.org_id = o.org_id
       and o.org_type=&orgtype
       and a.data_date=(select max(data_date) from DM_RES_CHECK_AREA)
       group by o.org_name, o.org_sname) res
       where res.type=&type
       order by res.uni desc) r
       where rownum<=10    
       
        
     -- 土地4
     select sum(uni) uni ,type from (
     select * from (
      select sum(a.no_in_right_uni) uni,
             sum(a.no_in_right_sq) sq,
             o.org_name org_name,
             o.org_sname org_sname,
             '域内' area,
             '已确权未开工' type
        from DM_RES_CHECK_AREA a, dim_org o
       where a.org_id = o.org_id
       and o.org_type=&orgtype
       and a.data_date=(select max(data_date) from DM_RES_CHECK_AREA)
       group by o.org_name, o.org_sname
      union all
      select sum(a.no_out_right_uni) uni,
             sum(a.no_out_right_sq) sq,
             o.org_name org_name,
             o.org_sname org_sname,
             '域外' area,
             '已确权未开工' type
        from DM_RES_CHECK_AREA a, dim_org o
       where a.org_id = o.org_id
       and o.org_type=&orgtype
       and a.data_date=(select max(data_date) from DM_RES_CHECK_AREA)
       group by o.org_name, o.org_sname
      union all
      select
      
       sum(a.no_in_pre_uni) uni,
       sum(a.no_in_pre_sq) sq,
       o.org_name org_name,
       o.org_sname org_sname,
       '域内' area,
       '已开工未预售' type
        from DM_RES_CHECK_AREA a, dim_org o
       where a.org_id = o.org_id
       and o.org_type=&orgtype
       and a.data_date=(select max(data_date) from DM_RES_CHECK_AREA)
       group by o.org_name, o.org_sname
      union all
      select
      
       sum(a.no_out_pre_uni) uni,
       sum(a.no_out_pre_sq) sq,
       o.org_name org_name,
       o.org_sname org_sname,
       '域内' area,
       '已开工未预售' type
        from DM_RES_CHECK_AREA a, dim_org o
       where a.org_id = o.org_id
       and o.org_type=&orgtype
       and a.data_date=(select max(data_date) from DM_RES_CHECK_AREA)
       group by o.org_name, o.org_sname) res
       where res.type=&type
       and res.org_sname=&orgsname
       order by res.uni desc) r
       group by type
       
        
     
