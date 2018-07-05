select *
  from (select r.orgid,r.orgname,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.target
                   end) as ����Ŀ��,
               
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.actual
                   end) as ����ʵ��,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      (r.target_rate)
                   end) as ���������,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      case
                        when r.ytyval is null or r.ytyval = 0 then
                         null
                        else
                         (r.actual / r.ytyval) - 1
                      end
                   end) as ����ͬ������,
               sum(case
                     when r.factdate = to_char(sysdate - 365, 'yyyy') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.actual
                   end) as ��ͬ��,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') || 'Q' ||
                          to_char(sysdate, 'Q') and r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.target
                   end) as ����Ŀ��,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') || 'Q' ||
                          to_char(sysdate, 'Q') and r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.actual
                   end) as ����ʵ��,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') || 'Q' ||
                          to_char(sysdate, 'Q') and r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.target_rate
                   end) as ���������,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') || 'Q' ||
                          to_char(sysdate, 'Q') and r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      case
                        when r.ytyval is null or r.ytyval = 0 then
                         null
                        else
                         (r.actual / r.ytyval) - 1
                      end
                   end) as ����ͬ������,
               sum(case
                     when r.factdate = to_char(sysdate - 365, 'yyyy') || 'Q' ||
                          to_char(sysdate, 'Q') and r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.actual
                   end) as ��ͬ��,
               sum(case
                     when  r.factdate = to_char(sysdate, 'yyyyMM') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.target
                   end) as ����Ŀ��,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyyMM') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.actual
                   end) as ����ʵ��,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyyMM') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.target_rate
                   end) as ���������,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyyMM') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      case
                        when r.ytyval is null or r.ytyval = 0 then
                         null
                        else
                         (r.actual / r.ytyval) - 1
                      end
                   end) as ����ͬ������,
               sum(case
                     when r.factdate = to_char(sysdate - 365, 'yyyyMM') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.actual
                   end) as ��ͬ��,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.estimate_val
                   end) as ����Ԥ�����,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.estimate_rate
                   end) as ����Ԥ�������,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.predictdifference
                   end) as �������,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.yeartoyeaar_val
                   end) as ����ͬ��,
               sum(case
                     when r.factdate = to_char(sysdate, 'yyyy') and
                          r.targetname = 'סլ�õغϼƣ�Ķ��' then
                      r.reasondifference
                   end) as ����ԭ��
        
          from dm_mcl_resarea r
         where r.factdate like to_char(sysdate, 'yyyy') || '%'
            or r.factdate like to_char(sysdate - 365, 'yyyy') || '%'
         group by r.orgid,r.orgname
         ) res
