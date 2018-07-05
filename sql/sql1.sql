SELECT DISTINCT *
  FROM (SELECT A.ORG_ID, --机构ID
               A.ORG_NAME, --机构名称
               A.ORG_SNAME, --机构简称
               A.ORG_LEVEL, --机构层级
               A.ORDER_KEY, --排序？
               A.ORG_CODE, --？？？
               A.TARGETID, --指标ID
               A.NAME, --指标名称
               A.UNIT, --单位
               A.LEVELID, --指标层级
               
               SUM(NVL(TARGET_YEAR, 0)) TARGET_YEAR, --年度目标值
               SUM(NVL(ACTUAL_YEAR, 0)) ACTUAL_YEAR, --本年实际
               SUM(NVL(ACTUAL_LYEAR, 0)) ACTUAL_LYEAR, --去年同期实际
               SUM(NVL(TARGET_QUARTER, 0)) TARGET_QUARTER, --季度目标值
               SUM(NVL(ACTUAL_QUARTER, 0)) ACTUAL_QUARTER, --季度实际
               SUM(NVL(ACTUAL_LQUARTER, 0)) ACTUAL_LQUARTER, --去年本季同期
               SUM(NVL(TARGET_MONTH, 0)) TARGET_MONTH, --月度目标
               SUM(NVL(ACTUAL_MONTH, 0)) ACTUAL_MONTH, --本月实际
               SUM(NVL(ACTUAL_LMONTH, 0)) ACTUAL_LMONTH, --去年同期
               SUM(NVL(ACTUAL_YG, 0)) ACTUAL_YG, --预估
               SUM(NVL(RATE_YG, 0)) RATE_YG, --预估完成率
               SUM(NVL(ACTUAL_YGCY, 0)) ACTUAL_YGCY, --差异            
               SUM(NVL(RATE_TB, 0)) RATE_TB --预估同比
          FROM (SELECT A.ORG_ID,
                       A.ORG_NAME,
                       A.ORG_SNAME,
                       A.ORG_LEVEL,
                       A.ORDER_KEY,
                       A.ORG_CODE,
                       D.TARGETID,
                       D.NAME,
                       D.UNIT,
                       D.LEVELID
                
                  FROM DIM_ORG A
                 INNER JOIN BASS_ODS.ODS_MCL_MDMORG B
                    ON A.ORG_ID = B.SOURCEID
                 INNER JOIN BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP C
                    ON B.ID = C.ORGID
                 INNER JOIN BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D
                    ON C.TARGETGROUPID = D.GROUPID) A
          LEFT JOIN (
                    
                    select B.SOURCEID,
                            C.TARGETGROUPID,
                            D.TARGETID,
                            D.NAME,
                            D.UNIT,
                            D.LEVELID,
                            0 TARGET_YEAR,
                            case to_char(a.factdate, 'yyyy')
                              when to_char(sysdate, 'yyyy') then
                               A.Y_P_VALUE
                            end ACTUAL_YEAR,
                            case to_char(a.factdate, 'yyyy')
                              when to_char(sysdate - 365, 'yyyy') then
                               A.Y_P_VALUE
                            end ACTUAL_LYEAR,
                            0 TARGET_QUARTER,
                            case to_char(a.factdate, 'yyyy') || 'Q' ||
                             to_char(a.factdate, 'Q')
                              when to_char(sysdate, 'yyyy') || 'Q' ||
                               to_char(sysdate, 'Q') then
                               A.Y_P_VALUE
                            end ACTUAL_QUARTER,
                            
                            case to_char(a.factdate, 'yyyy') || 'Q' ||
                             to_char(a.factdate, 'Q')
                              when to_char(sysdate - 365, 'yyyy') || 'Q' ||
                               to_char(sysdate, 'Q') then
                               A.Y_P_VALUE
                            end ACTUAL_LQUARTER,
                            0 TARGET_MONTH,
                            case to_char(a.factdate, 'yyyy') || 'M' ||
                             ltrim(to_char(a.factdate, 'MM'), '0')
                              when to_char(sysdate, 'yyyy') || 'M' ||
                               ltrim(to_char(sysdate, 'MM'), '0') then
                               A.Y_P_VALUE
                            end ACTUAL_MONTH,
                            case to_char(a.factdate, 'yyyy') || 'M' ||
                             ltrim(to_char(a.factdate, 'MM'), '0')
                              when to_char(sysdate - 365, 'yyyy') || 'M' ||
                               ltrim(to_char(sysdate, 'MM'), '0') then
                               A.Y_P_VALUE
                            end ACTUAL_LMONTH,
                            0 ACTUAL_YG,
                            0 RATE_YG,
                            0 ACTUAL_YGCY,
                            0 RATE_TB
                      from BASS_ODS.ODS_MCL_FACTSUM                A,
                            BASS_ODS.ODS_MCL_MDMORG                 B,
                            BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP   C,
                            BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D
                     where A.ORGID = B.ID
                       and A.TARGETID = D.TARGETID
                       AND C.TARGETGROUPID = D.GROUPID
                       and (to_char(a.factdate, 'yyyy') =
                           to_char(sysdate, 'yyyy') or
                           to_char(a.factdate, 'yyyy') =
                           to_char(sysdate - 1, 'yyyy'))
                    union all
                    select B.SOURCEID,
                            C.TARGETGROUPID,
                            D.TARGETID,
                            D.NAME,
                            D.UNIT,
                            D.LEVELID,
                            
                            case a.factdate
                              when to_char(sysdate, 'yyyy') then
                               A.AMOUNT
                            end TARGET_YEAR,
                            0 ACTUAL_YEAR,
                            0 ACTUAL_LYEAR,
                            case a.factdate
                              when to_char(sysdate, 'yyyy') || 'Q' ||
                               to_char(sysdate, 'Q') then
                               A.AMOUNT
                            end TARGET_QUARTER,
                            0 ACTUAL_QUARTER,
                            0 ACTUAL_LQUARTER,
                            case a.factdate
                              when to_char(sysdate, 'yyyy') || 'M' ||
                               ltrim(to_char(sysdate, 'MM'), '0') then
                               A.AMOUNT
                            end TARGET_MONTH,
                            0 ACTUAL_MONTH,
                            0 ACTUAL_LMONTH,
                            0 ACTUAL_YG,
                            0 RATE_YG,
                            0 ACTUAL_YGCY,
                            0 RATE_TB
                    
                      from BASS_ODS.ODS_MCL_TARGET                 A,
                            BASS_ODS.ODS_MCL_MDMORG                 B,
                            BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP   C,
                            BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D
                     where A.ORGID = B.ID
                       and A.TARGETID = D.TARGETID
                       AND C.TARGETGROUPID = D.GROUPID
                       and a.factdate in
                           (to_char(sysdate, 'yyyy'),
                            to_char(sysdate, 'yyyy') || 'Q' ||
                            to_char(sysdate, 'Q'),
                            to_char(sysdate, 'yyyy') || 'M' ||
                            ltrim(to_char(sysdate, 'MM'), '0'))
                    
                    union all
                    SELECT B.SOURCEID,
                            C.TARGETGROUPID,
                            D.TARGETID,
                            D.NAME,
                            D.UNIT,
                            D.LEVELID,
                            
                            0                 TARGET_YEAR,
                            0                 ACTUAL_YEAR,
                            0                 ACTUAL_LYEAR,
                            0                 TARGET_QUARTER,
                            0                 ACTUAL_QUARTER,
                            0                 ACTUAL_LQUARTER,
                            0                 TARGET_MONTH,
                            0                 ACTUAL_MONTH,
                            0                 ACTUAL_LMONTH,
                            AMOUNT            ACTUAL_YG,
                            COMPLETIONRATE    RATE_YG,
                            PREDICTDIFFERENCE ACTUAL_YGCY,
                            YEARONYEARGROWTH  RATE_TB
                      FROM BASS_ODS.ODS_MCL_PREDICT A
                     INNER JOIN BASS_ODS.ODS_MCL_MDMORG B
                        ON A.ORGID = B.ID
                     INNER JOIN BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP C
                        ON A.ORGID = C.ORGID
                     INNER JOIN BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D
                        ON A.TARGETID = D.TARGETID
                       AND C.TARGETGROUPID = D.GROUPID
                     WHERE FACTDATE = to_char(sysdate, 'yyyy') || 'Q' ||
                           to_char(sysdate, 'Q')
                    
                    ) B
            ON A.ORG_ID = B.SOURCEID
           AND A.TARGETID = B.TARGETID
        
         GROUP BY A.ORG_ID,
                  A.ORG_NAME,
                  A.ORG_SNAME,
                  A.ORG_LEVEL,
                  A.ORDER_KEY,
                  A.ORG_CODE,
                  A.TARGETID,
                  A.NAME,
                  A.UNIT,
                  A.LEVELID) A
  LEFT JOIN BASS_ODS.MV_DIM_INDICATOR B
    ON A.TARGETID = B.INDICATOR_ID
 where indicator_type = 'QY'
 ORDER BY ORDER_KEY, LEVELID
