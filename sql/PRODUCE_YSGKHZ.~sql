CREATE OR REPLACE PROCEDURE PROC_ODM_HR_YSGKHZ IS

BEGIN

  EXECUTE IMMEDIATE 'TRUNCATE TABLE ODM_HR_YSGKHZ';

  INSERT INTO ODM_HR_YSGKHZ
  
    WITH
    
    RS AS
     (SELECT UNIT_ID || DEPARTMENT AS ORG_ID,
             TO_CHAR(DATE_FLOW, 'YYYY') AS YEARS,
             'Q' || TO_CHAR(DATE_FLOW, 'Q') AS QUARTER,
             SUM(CASE
                   WHEN T.DITCH = '57' THEN
                    1
                   ELSE
                    0
                 END) AS LTS,
             SUM(CASE
                   WHEN T.DITCH IN ('54', '55') THEN
                    1
                   ELSE
                    0
                 END) AS NTS,
             SUM(1) ALLNUMBER
        FROM ODS_HR_CANDIDATO_S T
       WHERE T.STATUS_FLOW = '090'
       GROUP BY UNIT_ID || DEPARTMENT,
                TO_CHAR(DATE_FLOW, 'YYYY'),
                TO_CHAR(DATE_FLOW, 'Q')),
    
    LTF AS
     (SELECT UNIT_ID || DEPARTMENT AS ORG_ID,
             TO_CHAR(DATE_FLOW_N, 'YYYY') AS YEARS,
             'Q' || TO_CHAR(DATE_FLOW_N, 'Q') AS QUARTER,
             SUM(NVL(COST_HEADHUNTER, 0)) LTF,
             SUM(NVL(COST_HEADHUNTER, 0) + NVL(COST_INTERPOLATION, 0) +
                 NVL(BACK_TONE, 0) + NVL(PHYSICAL_EXAMINATION, 0) +
                 NVL(TRAVEL, 0)) ALLAMOUNT
      
        FROM ODS_HR_CANDIDATO_COST
       GROUP BY UNIT_ID || DEPARTMENT,
                TO_CHAR(DATE_FLOW_N, 'YYYY'),
                TO_CHAR(DATE_FLOW_N, 'Q')),
    YS AS
     (SELECT Y.TREE_NODE ORG_ID,
             Y.YEARS,
             Y.QUARTER,
             NVL(TO_NUMBER(Y.YSGL), 0) AS YSGL
        FROM ODS_HR_ZP_YSSC Y),
    RESULTS AS
     (SELECT NVL(A.ORG_ID, NVL(B.ORG_ID, C.ORG_ID)) ORG_ID,
             NVL(A.YEARS, NVL(B.YEARS, C.YEARS)) YEARS,
             NVL(A.QUARTER, NVL(B.QUARTER, C.QUARTER)) QUARTER,
             A.LTS,
             A.NTS,
             A.ALLNUMBER,
             B.LTF,
             B.ALLAMOUNT,
             C.YSGL
        FROM RS A
        LEFT JOIN LTF B
          ON A.ORG_ID = B.ORG_ID
         AND A.YEARS = B.YEARS
         AND A.QUARTER = B.QUARTER
        LEFT JOIN YS C
          ON C.ORG_ID = B.ORG_ID
         AND C.YEARS = B.YEARS
         AND C.QUARTER = B.QUARTER),
    LV5 AS
     (SELECT O.ORG_ID,
             RESULTS.YEARS,
             RESULTS.QUARTER,
             RESULTS.LTS,
             RESULTS.NTS,
             RESULTS.ALLNUMBER,
             RESULTS.LTF,
             RESULTS.ALLAMOUNT,
             RESULTS.YSGL
        FROM RESULTS
       INNER JOIN DIM_ORG O
          ON RESULTS.ORG_ID = O.ORG_ID
         AND O.ORG_ID5 IS NOT NULL),
    LV4 AS
     (SELECT RES.ORG_ID,
             RES.YEARS,
             RES.QUARTER,
             SUM(RES.LTS) LTS,
             SUM(RES.NTS) NTS,
             SUM(RES.ALLNUMBER) ALLNUMBER,
             SUM(RES.LTF) LTF,
             SUM(RES.ALLAMOUNT) ALLAMOUNT,
             SUM(RES.YSGL) YSGL
        FROM (SELECT O.ORG_ID,
                     RESULTS.YEARS,
                     RESULTS.QUARTER,
                     RESULTS.LTS,
                     RESULTS.NTS,
                     RESULTS.ALLNUMBER,
                     RESULTS.LTF,
                     RESULTS.ALLAMOUNT,
                     RESULTS.YSGL
                FROM RESULTS
               INNER JOIN DIM_ORG O
                  ON RESULTS.ORG_ID = O.ORG_ID
                 AND O.ORG_ID4 IS NOT NULL
                 AND O.ORG_ID5 IS NULL
              UNION ALL
              SELECT O.ORG_PID ORG_ID,
                     S.YEARS,
                     S.QUARTER,
                     S.LTS,
                     S.NTS,
                     S.ALLNUMBER,
                     S.LTF,
                     S.ALLAMOUNT,
                     S.YSGL
                FROM LV5 S
                LEFT JOIN DIM_ORG O
                  ON O.ORG_ID = S.ORG_ID) RES
       GROUP BY RES.ORG_ID, RES.YEARS, RES.QUARTER),
    LV3 AS
     (SELECT RES.ORG_ID,
             RES.YEARS,
             RES.QUARTER,
             SUM(RES.LTS) LTS,
             SUM(RES.NTS) NTS,
             SUM(RES.ALLNUMBER) ALLNUMBER,
             SUM(RES.LTF) LTF,
             SUM(RES.ALLAMOUNT) ALLAMOUNT,
             SUM(RES.YSGL) YSGL
        FROM (SELECT O.ORG_ID,
                     RESULTS.YEARS,
                     RESULTS.QUARTER,
                     RESULTS.LTS,
                     RESULTS.NTS,
                     RESULTS.ALLNUMBER,
                     RESULTS.LTF,
                     RESULTS.ALLAMOUNT,
                     RESULTS.YSGL
                FROM RESULTS
               INNER JOIN DIM_ORG O
                  ON RESULTS.ORG_ID = O.ORG_ID
                 AND O.ORG_ID3 IS NOT NULL
                 AND O.ORG_ID4 IS NULL
              UNION ALL
              SELECT O.ORG_PID ORG_ID,
                     S.YEARS,
                     S.QUARTER,
                     S.LTS,
                     S.NTS,
                     S.ALLNUMBER,
                     S.LTF,
                     S.ALLAMOUNT,
                     S.YSGL
                FROM LV4 S
                LEFT JOIN DIM_ORG O
                  ON O.ORG_ID = S.ORG_ID) RES
       GROUP BY RES.ORG_ID, RES.YEARS, RES.QUARTER),
    LV2 AS
     (SELECT RES.ORG_ID,
             RES.YEARS,
             RES.QUARTER,
             SUM(RES.LTS) LTS,
             SUM(RES.NTS) NTS,
             SUM(RES.ALLNUMBER) ALLNUMBER,
             SUM(RES.LTF) LTF,
             SUM(RES.ALLAMOUNT) ALLAMOUNT,
             SUM(RES.YSGL) YSGL
        FROM (SELECT O.ORG_ID,
                     RESULTS.YEARS,
                     RESULTS.QUARTER,
                     RESULTS.LTS,
                     RESULTS.NTS,
                     RESULTS.ALLNUMBER,
                     RESULTS.LTF,
                     RESULTS.ALLAMOUNT,
                     RESULTS.YSGL
                FROM RESULTS
               INNER JOIN DIM_ORG O
                  ON RESULTS.ORG_ID = O.ORG_ID
                 AND O.ORG_ID2 IS NOT NULL
                 AND O.ORG_ID3 IS NULL
              UNION ALL
              SELECT O.ORG_PID ORG_ID,
                     S.YEARS,
                     S.QUARTER,
                     S.LTS,
                     S.NTS,
                     S.ALLNUMBER,
                     S.LTF,
                     S.ALLAMOUNT,
                     S.YSGL
                FROM LV3 S
                LEFT JOIN DIM_ORG O
                  ON O.ORG_ID = S.ORG_ID) RES
       GROUP BY RES.ORG_ID, RES.YEARS, RES.QUARTER),
    LV1 AS
     (SELECT RES.ORG_ID,
             RES.YEARS,
             RES.QUARTER,
             SUM(RES.LTS) LTS,
             SUM(RES.NTS) NTS,
             SUM(RES.ALLNUMBER) ALLNUMBER,
             SUM(RES.LTF) LTF,
             SUM(RES.ALLAMOUNT) ALLAMOUNT,
             SUM(RES.YSGL) YSGL
        FROM (SELECT O.ORG_ID,
                     RESULTS.YEARS,
                     RESULTS.QUARTER,
                     RESULTS.LTS,
                     RESULTS.NTS,
                     RESULTS.ALLNUMBER,
                     RESULTS.LTF,
                     RESULTS.ALLAMOUNT,
                     RESULTS.YSGL
                FROM RESULTS
               INNER JOIN DIM_ORG O
                  ON RESULTS.ORG_ID = O.ORG_ID
                 AND O.ORG_ID1 IS NOT NULL
                 AND O.ORG_ID2 IS NULL
              UNION ALL
              SELECT O.ORG_PID ORG_ID,
                     S.YEARS,
                     S.QUARTER,
                     S.LTS,
                     S.NTS,
                     S.ALLNUMBER,
                     S.LTF,
                     S.ALLAMOUNT,
                     S.YSGL
                FROM LV2 S
                LEFT JOIN DIM_ORG O
                  ON O.ORG_ID = S.ORG_ID) RES
       GROUP BY RES.ORG_ID, RES.YEARS, RES.QUARTER),
    
    ZGL AS
     (SELECT O.ORG_ID1,
             O.ORG_NAME1,
             O.ORG_ID2,
             O.ORG_NAME2,
             O.ORG_ID3,
             O.ORG_NAME3,
             O.ORG_ID4,
             O.ORG_NAME4,
             O.ORG_ID5,
             O.ORG_NAME5,
             TO_CHAR(TO_DATE(T.DATA_DATE, 'yyyyMM'), 'yyyy') YEARS,
             'Q' || TO_CHAR(TO_DATE(T.DATA_DATE, 'yyyyMM'), 'Q') QUARTER,
             SUM(GBBZ + YGBZ) AS BZ,
             SUM(GBZG + YGZG) AS ZG,
             CASE
               WHEN SUM(GBBZ + YGBZ) = 0 THEN
                0
               ELSE
                SUM(GBZG + YGZG) / SUM(GBBZ + YGBZ)
             END ZGL,
             O.ORDERS
        FROM ODM_HR_ZP_BZQBL T
        LEFT JOIN DIM_ORG O
          ON NVL(T.ORG_ID1, 'NULL') = NVL(O.ORG_ID1, 'NULL')
         AND NVL(T.ORG_ID2, 'NULL') = NVL(O.ORG_ID2, 'NULL')
         AND NVL(T.ORG_ID3, 'NULL') = NVL(O.ORG_ID3, 'NULL')
         AND NVL(T.ORG_ID4, 'NULL') = NVL(O.ORG_ID4, 'NULL')
         AND NVL(T.ORG_ID5, 'NULL') = NVL(O.ORG_ID5, 'NULL')
         AND T.ORG_ID5 IS NULL
       GROUP BY O.ORG_ID1,
                O.ORG_NAME1,
                O.ORG_ID2,
                O.ORG_NAME2,
                O.ORG_ID3,
                O.ORG_NAME3,
                O.ORG_ID4,
                O.ORG_NAME4,
                O.ORG_ID5,
                O.ORG_NAME5,
                TO_CHAR(TO_DATE(T.DATA_DATE, 'yyyyMM'), 'yyyy'),
                TO_CHAR(TO_DATE(T.DATA_DATE, 'yyyyMM'), 'Q'),
                O.ORDERS
       ORDER BY O.ORDERS),
    
    ALPHA AS
     (SELECT *
        FROM LV1
      UNION ALL
      SELECT *
        FROM LV2
      UNION ALL
      SELECT *
        FROM LV3
      UNION ALL
      SELECT *
        FROM LV4
      UNION ALL
      SELECT *
        FROM LV5),
    BATA AS
     (SELECT *
        FROM (SELECT O.ORG_ID1,
                     O.ORG_NAME1,
                     O.ORG_ID2,
                     O.ORG_NAME2,
                     O.ORG_ID3,
                     O.ORG_NAME3,
                     O.ORG_ID4,
                     O.ORG_NAME4,
                     O.ORG_ID5,
                     O.ORG_NAME5,
                     A.YEARS,
                     A.QUARTER,
                     A.LTS,
                     CASE
                       WHEN A.ALLNUMBER IS NULL OR A.ALLNUMBER = 0 THEN
                        0
                       ELSE
                        A.LTS / A.ALLNUMBER
                     END LTB,
                     A.NTS,
                     CASE
                       WHEN A.ALLNUMBER IS NULL OR A.ALLNUMBER = 0 THEN
                        0
                       ELSE
                        A.NTS / A.ALLNUMBER
                     END NTB,
                     A.ALLNUMBER,
                     A.LTF,
                     A.ALLAMOUNT,
                     A.YSGL,
                     CASE
                       WHEN A.YSGL IS NULL OR A.YSGL = 0 THEN
                        0
                       ELSE
                        A.ALLAMOUNT / A.YSGL
                     END QBV,
                     CASE
                       WHEN SUM(A.YSGL)
                        OVER(PARTITION BY A.YEARS, A.ORG_ID) = 0 THEN
                        0
                       ELSE
                        SUM(A.ALLAMOUNT)
                        OVER(PARTITION BY A.YEARS, A.ORG_ID) / SUM(A.YSGL)
                        OVER(PARTITION BY A.YEARS, A.ORG_ID)
                     END YBV,
                     ZGL.ZGL,
                     SYSDATE AS ETL_TIME,
                     O.ORDERS
                FROM DIM_ORG O
                LEFT JOIN ALPHA A
                  ON O.ORG_ID = A.ORG_ID
                 AND O.ORG_ID5 IS NULL
                LEFT JOIN ZGL
                  ON ZGL.ORG_ID1 = O.ORG_ID1
                 AND ZGL.ORG_ID2 = O.ORG_ID2
                 AND ZGL.ORG_ID3 = O.ORG_ID3
                 AND ZGL.ORG_ID4 = O.ORG_ID4
                 AND ZGL.ORG_ID5 = O.ORG_ID5
                 AND ZGL.YEARS = A.YEARS
                 AND ZGL.QUARTER = A.QUARTER
               ) RES
       ORDER BY RES.ORDERS, RES.YEARS, RES.QUARTER)
    SELECT ORG_ID1,
           ORG_NAME1,
           ORG_ID2,
           ORG_NAME2,
           ORG_ID3,
           ORG_NAME3,
           ORG_ID4,
           ORG_NAME4,
           ORG_ID5,
           ORG_NAME5,
           YEARS     YEAR,
           QUARTER,
           LTB       LTZB,
           LTF,
           YBV       YSZXL_YEAR,
           QBV       YSZXL_QUARTER,
           NTB       NTZB,
           ZGL       BZQBL,
           ETL_TIME,
           ORDERS
      FROM BATA;

  COMMIT;

END;
