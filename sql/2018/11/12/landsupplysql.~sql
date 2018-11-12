WITH ORG_RS AS
 (SELECT ORG_ID,
         PARENTID      AS FATHER_ID,
         ORG_NAME,
         ORG_SHORTNAME AS ORG_SNAME,
         ORG_NUM       AS ORDER_KEY,
         ORG_LEVEL,
         ORG_TYPE,
         ORG_CODE
    FROM DIM_ORG_JXJL
   WHERE ORG_ID <> '9E3CFC37-AA68-46AB-96AA-C9BE391C37C6'
     AND ISSHOW = 1
  
   ORDER BY ORDER_KEY),

ORG_ALPHA AS
 (SELECT ORG_ID,
         FATHER_ID,
         ORG_NAME,
         ORG_SNAME,
         ORDER_KEY,
         CASE
           WHEN ORG_LEVEL = 1 THEN
            1
           ELSE
            ORG_LEVEL + 1
         END ORG_LEVEL,
         ORG_CODE
    FROM ORG_RS
   WHERE ORG_ID = 'E0A3D386-D5C8-FB22-18DE-4424D49363B1'
      OR FATHER_ID != 'E0A3D386-D5C8-FB22-18DE-4424D49363B1'
  UNION ALL
  
  SELECT ORG_ID,
         
         CASE
           WHEN ORG_TYPE = '环京' THEN
            'E0A3D386-D5C8-FB22-18DE-4424D49363B1H'
           WHEN ORG_TYPE = '外埠' THEN
            'E0A3D386-D5C8-FB22-18DE-4424D49363B1W'
         END FATHER_ID,
         ORG_NAME,
         ORG_SNAME,
         ORDER_KEY,
         ORG_LEVEL + 1 ORG_LEVEL,
         ORG_CODE
    FROM ORG_RS
   WHERE FATHER_ID = 'E0A3D386-D5C8-FB22-18DE-4424D49363B1'
  
  UNION ALL
  SELECT 'E0A3D386-D5C8-FB22-18DE-4424D49363B1H' ORG_ID,
         'E0A3D386-D5C8-FB22-18DE-4424D49363B1' FATHER_ID,
         '环京' ORG_NAME,
         '环京' ORG_SNAME,
         11 ORDER_KEY,
         2 ORG_LEVEL,
         'HXH' ORG_CODE
    FROM DUAL
  UNION ALL
  SELECT 'E0A3D386-D5C8-FB22-18DE-4424D49363B1W' ORG_ID,
         'E0A3D386-D5C8-FB22-18DE-4424D49363B1' FATHER_ID,
         '外埠' ORG_NAME,
         '外埠' ORG_SNAME,
         12 ORDER_KEY,
         2 ORG_LEVEL,
         'HXW' ORG_CODE
    FROM DUAL),
ORG AS
 (SELECT *
    FROM ORG_ALPHA
   WHERE ORG_CODE LIKE
        /*(SELECT ORG_CODE || '%'
        FROM DIM_ORG_JXJL ${IF(LEN(ORG) = 0, "where org_id='E0A3D386-D5C8-FB22-18DE-4424D49363B1'", " where org_id='" + ORG + "'") })*/
         'HX%'),
RES AS
 (SELECT ORG_ID,
         ORG_NAME,
         STATUS,
         PLOT_ID,
         PLOT_NAME,
         LAND_SUPPLY,
         PLOT_RATIO,
         ACREAGE,
         AREA_PRICE,
         AREA_TOTAL,
         SECURITY_DEPOSIT,
         ZJXQ_NOW,
         ZJXQ_A,
         ZJXQ_B,
         ZJXQ_C,
         CARGO_VALUE,
         LISTING_DATE,
         DELISTING_DATE,
         GDQFK_NOW,
         GDQFK_A,
         GDQFK_B,
         GDQFK_C,
         PAY_DATE,
         RETURN_RATIO,
         RETURN_VALUE
    FROM DM_RES_PROJECT_DETAIL
   WHERE 1 = 1
  
  ),

--4级结果
RES_4 AS
 (SELECT O.ORG_ID,
         O.ORG_NAME,
         R.STATUS,
         R.PLOT_ID,
         R.PLOT_NAME,
         R.LAND_SUPPLY,
         R.PLOT_RATIO,
         R.ACREAGE,
         R.AREA_PRICE,
         R.AREA_TOTAL,
         R.SECURITY_DEPOSIT,
         R.ZJXQ_NOW,
         R.ZJXQ_A,
         R.ZJXQ_B,
         R.ZJXQ_C,
         R.CARGO_VALUE,
         R.LISTING_DATE,
         R.DELISTING_DATE,
         R.GDQFK_NOW,
         R.GDQFK_A,
         R.GDQFK_B,
         R.GDQFK_C,
         R.PAY_DATE,
         R.RETURN_RATIO,
         R.RETURN_VALUE,
         O.FATHER_ID,
         O.ORG_SNAME,
         O.ORG_LEVEL,
         O.ORDER_KEY,
         O.ORG_CODE
    FROM (SELECT * FROM ORG WHERE ORG_LEVEL = 4) O, RES R
   WHERE R.ORG_ID = O.ORG_ID),
-- 4级合计

RES_4_S AS
 (SELECT O.ORG_ID,
         O.ORG_NAME,
         '合计' STATUS,
         NULL PLOT_ID,
         TO_CHAR(COUNT(R.PLOT_ID)) PLOT_NAME,
         SUM(R.LAND_SUPPLY) LAND_SUPPLY,
         NULL PLOT_RATIO,
         SUM(R.ACREAGE) ACREAGE,
         NULL AREA_PRICE,
         SUM(R.AREA_TOTAL) AREA_TOTAL,
         NULL SECURITY_DEPOSIT,
         SUM(R.ZJXQ_NOW) ZJXQ_NOW,
         SUM(R.ZJXQ_A) ZJXQ_A,
         SUM(R.ZJXQ_B) ZJXQ_B,
         SUM(R.ZJXQ_C) ZJXQ_C,
         SUM(R.CARGO_VALUE) CARGO_VALUE,
         NULL LISTING_DATE,
         NULL DELISTING_DATE,
         SUM(R.GDQFK_NOW) GDQFK_NOW,
         SUM(R.GDQFK_A) GDQFK_A,
         SUM(R.GDQFK_B) GDQFK_B,
         SUM(R.GDQFK_C) GDQFK_C,
         NULL PAY_DATE,
         NULL RETURN_RATIO,
         SUM(R.RETURN_VALUE) RETURN_VALUE,
         O.FATHER_ID,
         O.ORG_SNAME,
         O.ORG_LEVEL,
         O.ORDER_KEY,
         O.ORG_CODE
    FROM (SELECT * FROM ORG WHERE ORG_LEVEL = 4) O, RES R
   WHERE R.ORG_ID = O.ORG_ID
   GROUP BY O.ORG_ID,
            O.ORG_NAME,
            O.FATHER_ID,
            O.ORG_SNAME,
            O.ORG_LEVEL,
            O.ORDER_KEY,
            O.ORG_CODE),

--3级结果(由4级合计)
RES_3_OTHER AS
 (SELECT F.ORG_ID,
         F.ORG_NAME,
         '合计' STATUS,
         NULL PLOT_ID,
         TO_CHAR(COUNT(R.PLOT_ID)) PLOT_NAME,
         SUM(R.LAND_SUPPLY) LAND_SUPPLY,
         NULL PLOT_RATIO,
         SUM(R.ACREAGE) ACREAGE,
         NULL AREA_PRICE,
         SUM(R.AREA_TOTAL) AREA_TOTAL,
         NULL SECURITY_DEPOSIT,
         SUM(R.ZJXQ_NOW) ZJXQ_NOW,
         SUM(R.ZJXQ_A) ZJXQ_A,
         SUM(R.ZJXQ_B) ZJXQ_B,
         SUM(R.ZJXQ_C) ZJXQ_C,
         SUM(R.CARGO_VALUE) CARGO_VALUE,
         NULL LISTING_DATE,
         NULL DELISTING_DATE,
         SUM(R.GDQFK_NOW) GDQFK_NOW,
         SUM(R.GDQFK_A) GDQFK_A,
         SUM(R.GDQFK_B) GDQFK_B,
         SUM(R.GDQFK_C) GDQFK_C,
         NULL PAY_DATE,
         NULL RETURN_RATIO,
         SUM(R.RETURN_VALUE) RETURN_VALUE,
         F.FATHER_ID,
         F.ORG_SNAME,
         F.ORG_LEVEL,
         F.ORDER_KEY,
         F.ORG_CODE
    FROM RES_4 R, ORG F, ORG S
   WHERE S.FATHER_ID = F.ORG_ID
     AND R.ORG_ID = S.ORG_ID
     AND F.ORG_LEVEL = 3
   GROUP BY F.ORG_ID,
            F.ORG_NAME,
            F.FATHER_ID,
            F.ORG_SNAME,
            F.ORG_LEVEL,
            F.ORDER_KEY,
            F.ORG_CODE
  
  ),

--三级
RES_3 AS
 (SELECT O.ORG_ID,
         O.ORG_NAME,
         R.STATUS,
         R.PLOT_ID,
         R.PLOT_NAME,
         R.LAND_SUPPLY,
         R.PLOT_RATIO,
         R.ACREAGE,
         R.AREA_PRICE,
         R.AREA_TOTAL,
         R.SECURITY_DEPOSIT,
         R.ZJXQ_NOW,
         R.ZJXQ_A,
         R.ZJXQ_B,
         R.ZJXQ_C,
         R.CARGO_VALUE,
         R.LISTING_DATE,
         R.DELISTING_DATE,
         R.GDQFK_NOW,
         R.GDQFK_A,
         R.GDQFK_B,
         R.GDQFK_C,
         R.PAY_DATE,
         R.RETURN_RATIO,
         R.RETURN_VALUE,
         O.FATHER_ID,
         O.ORG_SNAME,
         O.ORG_LEVEL,
         O.ORDER_KEY,
         O.ORG_CODE
    FROM (SELECT * FROM ORG WHERE ORG_LEVEL = 3) O, RES R
   WHERE R.ORG_ID = O.ORG_ID),
-- 3级合计

RES_3_S AS
 (SELECT O.ORG_ID,
         O.ORG_NAME,
         '合计' STATUS,
         NULL PLOT_ID,
         TO_CHAR(COUNT(R.PLOT_ID)) PLOT_NAME,
         SUM(R.LAND_SUPPLY) LAND_SUPPLY,
         NULL PLOT_RATIO,
         SUM(R.ACREAGE) ACREAGE,
         NULL AREA_PRICE,
         SUM(R.AREA_TOTAL) AREA_TOTAL,
         NULL SECURITY_DEPOSIT,
         SUM(R.ZJXQ_NOW) ZJXQ_NOW,
         SUM(R.ZJXQ_A) ZJXQ_A,
         SUM(R.ZJXQ_B) ZJXQ_B,
         SUM(R.ZJXQ_C) ZJXQ_C,
         SUM(R.CARGO_VALUE) CARGO_VALUE,
         NULL LISTING_DATE,
         NULL DELISTING_DATE,
         SUM(R.GDQFK_NOW) GDQFK_NOW,
         SUM(R.GDQFK_A) GDQFK_A,
         SUM(R.GDQFK_B) GDQFK_B,
         SUM(R.GDQFK_C) GDQFK_C,
         NULL PAY_DATE,
         NULL RETURN_RATIO,
         SUM(R.RETURN_VALUE) RETURN_VALUE,
         O.FATHER_ID,
         O.ORG_SNAME,
         O.ORG_LEVEL,
         O.ORDER_KEY,
         O.ORG_CODE
    FROM (SELECT * FROM ORG WHERE ORG_LEVEL = 3) O, RES R
   WHERE R.ORG_ID = O.ORG_ID
   GROUP BY O.ORG_ID,
            O.ORG_NAME,
            O.FATHER_ID,
            O.ORG_SNAME,
            O.ORG_LEVEL,
            O.ORDER_KEY,
            O.ORG_CODE),
-- 2级结果
RES_2 AS
 (SELECT F.ORG_ID,
         F.ORG_NAME,
         '合计' STATUS,
         NULL PLOT_ID,
         TO_CHAR(SUM(TO_NUMBER(NVL(R.PLOT_NAME, 0)))) PLOT_NAME,
         SUM(R.LAND_SUPPLY) LAND_SUPPLY,
         NULL PLOT_RATIO,
         SUM(R.ACREAGE) ACREAGE,
         NULL AREA_PRICE,
         SUM(R.AREA_TOTAL) AREA_TOTAL,
         NULL SECURITY_DEPOSIT,
         SUM(R.ZJXQ_NOW) ZJXQ_NOW,
         SUM(R.ZJXQ_A) ZJXQ_A,
         SUM(R.ZJXQ_B) ZJXQ_B,
         SUM(R.ZJXQ_C) ZJXQ_C,
         SUM(R.CARGO_VALUE) CARGO_VALUE,
         NULL LISTING_DATE,
         NULL DELISTING_DATE,
         SUM(R.GDQFK_NOW) GDQFK_NOW,
         SUM(R.GDQFK_A) GDQFK_A,
         SUM(R.GDQFK_B) GDQFK_B,
         SUM(R.GDQFK_C) GDQFK_C,
         NULL PAY_DATE,
         NULL RETURN_RATIO,
         SUM(R.RETURN_VALUE) RETURN_VALUE,
         F.FATHER_ID,
         F.ORG_SNAME,
         F.ORG_LEVEL,
         F.ORDER_KEY,
         F.ORG_CODE
    FROM (SELECT * FROM RES_3_S UNION ALL SELECT * FROM RES_3_OTHER) R,
         ORG F,
         ORG S
   WHERE S.FATHER_ID = F.ORG_ID
     AND R.ORG_ID = S.ORG_ID
     AND F.ORG_LEVEL = 2
   GROUP BY F.ORG_ID,
            F.ORG_NAME,
            F.FATHER_ID,
            F.ORG_SNAME,
            F.ORG_LEVEL,
            F.ORDER_KEY,
            F.ORG_CODE),
-- 1级结果 

RES_1 AS
 (SELECT F.ORG_ID,
         F.ORG_NAME,
         '合计' STATUS,
         NULL PLOT_ID,
         TO_CHAR(SUM(TO_NUMBER(NVL(R.PLOT_NAME, 0)))) PLOT_NAME,
         SUM(R.LAND_SUPPLY) LAND_SUPPLY,
         NULL PLOT_RATIO,
         SUM(R.ACREAGE) ACREAGE,
         NULL AREA_PRICE,
         SUM(R.AREA_TOTAL) AREA_TOTAL,
         NULL SECURITY_DEPOSIT,
         SUM(R.ZJXQ_NOW) ZJXQ_NOW,
         SUM(R.ZJXQ_A) ZJXQ_A,
         SUM(R.ZJXQ_B) ZJXQ_B,
         SUM(R.ZJXQ_C) ZJXQ_C,
         SUM(R.CARGO_VALUE) CARGO_VALUE,
         NULL LISTING_DATE,
         NULL DELISTING_DATE,
         SUM(R.GDQFK_NOW) GDQFK_NOW,
         SUM(R.GDQFK_A) GDQFK_A,
         SUM(R.GDQFK_B) GDQFK_B,
         SUM(R.GDQFK_C) GDQFK_C,
         NULL PAY_DATE,
         NULL RETURN_RATIO,
         SUM(R.RETURN_VALUE) RETURN_VALUE,
         F.FATHER_ID,
         F.ORG_SNAME,
         F.ORG_LEVEL,
         F.ORDER_KEY,
         F.ORG_CODE
    FROM RES_2 R, ORG F, ORG S
   WHERE S.FATHER_ID = F.ORG_ID
     AND R.ORG_ID = S.ORG_ID
     AND F.ORG_LEVEL = 1
   GROUP BY F.ORG_ID,
            F.ORG_NAME,
            F.FATHER_ID,
            F.ORG_SNAME,
            F.ORG_LEVEL,
            F.ORDER_KEY,
            F.ORG_CODE)

SELECT *
  FROM RES_1
UNION ALL
SELECT *
  FROM RES_2
UNION ALL
SELECT *
  FROM RES_3_S
UNION ALL
SELECT *
  FROM RES_3
UNION ALL
SELECT *
  FROM RES_3_OTHER
UNION ALL
SELECT *
  FROM RES_4_S
UNION ALL
SELECT * FROM RES_4
