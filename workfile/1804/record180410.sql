SELECT *
  FROM (SELECT c.attribute5,
               '' tzxs,
               NULL xjjgzl,
               NULL yszkl,
               NULL fdcjtdl,
               NULL ssgp,
               NULL qtgql,
               SUM(c.book_value) book_value,
               '01' TYPE
          FROM hrs_core_economic_capital c, hrs_core_financial_product p
         WHERE c.attribute5 = p.detail_category
              
           AND c.period_name = '2018-02'
           AND p.asset_category = '810'
              -- and c.financial_type is not null
           AND c.segment1 NOT IN
               ('104', '10401', '10402', '10403', '10404', '10405A', '105')
         GROUP BY c.attribute5
        
        UNION ALL
        
        SELECT c.attribute5,
               '' tzxs,
               NULL xjjgzl,
               NULL yszkl,
               NULL fdcjtdl,
               NULL ssgp,
               NULL qtgql,
               SUM(c.book_value) book_value,
               '01' TYPE
          FROM hrs_core_economic_capital c, hrs_core_financial_product p
         WHERE c.attribute5 = p.detail_category
              
           AND c.period_name = '2018-02'
           AND p.asset_category = '810'
           AND c.segment1 = '104'
        --and c.financial_type is not null
         GROUP BY c.attribute5)

UNION ALL

SELECT zqzt.flex_value attribute5,
       '' tzxs,
       NULL xjjgzl,
       NULL yszkl,
       NULL fdcjtdl,
       NULL ssgp,
       NULL qtgql,
       SUM(c.book_value) book_value,
       '02' TYPE
  FROM hrs_core_economic_capital c,
       hrs_core_financial_product p,
       (SELECT v.flex_value, v.description
          FROM hrs_def_flex_value_sets s, hrs_def_flex_values v
         WHERE s.flex_value_set_id = v.flex_value_set_id
           AND s.flex_value_set_name = 'JJZB-BC-债权主体') zqzt
 WHERE c.attribute5 = p.detail_category
   AND c.period_name = '2018-02'
   AND p.asset_category = '120'
   AND p.bond_subject = zqzt.description
--and c.financial_type is not null
 GROUP BY zqzt.flex_value

UNION ALL
SELECT c.attribute5,
       c.tzxs,
       NULL xjjgzl,
       NULL yszkl,
       NULL fdcjtdl,
       NULL ssgp,
       NULL qtgql,
       SUM(c.book_value) book_value,
       '03' TYPE
  FROM hrs_core_economic_capital c, hrs_core_financial_product p
 WHERE c.attribute5 = p.detail_category
   AND c.period_name = '2018-02'
   AND p.asset_category = '120'
      --and c.financial_type is not null
   AND c.attribute5 <> '2920'
   AND c.segment1 NOT IN
       ('10401', '10402', '10403', '10404', '10405A', '105')
 GROUP BY c.attribute5, c.tzxs

UNION ALL

SELECT '2920' attribute5,
       '' tzxs,
       NULL xjjgzl,
       NULL yszkl,
       NULL fdcjtdl,
       NULL ssgp,
       NULL qtgql,
       SUM(t.book_value) book_value,
       '03' TYPE
  FROM (SELECT SUM(c.book_value) book_value
        
          FROM hrs_core_economic_capital c
         WHERE c.period_name = '2018-02'
           AND c.attribute5 = '2920'
           AND c.segment1 = '104'
        UNION ALL
        SELECT (-1) * SUM(c.book_value) book_value
        
          FROM hrs_core_economic_capital c, hrs_core_financial_product p
         WHERE c.attribute5 = p.detail_category
           AND c.period_name = '2018-02'
           AND c.attribute5 IN ('2970', '2980')) t

UNION ALL

SELECT c.attribute5,
       '' tzxs,
       SUM(c.xjjgzl) xjjgzl,
       SUM(c.yszkl) yszkl,
       SUM(c.fdcjtdl) fdcjtdl,
       SUM(c.ssgp) ssgp,
       SUM(c.qtgql) qtgql,
       SUM(c.book_value) book_value,
       '07' TYPE
  FROM hrs_core_economic_capital c, hrs_core_financial_product p
 WHERE c.attribute5 = p.detail_category
   AND c.period_name = '2018-02'
   AND c.attribute5 IN ('6120', '6210')
   AND p.asset_category = '180'
-- and c.financial_type is not null
 GROUP BY c.attribute5
UNION ALL
SELECT c.attribute5,
       CASE WHEN c.convertable IN ('AAA','A-1')
             THEN 'AAA'
            WHEN c.convertable='AA+'
             THEN 'AA+'
            WHEN c.convertable ='AA'
             THEN 'AA'
            WHEN c.convertable='AA-'
             THEN 'AA'
             WHEN c.convertable IN ('A+','A','A-')
             THEN 'A+、A、A-'
               ELSE 
                 'BBB+、BBB、BBB-、无评级' end tzxs,
       SUM(c.xjjgzl) xjjgzl,
       SUM(c.yszkl) yszkl,
       SUM(c.fdcjtdl) fdcjtdl,
       SUM(c.ssgp) ssgp,
       SUM(c.qtgql) qtgql,
       SUM(c.book_value) book_value,
       '05' TYPE
  FROM hrs_core_economic_capital c, hrs_core_financial_product p
 WHERE c.attribute5 = p.detail_category
   AND c.period_name = '2018-02'
   AND c.attribute5 = '8420'
   AND p.asset_category = '180'
--and c.financial_type is not null
 GROUP BY c.attribute5, CASE WHEN c.convertable IN ('AAA','A-1')
             THEN 'AAA'
            WHEN c.convertable='AA+'
             THEN 'AA+'
            WHEN c.convertable ='AA'
             THEN 'AA'
            WHEN c.convertable='AA-'
             THEN 'AA'
             WHEN c.convertable IN ('A+','A','A-')
             THEN 'A+、A、A-'
               ELSE 
                 'BBB+、BBB、BBB-、无评级' end
UNION ALL
SELECT c.attribute5,
       CASE WHEN c.convertable IN ('AAA','A-1')
             THEN 'AAA'
            WHEN c.convertable='AA+'
             THEN 'AA+'
            WHEN c.convertable ='AA'
             THEN 'AA'
            WHEN c.convertable='AA-'
             THEN 'AA'
             WHEN c.convertable IN ('A+','A','A-')
             THEN 'A+、A、A-'
               ELSE 
                 'BBB+、BBB、BBB-、无评级' end tzxs,
       SUM(c.xjjgzl) xjjgzl,
       SUM(c.yszkl) yszkl,
       SUM(c.fdcjtdl) fdcjtdl,
       SUM(c.ssgp) ssgp,
       SUM(c.qtgql) qtgql,
       SUM(c.book_value) book_value,
       '09' TYPE
  FROM hrs_core_economic_capital c, hrs_core_financial_product p
 WHERE c.attribute5 = p.detail_category
   AND c.period_name = '2018-02'
   AND c.attribute5 IN ('2810', '2820')
   AND p.asset_category = '180'
   AND c.financial_type IN (20, 30)
 GROUP BY c.attribute5, CASE WHEN c.convertable IN ('AAA','A-1')
             THEN 'AAA'
            WHEN c.convertable='AA+'
             THEN 'AA+'
            WHEN c.convertable ='AA'
             THEN 'AA'
            WHEN c.convertable='AA-'
             THEN 'AA'
             WHEN c.convertable IN ('A+','A','A-')
             THEN 'A+、A、A-'
               ELSE 
                 'BBB+、BBB、BBB-、无评级' end
UNION ALL
--不良资产
SELECT c.attribute5,
       '' tzxs,
       SUM(c.xjjgzl) xjjgzl,
       SUM(c.yszkl) yszkl,
       SUM(c.fdcjtdl) fdcjtdl,
       SUM(c.ssgp) ssgp,
       SUM(c.qtgql) qtgql,
       SUM(c.book_value) book_value,
       '12' TYPE
  FROM hrs_core_economic_capital c, hrs_core_financial_product p
 WHERE c.attribute5 = p.detail_category
   AND c.period_name = '2018-02'
   AND p.asset_category = '440'
-- and c.financial_type is not null
 GROUP BY c.attribute5

UNION ALL
SELECT *
  FROM (SELECT c.attribute5,
               '' tzxs,
               SUM(c.xjjgzl) xjjgzl,
               SUM(c.yszkl) yszkl,
               SUM(c.fdcjtdl) fdcjtdl,
               SUM(c.ssgp) ssgp,
               SUM(c.qtgql) qtgql,
               SUM(c.book_value) book_value,
               '11' TYPE
          FROM hrs_core_economic_capital c,
               hrs_core_financial_product p,
               (SELECT v.flex_value, v.description
                  FROM hrs_def_flex_value_sets s, hrs_def_flex_values v
                 WHERE s.flex_value_set_id = v.flex_value_set_id
                   AND s.flex_value_set_name = 'JJZB-BC-债权主体') zqzt
         WHERE c.attribute5 = p.detail_category
           AND c.period_name = '2018-02'
           AND p.bond_subject = zqzt.description
           AND p.asset_category = '120'
           AND p.bond_subject = '个人'
           AND c.segment1 NOT IN
               ('104', '10401', '10402', '10403', '10404', '10405A', '105')
         GROUP BY c.attribute5
        
        UNION ALL
        
        SELECT c.attribute5,
               '' tzxs,
               SUM(c.xjjgzl) xjjgzl,
               SUM(c.yszkl) yszkl,
               SUM(c.fdcjtdl) fdcjtdl,
               SUM(c.ssgp) ssgp,
               SUM(c.qtgql) qtgql,
               SUM(c.book_value) book_value,
               '11' TYPE
          FROM hrs_core_economic_capital c,
               hrs_core_financial_product p,
               (SELECT v.flex_value, v.description
                  FROM hrs_def_flex_value_sets s, hrs_def_flex_values v
                 WHERE s.flex_value_set_id = v.flex_value_set_id
                   AND s.flex_value_set_name = 'JJZB-BC-债权主体') zqzt
         WHERE c.attribute5 = p.detail_category
           AND c.period_name = '2018-02'
           AND p.bond_subject = zqzt.description
           AND p.asset_category = '120'
           AND p.bond_subject = '个人'
           AND c.segment1 = '104'
        --and c.financial_type is not null
         GROUP BY c.attribute5)

UNION ALL

SELECT CASE WHEN c.convertable IN ('AAA','A-1')
             THEN 'AAA'
            WHEN c.convertable='AA+'
             THEN 'AA+'
            WHEN c.convertable ='AA'
             THEN 'AA'
            WHEN c.convertable='AA-'
             THEN 'AA'
             WHEN c.convertable IN ('A+','A','A-')
             THEN 'A+、A、A-'
               ELSE 
                 'BBB+、BBB、BBB-、无评级' end attribute5,
       CASE
         WHEN round(abs(SYSDATE - to_date(c.maturity_date, 'yyyy-mm-dd'))) <=
              '365' THEN
          '01'
         WHEN round(abs(SYSDATE - to_date(c.maturity_date, 'yyyy-mm-dd'))) <=
              '1825' AND
              round(abs(SYSDATE - to_date(c.maturity_date, 'yyyy-mm-dd'))) >
              '365' THEN
          '02'
         WHEN round(abs(SYSDATE - to_date(c.maturity_date, 'yyyy-mm-dd'))) >
              '1825' THEN
          '03'
       END tzxs,
       SUM(c.xjjgzl) xjjgzl,
       SUM(c.yszkl) yszkl,
       SUM(c.fdcjtdl) fdcjtdl,
       SUM(c.ssgp) ssgp,
       SUM(c.qtgql) qtgql,
       SUM(c.book_value) book_value,
       '04' TYPE
  FROM hrs_core_economic_capital c, hrs_core_financial_product p
 WHERE c.attribute5 = p.detail_category
   AND c.period_name = '2018-02'
   AND c.attribute5 IN
       ('2060', '2210', '2220', '2310', '2320', '2330', '2610', '2510')
   AND p.asset_category = '110'
   AND c.financial_type IN (20, 30)
 GROUP BY CASE WHEN c.convertable IN ('AAA','A-1')
             THEN 'AAA'
            WHEN c.convertable='AA+'
             THEN 'AA+'
            WHEN c.convertable ='AA'
             THEN 'AA'
            WHEN c.convertable='AA-'
             THEN 'AA'
             WHEN c.convertable IN ('A+','A','A-')
             THEN 'A+、A、A-'
               ELSE 
                 'BBB+、BBB、BBB-、无评级' end,
          CASE
            WHEN round(abs(SYSDATE - to_date(c.maturity_date, 'yyyy-mm-dd'))) <=
                 '365' THEN
             '01'
            WHEN round(abs(SYSDATE - to_date(c.maturity_date, 'yyyy-mm-dd'))) <=
                 '1825' AND
                 round(abs(SYSDATE - to_date(c.maturity_date, 'yyyy-mm-dd'))) >
                 '365' THEN
             '02'
            WHEN round(abs(SYSDATE - to_date(c.maturity_date, 'yyyy-mm-dd'))) >
                 '1825' THEN
             '03'
          END

UNION ALL

SELECT c.attribute6 attribute5,
       '' tzxs,
       SUM(c.xjjgzl) xjjgzl,
       SUM(c.yszkl) yszkl,
       SUM(c.fdcjtdl) fdcjtdl,
       SUM(c.ssgp) ssgp,
       SUM(c.qtgql) qtgql,
       SUM(c.book_value) book_value,
       '08' TYPE
  FROM hrs_core_economic_capital c, hrs_core_financial_product p
 WHERE c.attribute5 = p.detail_category
   AND c.period_name = '2018-02'
   AND p.asset_category = '160'
--and c.financial_type is not null
 GROUP BY c.attribute6
