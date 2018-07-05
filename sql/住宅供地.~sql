select * from (
 select r.orgid, 
       case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = '住宅用地合计（亩）' then
          r.target
       end 当年目标,
       case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = '住宅用地合计（亩）' then
          r.actual
       end 当年实际,
       case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = '住宅用地合计（亩）' then
          r.target_rate
       end 当年完成率,
       case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = '住宅用地合计（亩）' then
          case
            when r.ytyval is null or r.ytyval = 0 then
             null
            else
             (r.actual / r.ytyval) - 1
          end
       end 当年同比增长,
       case
         when r.factdate = to_char(sysdate - 365, 'yyyy') and
              r.targetname = '住宅用地合计（亩）' then
          r.actual
       end 年同期,
       case
         when r.factdate =
              to_char(sysdate, 'yyyy') || 'Q' || to_char(sysdate, 'Q') and
              r.targetname = '住宅用地合计（亩）' then
          r.target
       end 当季目标,
       case
         when r.factdate =
              to_char(sysdate, 'yyyy') || 'Q' || to_char(sysdate, 'Q') and
              r.targetname = '住宅用地合计（亩）' then
          r.actual
       end 当季实际,
       case
         when r.factdate =
              to_char(sysdate, 'yyyy') || 'Q' || to_char(sysdate, 'Q') and
              r.targetname = '住宅用地合计（亩）' then
          r.target_rate
       end 当季完成率,
       case
         when r.factdate =
              to_char(sysdate, 'yyyy') || 'Q' || to_char(sysdate, 'Q') and
              r.targetname = '住宅用地合计（亩）' then
          case
            when r.ytyval is null or r.ytyval = 0 then
             null
            else
             (r.actual / r.ytyval) - 1
          end
       end 当季同比增长,
       case
         when r.factdate =
              to_char(sysdate - 365, 'yyyy') || 'Q' || to_char(sysdate, 'Q') and
              r.targetname = '住宅用地合计（亩）' then
          r.actual
       end 季同期,
       case
         when r.factdate = to_char(sysdate, 'yyyyMM') and
              r.targetname = '住宅用地合计（亩）' then
          r.target
       end 当月目标,
       case
         when r.factdate = to_char(sysdate, 'yyyyMM') and
              r.targetname = '住宅用地合计（亩）' then
          r.actual
       end 当月实际,
       case
         when r.factdate = to_char(sysdate, 'yyyyMM') and
              r.targetname = '住宅用地合计（亩）' then
          r.target_rate
       end 当月完成率,
       case
         when r.factdate = to_char(sysdate, 'yyyyMM') and
              r.targetname = '住宅用地合计（亩）' then
          case
            when r.ytyval is null or r.ytyval = 0 then
             null
            else
             (r.actual / r.ytyval) - 1
          end
       end 当月同比增长,
       case
         when r.factdate = to_char(sysdate - 365, 'yyyyMM') and
              r.targetname = '住宅用地合计（亩）' then
          r.actual
       end 月同期,
              case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = '住宅用地合计（亩）' then
          r.estimate_val
       end 当年预估完成,
            case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = '住宅用地合计（亩）' then
          r.estimate_rate
       end 当年预估完成率,
        case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = '住宅用地合计（亩）' then
          r.predictdifference
       end 当年差异,
        case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = '住宅用地合计（亩）' then
          r.yeartoyeaar_val
       end 上年同期,
        case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = '住宅用地合计（亩）' then
          r.reasondifference
       end 差异原因

  from dm_mcl_resarea r
 where r.factdate like to_char(sysdate, 'yyyy') || '%'
    or r.factdate like to_char(sysdate - 365, 'yyyy') || '%'
)res 
