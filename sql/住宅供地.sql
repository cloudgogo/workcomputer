select * from (
 select r.orgid, 
       case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.target
       end ����Ŀ��,
       case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.actual
       end ����ʵ��,
       case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.target_rate
       end ���������,
       case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          case
            when r.ytyval is null or r.ytyval = 0 then
             null
            else
             (r.actual / r.ytyval) - 1
          end
       end ����ͬ������,
       case
         when r.factdate = to_char(sysdate - 365, 'yyyy') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.actual
       end ��ͬ��,
       case
         when r.factdate =
              to_char(sysdate, 'yyyy') || 'Q' || to_char(sysdate, 'Q') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.target
       end ����Ŀ��,
       case
         when r.factdate =
              to_char(sysdate, 'yyyy') || 'Q' || to_char(sysdate, 'Q') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.actual
       end ����ʵ��,
       case
         when r.factdate =
              to_char(sysdate, 'yyyy') || 'Q' || to_char(sysdate, 'Q') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.target_rate
       end ���������,
       case
         when r.factdate =
              to_char(sysdate, 'yyyy') || 'Q' || to_char(sysdate, 'Q') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          case
            when r.ytyval is null or r.ytyval = 0 then
             null
            else
             (r.actual / r.ytyval) - 1
          end
       end ����ͬ������,
       case
         when r.factdate =
              to_char(sysdate - 365, 'yyyy') || 'Q' || to_char(sysdate, 'Q') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.actual
       end ��ͬ��,
       case
         when r.factdate = to_char(sysdate, 'yyyyMM') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.target
       end ����Ŀ��,
       case
         when r.factdate = to_char(sysdate, 'yyyyMM') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.actual
       end ����ʵ��,
       case
         when r.factdate = to_char(sysdate, 'yyyyMM') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.target_rate
       end ���������,
       case
         when r.factdate = to_char(sysdate, 'yyyyMM') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          case
            when r.ytyval is null or r.ytyval = 0 then
             null
            else
             (r.actual / r.ytyval) - 1
          end
       end ����ͬ������,
       case
         when r.factdate = to_char(sysdate - 365, 'yyyyMM') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.actual
       end ��ͬ��,
              case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.estimate_val
       end ����Ԥ�����,
            case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.estimate_rate
       end ����Ԥ�������,
        case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.predictdifference
       end �������,
        case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.yeartoyeaar_val
       end ����ͬ��,
        case
         when r.factdate = to_char(sysdate, 'yyyy') and
              r.targetname = 'סլ�õغϼƣ�Ķ��' then
          r.reasondifference
       end ����ԭ��

  from dm_mcl_resarea r
 where r.factdate like to_char(sysdate, 'yyyy') || '%'
    or r.factdate like to_char(sysdate - 365, 'yyyy') || '%'
)res 
