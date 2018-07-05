select *
  from (select r.orgid,r.orgname,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = '住宅用地合计（亩）' then
                      r.target
                   end) as 当年目标,
               
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = '住宅用地合计（亩）' then
                      r.actual
                   end) as 当年实际,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = '住宅用地合计（亩）' then
                      (r.target_rate)
                   end) as 当年完成率,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = '住宅用地合计（亩）' then
                      case
                        when r.ytyval is null or r.ytyval = 0 then
                         null
                        else
                         (r.actual / r.ytyval) - 1
                      end
                   end) as 当年同比增长,
               sum(case
                     when r.factdate = to_char(sysdate - 365, 'yyyy') and
                          r.targetname = '住宅用地合计（亩）' then
                      r.actual
                   end) as 年同期,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') || 'Q' ||
                          to_char(sysdate, 'Q') and r.targetname = '住宅用地合计（亩）' then
                      r.target
                   end) as 当季目标,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') || 'Q' ||
                          to_char(sysdate, 'Q') and r.targetname = '住宅用地合计（亩）' then
                      r.actual
                   end) as 当季实际,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') || 'Q' ||
                          to_char(sysdate, 'Q') and r.targetname = '住宅用地合计（亩）' then
                      r.target_rate
                   end) as 当季完成率,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') || 'Q' ||
                          to_char(sysdate, 'Q') and r.targetname = '住宅用地合计（亩）' then
                      case
                        when r.ytyval is null or r.ytyval = 0 then
                         null
                        else
                         (r.actual / r.ytyval) - 1
                      end
                   end) as 当季同比增长,
               sum(case
                     when r.factdate = to_char(sysdate - 365, 'yyyy') || 'Q' ||
                          to_char(sysdate, 'Q') and r.targetname = '住宅用地合计（亩）' then
                      r.actual
                   end) as 季同期,
               sum(case
                     when  r.factdate = to_char(sysdate, 'yyyyMM') and
                          r.targetname = '住宅用地合计（亩）' then
                      r.target
                   end) as 当月目标,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyyMM') and
                          r.targetname = '住宅用地合计（亩）' then
                      r.actual
                   end) as 当月实际,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyyMM') and
                          r.targetname = '住宅用地合计（亩）' then
                      r.target_rate
                   end) as 当月完成率,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyyMM') and
                          r.targetname = '住宅用地合计（亩）' then
                      case
                        when r.ytyval is null or r.ytyval = 0 then
                         null
                        else
                         (r.actual / r.ytyval) - 1
                      end
                   end) as 当月同比增长,
               sum(case
                     when r.factdate = to_char(sysdate - 365, 'yyyyMM') and
                          r.targetname = '住宅用地合计（亩）' then
                      r.actual
                   end) as 月同期,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = '住宅用地合计（亩）' then
                      r.estimate_val
                   end) as 当年预估完成,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = '住宅用地合计（亩）' then
                      r.estimate_rate
                   end) as 当年预估完成率,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = '住宅用地合计（亩）' then
                      r.predictdifference
                   end) as 当年差异,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = '住宅用地合计（亩）' then
                      r.yeartoyeaar_val
                   end) as 上年同期,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = '住宅用地合计（亩）' then
                      r.reasondifference
                   end) as 差异原因
        
          from dm_mcl_resarea r
         where r.factdate like to_char(sysdate, 'yyyy') || '%'
            or r.factdate like to_char(sysdate - 365, 'yyyy') || '%'
         group by r.orgid,r.orgname
         ) res
