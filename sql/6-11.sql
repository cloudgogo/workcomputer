
-- ��ϼ�ֵ�Ĳ���

select *
  from (select o.org_id, o.org_sname, o.org_type, o.org_classify
          from dim_org o
         start with o.org_name = '��ҵ�³ǣ����ڣ�'
        connect by prior o.org_id = o.father_id) orgres
 where orgres.org_type = '��ҵ��'
--and orgres.org_classify='�Ⲻ'
;

--��������in 
select o.org_id
  from dim_org o
 start with o.org_name = '��ҵ�³ǣ����ڣ�'
connect by prior o.org_id = o.father_id


-- ���ر�
select * from dm_res_check_area a
;
select * from DM_RES_CHECK_REASON r
;

-- 1�ϼ�
select round(sum(res.usable_ind),2) ����ָ������ 
  from (select *
          from dm_res_check_area a
         where a.data_date = (select max(data_date) from dm_res_check_area)) res,
       (select *
          from (select o.org_id, o.org_sname, o.org_type, o.org_classify
                  from dim_org o
                 start with o.org_name = '��ҵ�³ǣ����ڣ�'
                connect by prior o.org_id = o.father_id) orgres
         where orgres.org_type = '��ҵ��') org
 where res.org_id = org.org_id
 ;
 
 
 -- list
 select *
   from (select round(sum(res.usable_ind), 2) ����ָ������,
                org.org_sname ���ż��
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
                          start with o.org_name = '��ҵ�³ǣ����ڣ�'
                         connect by prior o.org_id = o.father_id) orgres
                  where orgres.org_type = '��ҵ��') org
          where res.org_id = org.org_id
          group by org.org_sname
          order by nvl(sum(res.usable_ind), 0) desc) resulttable
  where rownum <= 10
  order by ����ָ������ asc

-- title
-- ��ȷȨδ����
select nvl(sum(res.no_in_right_uni), 0) + nvl(sum(res.no_out_right_uni), 0) �ϼ�Ķ,
       nvl(sum(res.no_in_right_sq), 0) + nvl(sum(res.no_out_right_sq), 0) �ϼ���ƽ,
       nvl(sum(res.no_in_right_uni), 0) ��������Ķ,
       nvl(sum(res.no_in_right_sq), 0) ����������ƽ,
       nvl(sum(res.no_out_right_uni), 0) ��������Ķ,
       nvl(sum(res.no_out_right_sq), 0) ����������ƽ
  from (select *
          from dm_res_check_area a
         where a.data_date = (select max(data_date) from dm_res_check_area)) res,
       (select *
          from (select o.org_id, o.org_sname, o.org_type, o.org_classify
                  from dim_org o
                 start with o.org_name = '��ҵ�³ǣ����ڣ�'
                connect by prior o.org_id = o.father_id) orgres
         where orgres.org_type = '��ҵ��') org
 where res.org_id = org.org_id

;
--�ѿ���δԤ��
select nvl(sum(res.no_in_pre_uni), 0) + nvl(sum(res.no_out_pre_uni), 0) �ϼ�Ķ,
       nvl(sum(res.no_in_pre_sq), 0) + nvl(sum(res.no_out_pre_sq), 0) �ϼ���ƽ,
       nvl(sum(res.no_in_pre_uni), 0) ��������Ķ,
       nvl(sum(res.no_in_pre_sq), 0) ����������ƽ,
       nvl(sum(res.no_out_pre_uni), 0) ��������Ķ,
       nvl(sum(res.no_out_pre_sq), 0) ����������ƽ
  from (select *
          from dm_res_check_area a
         where a.data_date = (select max(data_date) from dm_res_check_area)) res,
       (select *
          from (select o.org_id, o.org_sname, o.org_type, o.org_classify
                  from dim_org o
                 start with o.org_name = '��ҵ�³ǣ����ڣ�'
                connect by prior o.org_id = o.father_id) orgres
         where orgres.org_type = '��ҵ��') org
 where res.org_id = org.org_id
;
-- ȫ��
select nvl(sum(res.no_in_right_uni), 0) + nvl(sum(res.no_out_right_uni), 0) +
       nvl(sum(res.no_in_pre_uni), 0) + nvl(sum(res.no_out_pre_uni), 0) �ϼ�Ķ,
       nvl(sum(res.no_in_right_sq), 0) + nvl(sum(res.no_out_right_sq), 0) +
       nvl(sum(res.no_in_pre_sq), 0) + nvl(sum(res.no_out_pre_sq), 0) �ϼ���ƽ,
       nvl(sum(res.no_in_right_uni), 0) + nvl(sum(res.no_in_pre_uni), 0) ��������Ķ,
       nvl(sum(res.no_in_right_sq), 0) + nvl(sum(res.no_in_pre_sq), 0) ����������ƽ,
       nvl(sum(res.no_out_right_uni), 0) + nvl(sum(res.no_out_pre_uni), 0) ��������Ķ,
       nvl(sum(res.no_out_right_sq), 0) + nvl(sum(res.no_out_pre_sq), 0) ����������ƽ
  from (select *
          from dm_res_check_area a
         where a.data_date = (select max(data_date) from dm_res_check_area)) res,
       (select *
          from (select o.org_id, o.org_sname, o.org_type, o.org_classify
                  from dim_org o
                 start with o.org_name = '��ҵ�³ǣ����ڣ�'
                connect by prior o.org_id = o.father_id) orgres
         where orgres.org_type = '��ҵ��') org
 where res.org_id = org.org_id
 
 
 -- list
select *
  from (select nvl(sum(res.no_in_pre_uni), 0) +
               nvl(sum(res.no_out_pre_uni), 0) �ϼ�Ķ,
               org.org_sname ���ż��
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
                         start with o.org_name = '��ҵ�³ǣ����ڣ�'
                        connect by prior o.org_id = o.father_id) orgres
                 where orgres.org_type = '��ҵ��') org
         where res.org_id = org.org_id
         group by org.org_sname
         order by nvl(sum(res.no_in_pre_uni), 0) +
                  nvl(sum(res.no_out_pre_uni), 0) desc)
 where rownum <= 10
 order by �ϼ�Ķ desc
 
 ;
 --1-type

 
 select sum(res.area_uni) Ķ��, sum(res.area_sq) ��ƽ��, res.reason ԭ��
   from (select r.*, rea.reason
           from DM_RES_CHECK_REASON r, dim_check_reason rea
          where r.data_date =
                (SELECT MAX(DATA_DATE) FROM DM_RES_CHECK_REASON)
            and r.house_sche_id = '��ȡ֤'
            and r.reason_id = rea.reason_id) res,
        (select *
           from (select o.org_id, o.org_sname, o.org_type, o.org_classify
                   from dim_org o
                  start with o.org_name = '��ҵ�³ǣ����ڣ�'
                 connect by prior o.org_id = o.father_id) orgres
          where orgres.org_type = '��ҵ��'
            and orgres.org_sname = '����'
         --${if(len(deptment)=0,"", "and  orgres.org_sname='"+deptment+"'")}
         ) org
  where res.org_id = org.org_id
  group by res.reason
 
;
-- ��Դ 

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
               nvl(sum(res.no_out_pre_uni), 0) �ϼ�Ķ,
               org.org_sname ���ż��
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
                         start with o.org_name = '��ҵ�³ǣ����ڣ�'
                        connect by prior o.org_id = o.father_id) orgres
                 where orgres.org_type = '����') org,
                dim_org org_fa
         where res.org_id = org.org_id
         and org_fa.org_id=org.org_id
         group by org.org_sname
         order by nvl(sum(res.no_in_pre_uni), 0) +
                  nvl(sum(res.no_out_pre_uni), 0) desc)
 where rownum <= 10
 order by �ϼ�Ķ desc
 
 select max(datadate) from  DM_RES_CHECK_SALE_SIGN
 
 select * from  DM_RES_CHECK_SALE_SIGN s ,(select o.org_id
  from dim_org o
 start with o.org_name = '��ҵ�³ǣ����ڣ�'
connect by prior o.org_id = o.father_id) o
where s.org_id=o.org_id 
and s.time_type_id='2017'
