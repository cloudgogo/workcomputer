with result as (SELECT people.*,amount.AMOUNT
    FROM (select result.unit_id,
                 result.unit_name,
                 result.department,
                 result.dept_name,
                 result.status_flow,
                 sum(result.six_sevenlevel) six_sevenlevel,
                 sum(result.overeightlevel) overeightlevel,
                 sum(result.allcount) allcount,
                 result.year,
                 result.quarter
            from (select s.unit_id,
                         s.unit_name,
                         s.department,
                         s.dept_name,
                         s.status_flow,
                         case
                           when s.pro_level between '06' and '07' then
                            1
                         end six_sevenlevel,
                         case
                           when s.pro_level between '08' and 'ZZ' then
                            1
                         end overeightlevel,
                         1 allcount,
                         to_char(s.date_flow, 'yyyy') year,
                         to_char(s.date_flow, 'Q') quarter
                    from ODS_HR_CANDIDATO_S s
                   where s.status_flow in ('090', '075')) result
           group by result.unit_id,
                    result.department,
                    result.unit_name,
                    result.dept_name,
                    result.status_flow,
                    result.year,
                    result.quarter) people
    left join
  
   (SELECT c.unit_id,
           c.department,
           c.status_flow_n,
           SUM(C.COST_HEADHUNTER + C.COST_INTERPOLATION + C.BACK_TONE +
               C.PHYSICAL_EXAMINATION + C.TRAVEL) AMOUNT,
           to_char(c.date_flow_n, 'yyyy') year,
           to_char(c.date_flow_n, 'Q') quarter
      FROM ODS_HR_CANDIDATO_COST C
     WHERE C.STATUS_FLOW_N IN ('090', '075')
     GROUP BY c.unit_id,
              c.unit_name,
              c.department,
              c.dept_name,
              c.status_flow_n,
              to_char(c.date_flow_n, 'yyyy'),
              to_char(c.date_flow_n, 'Q')) amount
      on people.unit_id = amount.unit_id
      and people.department=amount.department
      and people.status_flow=amount.status_flow_n
      and people.year=amount.year
      and people.quarter=amount.quarter)
      
      
      select r1.unit_id,
           r1.unit_name,
           r1.department,
           r1.unit_id||r1.department org_id,
           r1.dept_name,
           r1.status_flow,
           r1.year,
           r1.quarter,
           sum(r2.six_sevenlevel) yearsix_sevenlevel,sum(r2.overeightlevel) yearovereightlevel,sum(r2.allcount) yearallcount,sum(r2.amount) yearamount from result r1 ,result r2
      where r1.unit_id = r2.unit_id
      and r1.department=r2.department
      and r1.status_flow=r2.status_flow
      and r1.year=r2.year
      and r1.quarter>=r2.quarter
      group by r1.unit_id,
           r1.unit_name,
           r1.department,
           r1.dept_name,
           r1.status_flow,
           r1.year,
           r1.quarter
           order by r1.dept_name, r1.status_flow,r1.year,
           r1.quarter
