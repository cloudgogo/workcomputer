WITH RES AS
 (SELECT *
    FROM (SELECT ND.*,
                 ROW_NUMBER() OVER(PARTITION BY ND.PROJECTGUID ORDER BY ND.NODESORT) NUM
            FROM DM_PROJECT_NODE_DETAIL ND
           WHERE ND.PROJECTGUID NOT IN
                 (SELECT DISTINCT PROJGUID
                    FROM DM_PROJECT_DELAY_DETAIL
                  UNION
                  SELECT DISTINCT PROJGUID
                    FROM DM_PROJECT_NWRISK_DETAIL)
             AND ND.NODETATUS = 'N') RES
   WHERE RES.NUM = 1)

SELECT N.AREANAME,
       N.PROJNAME,
       N.PROJGUID,
       N.INVEST_AMOUNT,
       N.IMAGE,
       N.NODEITEM,
       N.CITYNAME,
       N.DELAYCAUSETYPE,
       N.AREANAME || N.PROJNAME AS AREA_PRO,
       N.PROJECTTYPE,
       N.COMPLETION_PLAN_DATE
  FROM (SELECT N.AREANAME,
               N.PROJNAME,
               N.PROJGUID,
               N.INVEST_AMOUNT,
               N.IMAGE,
               N.NODEITEM,
               N.DELAYCAUSETYPE,
               N.AREAGUID,
               N.CITYNAME,
               N.ENTITYGUID,
               N.PROJECTTYPE,
               N.COMPLETION_PLAN_DATE
          FROM (SELECT *
                  FROM (SELECT N.AREANAME,
                               N.PROJNAME,
                               N.PROJGUID,
                               N.INVEST_AMOUNT,
                               N.IMAGE,
                               N.NODEITEM,
                               N.DELAYCAUSETYPE,
                               N.AREAGUID,
                               N.ENTITYGUID,
                               N.CITYNAME,
                               N.COMPLETION_PLAN_DATE,
                               '已延期' PROJECTTYPE
                          FROM DM_PROJECT_DELAY_DETAIL N
                        UNION ALL
                        SELECT N.AREANAME,
                               N.PROJNAME,
                               N.PROJGUID,
                               N.INVEST_AMOUNT,
                               N.IMAGE,
                               N.NODEITEM,
                               '风险' DELAYCAUSETYPE,
                               N.AREAGUID,
                               N.ENTITYGUID,
                               N.CITYNAME,
                               N.COMPLETION_PLAN_DATE,
                               '风险' PROJECTTYPE
                          FROM DM_PROJECT_NWRISK_DETAIL N
                        UNION ALL
                        SELECT DISTINCT ND.AREANAME,
                                        ND.PROJECTNAME PROJNAME,
                                        ND.PROJECTGUID PROJGUID,
                                        PD.INVEST_AMOUNT,
                                        PD.IMAGE,
                                        ND.NODENAME NODEITEM,
                                        '正常' DELAYCAUSETYPE,
                                        ND.AREAGUID,
                                        ND.ENTITYGUID,
                                        PD.CITYNAME,
                                        ND.COMPLETION_PLAN_NODE,
                                        '正常' PROJECTTYPE
                        
                          FROM DM_PROJECT_PROCEED_DETAIL PD,
                               (SELECT *
                                  FROM RES
                                UNION ALL
                                SELECT *
                                  FROM (SELECT ND.*,
                                               ROW_NUMBER() OVER(PARTITION BY ND.PROJECTGUID ORDER BY ND.NODESORT DESC) NUM
                                          FROM DM_PROJECT_NODE_DETAIL ND
                                         WHERE ND.PROJECTGUID NOT IN
                                               (SELECT DISTINCT PROJGUID
                                                  FROM DM_PROJECT_DELAY_DETAIL
                                                UNION
                                                SELECT DISTINCT PROJGUID
                                                  FROM DM_PROJECT_NWRISK_DETAIL)
                                           AND ND.PROJECTGUID NOT IN
                                               (SELECT RES.PROJECTGUID FROM RES)) RESULT
                                 WHERE RESULT.NUM = 1) ND
                         WHERE PD.PROJGUID = ND.PROJECTGUID) RES
                 WHERE 1 = 1) N) N
  LEFT JOIN (SELECT ORG_ID,
                    CASE
                      WHEN FATHER_ID = 'E0A3D386-D5C8-FB22-18DE-4424D49363B3' THEN
                       'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
                      WHEN ORG_ID = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2' THEN
                       NULL
                      ELSE
                       FATHER_ID
                    END FATHER_ID,
                    ORG_NAME,
                    ORG_SNAME,
                    ORDER_KEY,
                    ORG_CODE
               FROM DIM_ORG
              WHERE ORG_CODE LIKE 'HXCYXC%'
                AND ORG_CODE NOT LIKE 'HXCYXCGJ%'
                AND FATHER_ID != 'E0A3D386-D5C8-FB22-18DE-4424D49363B2') T
    ON (N.ENTITYGUID = T.ORG_ID OR N.AREAGUID = T.ORG_ID)

 WHERE 1 = 1
 ORDER BY AREANAME, PROJNAME
