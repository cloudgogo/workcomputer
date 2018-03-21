select result.segment2,
       result.segment6,
       sum(result.income) income,
       sum(result.payment) payment,
       sum(result.expense) expense
  from (select a.segment2,
               a.segment6,
               case
                 when a.segment3 between '6021' and '6111ZZ' then
                  a.amount
               end income,
               case
                 when a.segment3 between '6421' and '6421ZZ' then
                  a.amount
               end payment,
               case
                 when a.segment3 between '6601' and '6901ZZ' then
                  a.amount
               end expense
          from (
                
                select i.segment2,
                        i.segment6,
                        i.segment3,
                        nvl(i.entered_dr, 0) - nvl(i.entered_cr, 0) amount
                
                  from CUX_GL_INTERFACE_INVESTBANK i
                 where 1 = 1
                   and i.period_name between '${p_period_s}' and
                       '${p_period_e}'
                   and ${IF(LEN(p_company) == 0,
                            "1=1",
                            " i.segment1 in ('" + p_company + "')")
                 }
                   and ${IF(LEN(p_department) == 0,
                            "1=1",
                            " i.segment2 in ('" + p_department + "')")
                 }
                   and ${IF(LEN(p_project) == 0,
                            "1=1",
                            " i.segment6 in ('" + p_project + "')")
                 }
                   and ${IF(LEN(p_datasource) == 0,
                            "1=1",
                            " i.data_source in ('" + p_datasource + "')") }
                --  order by i.period_name, i.je_header_id, i.je_line_num
                ) a) result
 group by result.segment2, result.segment6
 order by result.segment2, result.segment6
