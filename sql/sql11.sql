SELECT DISTINCT * 
  FROM (
        SELECT A.ORG_ID,--机构ID
               A.ORG_NAME,--机构名称
               A.ORG_SNAME,--机构简称
               A.ORG_LEVEL,--机构层级
               A.ORDER_KEY,--排序？
               A.ORG_CODE,--？？？
               A.TARGETID,--指标ID
               A.NAME,--指标名称
               A.UNIT,--单位
               A.LEVELID,--指标层级
               
               SUM(NVL(TARGET_YEAR,0)) TARGET_YEAR,--年度目标值
               SUM(NVL(ACTUAL_YEAR,0)) ACTUAL_YEAR,--本年实际
               SUM(NVL(ACTUAL_LYEAR,0)) ACTUAL_LYEAR,--去年同期实际
               SUM(NVL(TARGET_QUARTER,0)) TARGET_QUARTER,--季度目标值
               SUM(NVL(ACTUAL_QUARTER,0)) ACTUAL_QUARTER,--季度实际
               SUM(NVL(ACTUAL_LQUARTER,0)) ACTUAL_LQUARTER,--去年本季同期
               SUM(NVL(TARGET_MONTH,0)) TARGET_MONTH,--月度目标
               SUM(NVL(ACTUAL_MONTH,0)) ACTUAL_MONTH,--本月实际
               SUM(NVL(ACTUAL_LMONTH,0)) ACTUAL_LMONTH,--去年同期
               SUM(NVL(ACTUAL_YG,0)) ACTUAL_YG,--预估
               SUM(NVL(RATE_YG,0)) RATE_YG,--预估完成率
               SUM(NVL(ACTUAL_YGCY,0)) ACTUAL_YGCY, --差异            
               SUM(NVL(RATE_TB,0)) RATE_TB--预估同比
          FROM (
                SELECT A.ORG_ID,
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
                 INNER JOIN BASS_ODS.ODS_MCL_MDMORG B ON A.ORG_ID=B.SOURCEID 
                 INNER JOIN BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP C ON B.ID=C.ORGID
                 INNER JOIN BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D ON C.TARGETGROUPID=D.GROUPID
                ) A 
           LEFT JOIN (--年
                      --目标值
                      SELECT B.SOURCEID,
                             C.TARGETGROUPID,
                             D.TARGETID,
                             D.NAME,
                             D.UNIT,
                             D.LEVELID,
                             
                             A.AMOUNT TARGET_YEAR,
                             0 ACTUAL_YEAR,
                             0 ACTUAL_LYEAR,
                             0 TARGET_QUARTER,
                             0 ACTUAL_QUARTER,
                             0 ACTUAL_LQUARTER,
                             0 TARGET_MONTH,
                             0 ACTUAL_MONTH,
                             0 ACTUAL_LMONTH,
                             0 ACTUAL_YG,
                             0 RATE_YG,
                             0 ACTUAL_YGCY,
                             0 RATE_TB
                        FROM BASS_ODS.ODS_MCL_TARGET A 
                       INNER JOIN BASS_ODS.ODS_MCL_MDMORG B ON A.ORGID=B.ID 
                       INNER JOIN BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP C ON A.ORGID=C.ORGID
                       INNER JOIN BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D ON A.TARGETID=D.TARGETID AND C.TARGETGROUPID=D.GROUPID
                       WHERE FACTDATE=SUBSTR('${time}',1,4)
                       UNION ALL
                       --实际值
                      SELECT B.SOURCEID,
                             C.TARGETGROUPID,
                             D.TARGETID,
                             D.NAME,
                             D.UNIT,
                             D.LEVELID,
                            
                             0 TARGET_YEAR,
                             SUM(NVL(A.Y_P_VALUE,0)) ACTUAL_YEAR,
                             0 ACTUAL_LYEAR,
                             0 TARGET_QUARTER,
                             0 ACTUAL_QUARTER,
                             0 ACTUAL_LQUARTER,
                             0 TARGET_MONTH,
                             0 ACTUAL_MONTH,
                             0 ACTUAL_LMONTH,
                             0 ACTUAL_YG,
                             0 RATE_YG,
                             0 ACTUAL_YGCY,
                             0 RATE_TB
                        FROM BASS_ODS.ODS_MCL_FACTSUM A 
                       INNER JOIN BASS_ODS.ODS_MCL_MDMORG B ON A.ORGID=B.ID 
                       INNER JOIN BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP C ON A.ORGID=C.ORGID
                       INNER JOIN BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D ON A.TARGETID=D.TARGETID 
                                                                           AND C.TARGETGROUPID=D.GROUPID
                       WHERE TO_CHAR(A.FACTDATE,'YYYY') = SUBSTR('${time}',1,4) 
                         AND TO_CHAR(FACTDATE,'YYYYMMDD')<='${time}'  
                       GROUP BY B.SOURCEID,C.TARGETGROUPID,D.TARGETID,D.NAME,D.UNIT,D.LEVELID
                       UNION ALL
                       --同期值
                      SELECT B.SOURCEID,
                             C.TARGETGROUPID,
                             D.TARGETID,
                             D.NAME,
                             D.UNIT,
                             D.LEVELID,
                            
                             0 TARGET_YEAR,
                             0 ACTUAL_YEAR,
                             SUM(NVL(A.Y_P_VALUE,0)) ACTUAL_LYEAR,
                             0 TARGET_QUARTER,
                             0 ACTUAL_QUARTER,
                             0 ACTUAL_LQUARTER,
                             0 TARGET_MONTH,
                             0 ACTUAL_MONTH,
                             0 ACTUAL_LMONTH,
                             0 ACTUAL_YG,
                             0 RATE_YG,
                             0 ACTUAL_YGCY,
                             0 RATE_TB
                        FROM BASS_ODS.ODS_MCL_FACTSUM A 
                       INNER JOIN BASS_ODS.ODS_MCL_MDMORG B ON A.ORGID=B.ID 
                       INNER JOIN BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP C ON A.ORGID=C.ORGID
                       INNER JOIN BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D ON A.TARGETID=D.TARGETID 
                                                                           AND C.TARGETGROUPID=D.GROUPID
                       WHERE TO_CHAR(A.FACTDATE,'YYYY') = TO_CHAR(TO_NUMBER(SUBSTR('${time}',1,4))-1) 
                         AND TO_CHAR(FACTDATE,'YYYYMMDD') <= TO_CHAR(TO_NUMBER(SUBSTR('${time}',1,4))-1)||SUBSTR('${time}',5,4) 
                       GROUP BY B.SOURCEID,C.TARGETGROUPID,D.TARGETID,D.NAME,D.UNIT,D.LEVELID
                       UNION ALL--季
                       --目标值
                      SELECT B.SOURCEID,
                             C.TARGETGROUPID,
                             D.TARGETID,
                             D.NAME,
                             D.UNIT,
                             D.LEVELID,
                             
                             0 TARGET_YEAR,
                             0 ACTUAL_YEAR,
                             0 ACTUAL_LYEAR,
                             A.AMOUNT TARGET_QUARTER,
                             0 ACTUAL_QUARTER,
                             0 ACTUAL_LQUARTER,
                             0 TARGET_MONTH,
                             0 ACTUAL_MONTH,
                             0 ACTUAL_LMONTH,
                             0 ACTUAL_YG,
                             0 RATE_YG,
                             0 ACTUAL_YGCY,
                             0 RATE_TB
                        FROM BASS_ODS.ODS_MCL_TARGET A 
                       INNER JOIN BASS_ODS.ODS_MCL_MDMORG B ON A.ORGID=B.ID 
                       INNER JOIN BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP C ON A.ORGID=C.ORGID
                       INNER JOIN BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D ON A.TARGETID=D.TARGETID 
                                                                           AND C.TARGETGROUPID=D.GROUPID
                       WHERE FACTDATE = SUBSTR('${time}',1,4)||'Q'||TO_CHAR(TO_DATE('${time}','YYYYMMDD'),'Q')
                       UNION ALL
                       --实际值
                      SELECT B.SOURCEID,
                             C.TARGETGROUPID,
                             D.TARGETID,
                             D.NAME,
                             D.UNIT,
                             D.LEVELID,
                             
                             0 TARGET_YEAR,
                             0 ACTUAL_YEAR,
                             0 ACTUAL_LYEAR,
                             0 TARGET_QUARTER,
                             SUM(NVL(A.Y_P_VALUE,0)) ACTUAL_QUARTER,
                             0 ACTUAL_LQUARTER,
                             0 TARGET_MONTH,
                             0 ACTUAL_MONTH,
                             0 ACTUAL_LMONTH,
                             0 ACTUAL_YG,
                             0 RATE_YG,
                             0 ACTUAL_YGCY,
                             0 RATE_TB
                        FROM BASS_ODS.ODS_MCL_FACTSUM A 
                       INNER JOIN BASS_ODS.ODS_MCL_MDMORG B ON A.ORGID=B.ID 
                       INNER JOIN BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP C ON A.ORGID=C.ORGID
                       INNER JOIN BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D ON A.TARGETID=D.TARGETID 
                                                                           AND C.TARGETGROUPID=D.GROUPID
                       WHERE TO_CHAR(A.FACTDATE,'YYYY')||'Q'||TO_CHAR(A.FACTDATE,'Q')=SUBSTR('${time}',1,4)||'Q'||TO_CHAR(TO_DATE('${time}','YYYYMMDD'),'Q') 
                         --AND TO_CHAR(FACTDATE,'YYYYMMDD')<='${time}'  
                       GROUP BY B.SOURCEID,C.TARGETGROUPID,D.TARGETID,D.NAME,D.UNIT,D.LEVELID
                       UNION ALL
                       --同期值
                      SELECT B.SOURCEID,
                             C.TARGETGROUPID,
                             D.TARGETID,
                             D.NAME,
                             D.UNIT,
                             D.LEVELID,
                            
                             0 TARGET_YEAR,
                             0 ACTUAL_YEAR,
                             0 ACTUAL_LYEAR,
                             0 TARGET_QUARTER,
                             0 ACTUAL_QUARTER,
                             SUM(NVL(A.Y_P_VALUE,0)) ACTUAL_LQUARTER,
                             0 TARGET_MONTH,
                             0 ACTUAL_MONTH,
                             0 ACTUAL_LMONTH,
                             0 ACTUAL_YG,
                             0 RATE_YG,
                             0 ACTUAL_YGCY,
                             0 RATE_TB
                        FROM BASS_ODS.ODS_MCL_FACTSUM A 
                       INNER JOIN BASS_ODS.ODS_MCL_MDMORG B ON A.ORGID=B.ID 
                       INNER JOIN BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP C ON A.ORGID=C.ORGID
                       INNER JOIN BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D ON A.TARGETID=D.TARGETID 
                                                                           AND C.TARGETGROUPID=D.GROUPID
                       WHERE TO_CHAR(A.FACTDATE,'YYYY')||'Q'||TO_CHAR(A.FACTDATE,'Q')=TO_CHAR(TO_NUMBER(SUBSTR('${time}',1,4))-1)||'Q'||TO_CHAR(TO_DATE('${time}','YYYYMMDD'),'Q') 
                         --AND TO_CHAR(FACTDATE,'YYYYMMDD')<=TO_CHAR(TO_NUMBER(SUBSTR('${time}',1,4))-1)||SUBSTR('${time}',5,4) 
                       GROUP BY B.SOURCEID,C.TARGETGROUPID,D.TARGETID,D.NAME,D.UNIT,D.LEVELID
                       UNION ALL--月
                       --目标值
                      SELECT B.SOURCEID,
                             C.TARGETGROUPID,
                             D.TARGETID,
                             D.NAME,
                             D.UNIT,
                             D.LEVELID,
                             
                             0 TARGET_YEAR,
                             0 ACTUAL_YEAR,
                             0 ACTUAL_LYEAR,
                             0 TARGET_QUARTER,
                             0 ACTUAL_QUARTER,
                             0 ACTUAL_LQUARTER,
                             A.AMOUNT TARGET_MONTH,
                             0 ACTUAL_MONTH,
                             0 ACTUAL_LMONTH,
                             0 ACTUAL_YG,
                             0 RATE_YG,
                             0 ACTUAL_YGCY,
                             0 RATE_TB
                        FROM BASS_ODS.ODS_MCL_TARGET A 
                       INNER JOIN BASS_ODS.ODS_MCL_MDMORG B ON A.ORGID=B.ID 
                       INNER JOIN BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP C ON A.ORGID=C.ORGID
                       INNER JOIN BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D ON A.TARGETID=D.TARGETID 
                                                                           AND C.TARGETGROUPID=D.GROUPID
                       WHERE FACTDATE=SUBSTR('${time}',1,4)||'M'||TO_CHAR(TO_NUMBER(SUBSTR('${time}',5,2)))
                       UNION ALL
                       --实际值
                       SELECT B.SOURCEID,
                              C.TARGETGROUPID,
                              D.TARGETID,
                              D.NAME,
                              D.UNIT,
                              D.LEVELID,
                              
                              0 TARGET_YEAR,
                              0 ACTUAL_YEAR,
                              0 ACTUAL_LYEAR,
                              0 TARGET_QUARTER,
                              0 ACTUAL_QUARTER,
                              0 ACTUAL_LQUARTER,
                              0 TARGET_MONTH,
                              SUM(NVL(A.Y_P_VALUE,0)) ACTUAL_MONTH,
                              0 ACTUAL_LMONTH,
                              0 ACTUAL_YG,
                              0 RATE_YG,
                              0 ACTUAL_YGCY,
                              0 RATE_TB
                         FROM BASS_ODS.ODS_MCL_FACTSUM A 
                        INNER JOIN BASS_ODS.ODS_MCL_MDMORG B ON A.ORGID=B.ID 
                        INNER JOIN BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP C ON A.ORGID=C.ORGID
                        INNER JOIN BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D ON A.TARGETID=D.TARGETID 
                                                                            AND C.TARGETGROUPID=D.GROUPID
                        WHERE TO_CHAR(A.FACTDATE,'YYYYMM')=SUBSTR('${time}',1,6) 
                          AND TO_CHAR(FACTDATE,'YYYYMMDD')<='${time}'  
                        GROUP BY B.SOURCEID,C.TARGETGROUPID,D.TARGETID,D.NAME,D.UNIT,D.LEVELID
                        UNION ALL
                        --同期值
                       SELECT B.SOURCEID,
                              C.TARGETGROUPID,
                              D.TARGETID,
                              D.NAME,
                              D.UNIT,
                              D.LEVELID,
                             
                              0 TARGET_YEAR,
                              0 ACTUAL_YEAR,
                              0 ACTUAL_LYEAR,
                              0 TARGET_QUARTER,
                              0 ACTUAL_QUARTER,
                              0 ACTUAL_LQUARTER,
                              0 TARGET_MONTH,
                              0 ACTUAL_MONTH,
                              SUM(NVL(A.Y_P_VALUE,0)) ACTUAL_LMONTH,
                              0 ACTUAL_YG,
                              0 RATE_YG,
                              0 ACTUAL_YGCY,
                              0 RATE_TB
                         FROM BASS_ODS.ODS_MCL_FACTSUM A 
                        INNER JOIN BASS_ODS.ODS_MCL_MDMORG B ON A.ORGID=B.ID 
                        INNER JOIN BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP C ON A.ORGID=C.ORGID
                        INNER JOIN BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D ON A.TARGETID=D.TARGETID 
                                                                            AND C.TARGETGROUPID=D.GROUPID
                        WHERE TO_CHAR(A.FACTDATE,'YYYYMM')=TO_CHAR(TO_NUMBER(SUBSTR('${time}',1,4))-1)||SUBSTR('${time}',5,2)  
                          AND TO_CHAR(FACTDATE,'YYYYMMDD')<=TO_CHAR(TO_NUMBER(SUBSTR('${time}',1,4))-1)||SUBSTR('${time}',5,4) 
                        GROUP BY B.SOURCEID,C.TARGETGROUPID,D.TARGETID,D.NAME,D.UNIT,D.LEVELID
                        UNION ALL--预估
                       SELECT B.SOURCEID,
                              C.TARGETGROUPID,
                              D.TARGETID,
                              D.NAME,
                              D.UNIT,
                              D.LEVELID,

                              0 TARGET_YEAR,
                              0 ACTUAL_YEAR,
                              0 ACTUAL_LYEAR,
                              0 TARGET_QUARTER,
                              0 ACTUAL_QUARTER,
                              0 ACTUAL_LQUARTER,
                              0 TARGET_MONTH,
                              0 ACTUAL_MONTH,
                              0 ACTUAL_LMONTH,
                              AMOUNT ACTUAL_YG,
                              COMPLETIONRATE RATE_YG,
                              PREDICTDIFFERENCE ACTUAL_YGCY,
                              YEARONYEARGROWTH RATE_TB
                         FROM BASS_ODS.ODS_MCL_PREDICT A 
                        INNER JOIN BASS_ODS.ODS_MCL_MDMORG B ON A.ORGID=B.ID 
                        INNER JOIN BASS_ODS.ODS_FACT_JYFX_ORGTARGETGROUP C ON A.ORGID=C.ORGID
                        INNER JOIN BASS_ODS.ODS_TOBUSINESSGROUPDETAIL_JYFX D ON A.TARGETID=D.TARGETID 
                                                                            AND C.TARGETGROUPID=D.GROUPID
                        WHERE FACTDATE=SUBSTR('${time}',1,4)||'Q'||TO_CHAR(TO_DATE('${time}','YYYYMMDD'),'Q')
                ) B ON A.ORG_ID=B.SOURCEID 
                   AND A.TARGETID=B.TARGETID

                 GROUP BY A.ORG_ID,A.ORG_NAME,A.ORG_SNAME,A.ORG_LEVEL,A.ORDER_KEY,A.ORG_CODE,A.TARGETID,A.NAME,A.UNIT,A.LEVELID
          ) A
     LEFT JOIN BASS_ODS.MV_DIM_INDICATOR B ON A.TARGETID=B.INDICATOR_ID
     where indicator_type = 'QY'
    ORDER BY ORDER_KEY,LEVELID
