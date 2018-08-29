SELECT * FROM ODS_HR_CANDIDATO_S;
SELECT * FROM ODM_HR_ZPQD_WD;
SELECT * FROM ODM_HR_DW;

SELECT (SELECT COUNT(*) SUMNUMBER
          FROM (SELECT DISTINCT S.CANDIDATO
                  FROM ODS_HR_CANDIDATO_S S
                 WHERE S.DITCH = '57'
                   AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
                   AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05')) SUMNUMBER,
       (SELECT COUNT(*) SUMNUMBER
          FROM (SELECT DISTINCT S.CANDIDATO
                  FROM ODS_HR_CANDIDATO_S S
                 WHERE S.DITCH = '57'
                   AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
                   AND S.STATUS_FLOW = '090'
                   AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05')) HIRENUMBER,
       (SELECT COUNT(*) SUMNUMBER
          FROM (SELECT DISTINCT S.CANDIDATO
                  FROM ODS_HR_CANDIDATO_S S
                 WHERE S.DITCH = '57'
                   AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
                   AND S.STATUS_FLOW = '090'
                   AND S.PROBATION_LEAVE = 'Y'
                   AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05')) FIRENUMBER
  FROM DUAL;

SELECT MONTHS_BETWEEN(TO_DATE('2014-03-01', 'yyyy-MM-dd'),
                      TO_DATE('2014-04-23', 'yyyy-MM-dd'))
  FROM DUAL;

-- FIRST
/*
       SELECT * FROM ODS_HR_CANDIDATO_S S,ODM_HR_DW D WHERE 
        D.TREE_NODE=S.UNIT_ID||S.DEPARTMENT
       AND S.DITCH = '57'
       AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
       AND S.STATUS_FLOW = '090'
       AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05'*/
SELECT COUNT(*) RZRS
  FROM (SELECT DISTINCT R.YGID
          FROM ODM_HR_RZTZ R
         WHERE TO_CHAR(R.RZDATE, 'yyyy') = '2018'
           AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
           AND R.RZQUDAO = '猎头');

SELECT COUNT(*) LZRS
  FROM (SELECT *
          FROM ODM_HR_RZTZ R
         WHERE TO_CHAR(R.RZDATE, 'yyyy') = '2018'
           AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
           AND R.RZQUDAO = '猎头'
           AND R.ISLIZHI = '离职'
           AND ABS(MONTHS_BETWEEN(R.RZDATE, R.LZDATE)) < 6);

-- UPDATE TITLE 
SELECT (SELECT COUNT(*) SUMNUMBER
          FROM (SELECT DISTINCT S.CANDIDATO
                  FROM ODS_HR_CANDIDATO_S S
                 WHERE S.DITCH = '57'
                   AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
                   AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05')) SUMNUMBER,
       (SELECT COUNT(*) RZRS
          FROM (SELECT DISTINCT R.YGID
                  FROM ODM_HR_RZTZ R
                 WHERE TO_CHAR(R.RZDATE, 'yyyy') = '2018'
                   AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
                   AND R.RZQUDAO = '猎头')) HIRENUMBER,
       (SELECT COUNT(*) LZRS
          FROM (SELECT *
                  FROM ODM_HR_RZTZ R
                 WHERE TO_CHAR(R.RZDATE, 'yyyy') = '2018'
                   AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
                   AND R.RZQUDAO = '猎头'
                   AND R.ISLIZHI = '离职'
                   AND ABS(MONTHS_BETWEEN(R.RZDATE, R.LZDATE)) < 6)) FIRENUMBER
  FROM DUAL;

--FIRST PROBLEM
SELECT COUNT(*)
  FROM (SELECT DISTINCT YGID
          FROM ODM_HR_RZTZ R, ODM_HR_DW D
         WHERE TO_CHAR(R.RZDATE, 'yyyy') = '2018'
           AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
           AND R.RZQUDAO = '猎头'
           AND R.SETID || R.DEPTID = D.TREE_NODE) RES;
SELECT COUNT(*)
  FROM (SELECT DISTINCT YGID
          FROM ODM_HR_RZTZ R
         WHERE TO_CHAR(R.RZDATE, 'yyyy') = '2018'
           AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
           AND R.RZQUDAO = '猎头') RES;

--FIRST
SELECT TREE_NODE, DESCR, COUNT(YGID)
  FROM (SELECT DISTINCT D.TREE_NODE, D.DESCR, R.YGID
          FROM ODM_HR_DW D, ODM_HR_RZTZ R
         WHERE D.PARENT_NODE = 'HX_HEAD'
           AND INSTR(R.TREE_NODE_ID, D.PARENT_NODES) > 0
           AND TO_CHAR(R.RZDATE, 'yyyy') = '2018'
           AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
           AND R.RZQUDAO = '猎头') RES
 GROUP BY TREE_NODE, DESCR;

--SECOND
/*
SELECT (SELECT COUNT(*) SUMNUMBER
          FROM (SELECT DISTINCT  S.CANDIDATO
                  FROM ODS_HR_CANDIDATO_S S
                 WHERE S.DITCH = '57'
                   AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
                   AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05')) SUMNUMBER,
       (SELECT COUNT(*) RZRS
          FROM (SELECT DISTINCT R.YGID
                  FROM ODM_HR_RZTZ R
                 WHERE TO_CHAR(R.RZDATE, 'yyyy') = '2018'
                   AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
                   AND R.RZQUDAO = '猎头')) HIRENUMBER,
       (SELECT COUNT(*) LZRS
          FROM (SELECT *
                  FROM ODM_HR_RZTZ R
                 WHERE TO_CHAR(R.RZDATE, 'yyyy') = '2018'
                   AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
                   AND R.RZQUDAO = '猎头'
                   AND R.ISLIZHI = '离职'
                   AND ABS(MONTHS_BETWEEN(R.RZDATE, R.LZDATE)) < 6)) FIRENUMBER
  FROM DUAL;
  */
--PROBLEM 
SELECT CASE
         WHEN (LENGTH(TRIM(DESC_HEADHUNTER)) = 0 OR DESC_HEADHUNTER IS NULL) THEN
          HUNTER_ID
         ELSE
          DESC_HEADHUNTER
       END,
       COUNT(CANDIDATO) BUMENG
  FROM (SELECT DISTINCT S.CANDIDATO, S.DESC_HEADHUNTER, S.HUNTER_ID
          FROM ODS_HR_CANDIDATO_S S
         WHERE S.DITCH = '57'
           AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
           AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05')
 GROUP BY DESC_HEADHUNTER, HUNTER_ID;

/*
SELECT *
  FROM (SELECT DESC_HEADHUNTER, COUNT(CANDIDATO) PEONUM
          FROM (SELECT DISTINCT S.CANDIDATO, S.DESC_HEADHUNTER
                  FROM ODS_HR_CANDIDATO_S S,
                   ODM_HR_DW D
                 WHERE S.DITCH = '57'
                   AND D.PARENT_NODE = 'HX_HEAD'
                   AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
                   AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
                   AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05')
         GROUP BY DESC_HEADHUNTER)
 ORDER BY PEONUM DESC
 */

;
SELECT DISTINCT R.YGID
  FROM ODM_HR_RZTZ R
 WHERE TO_CHAR(R.RZDATE, 'yyyy') = '2018'
   AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
   AND R.RZQUDAO = '猎头';
--  TITLE 
SELECT (SELECT COUNT(*) SUMNUMBER
          FROM (SELECT DISTINCT S.CANDIDATO
                  FROM ODS_HR_CANDIDATO_S S
                 WHERE S.DITCH = '57'
                   AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
                   AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05')) SUMNUMBER,
       (SELECT COUNT(*) RZRS
          FROM (SELECT DISTINCT R.YGID
                  FROM ODM_HR_RZTZ R
                 WHERE TO_CHAR(R.RZDATE, 'yyyy') = '2018'
                   AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
                   AND R.RZQUDAO = '猎头')) HIRENUMBER,
       (SELECT COUNT(*) LZRS
          FROM (SELECT *
                  FROM ODM_HR_RZTZ R
                 WHERE TO_CHAR(R.RZDATE, 'yyyy') = '2018'
                   AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
                   AND R.RZQUDAO = '猎头'
                   AND R.ISLIZHI = '离职'
                   AND ABS(MONTHS_BETWEEN(R.RZDATE, R.LZDATE)) < 6)) FIRENUMBER
  FROM DUAL;

--FIRST
SELECT TREE_NODE, DESCR, COUNT(YGID)
  FROM (SELECT DISTINCT D.TREE_NODE, D.DESCR, R.YGID
          FROM ODM_HR_DW D, ODM_HR_RZTZ R
         WHERE D.PARENT_NODE = 'HX_HEAD'
           AND INSTR(R.TREE_NODE_ID, D.PARENT_NODES) > 0
           AND TO_CHAR(R.RZDATE, 'yyyy') = '2018'
           AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
           AND R.RZQUDAO = '猎头') RES
 GROUP BY TREE_NODE, DESCR;

--UPDATE 

SELECT RES.DESCR, RES.TREE_NODE, COUNT(RES.CANDIDATO)
  FROM (SELECT DISTINCT S.CANDIDATO, D.TREE_NODE, D.DESCR
          FROM ODS_HR_CANDIDATO_S S, ODM_HR_DW D
         WHERE D.PARENT_NODE = 'HX_HEAD'
           AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
           AND S.DITCH = '57'
           AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
           AND S.STATUS_FLOW = '090'
           AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05') RES
 GROUP BY RES.DESCR, RES.TREE_NODE
;

SELECT CASE
         WHEN (LENGTH(TRIM(DESC_HEADHUNTER)) = 0 OR DESC_HEADHUNTER IS NULL) THEN
          HUNTER_ID
         ELSE
          DESC_HEADHUNTER
       END,
       COUNT(CANDIDATO) BUMENG
  FROM (SELECT DISTINCT S.CANDIDATO, S.DESC_HEADHUNTER, S.HUNTER_ID
          FROM ODS_HR_CANDIDATO_S S
         WHERE S.DITCH = '57'
           AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
           AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05')
 GROUP BY DESC_HEADHUNTER, HUNTER_ID;
 
   SELECT *
  FROM (SELECT DESC_HEADHUNTER, COUNT(CANDIDATO) PEONUM
          FROM (SELECT DISTINCT S.CANDIDATO, S.DESC_HEADHUNTER
                  FROM ODS_HR_CANDIDATO_S S,
                   ODM_HR_DW D
                 WHERE S.DITCH = '57'
                   AND D.PARENT_NODE = 'HX_HEAD'
                   AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
                   AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
                   AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05')
         GROUP BY DESC_HEADHUNTER)
 ORDER BY PEONUM DESC
 
 ----- 
 
 
 
 
 
  SELECT *
  FROM (SELECT DESC_HEADHUNTER, COUNT(CANDIDATO) PEONUM
          FROM (SELECT DISTINCT S.CANDIDATO, S.DESC_HEADHUNTER
                  FROM ODS_HR_CANDIDATO_S S,
                   ODM_HR_DW D
                 WHERE S.DITCH = '57'
                   AND D.PARENT_NODE = 'HX_HEAD'
                   AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
                   AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
                   AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05')
         GROUP BY DESC_HEADHUNTER)
 ORDER BY PEONUM DESC;

  SELECT *
  FROM (SELECT DESC_HEADHUNTER, COUNT(CANDIDATO) PEONUM
          FROM (SELECT DISTINCT S.CANDIDATO, S.DESC_HEADHUNTER
                  FROM ODS_HR_CANDIDATO_S S,
                   ODM_HR_DW D
                 WHERE S.DITCH = '57'
                   AND D.PARENT_NODE = 'HX_HEAD'
                   AND S.STATUS_FLOW = '090'
                   AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
                   AND TO_CHAR(S.HIREDATE, 'yyyy') = '2018'
                   AND TO_CHAR(S.HIREDATE, 'MM') BETWEEN '01' AND '05')
         GROUP BY DESC_HEADHUNTER)
 ORDER BY PEONUM DESC;
   SELECT *
  FROM (SELECT DESC_HEADHUNTER, COUNT(CANDIDATO) PEONUM
          FROM (SELECT DISTINCT S.CANDIDATO, S.DESC_HEADHUNTER
                  FROM ODS_HR_CANDIDATO_S S,
                   ODM_HR_DW D
                 WHERE S.DITCH = '57'
                   AND D.PARENT_NODE = 'HX_HEAD'
                   AND S.STATUS_FLOW = '090'
                   AND S.PROBATION_LEAVE = 'Y'
                   AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
                   AND TO_CHAR(S.HIREDATE, 'yyyy') = '2018'
                   AND TO_CHAR(S.HIREDATE, 'MM') BETWEEN '01' AND '05')
         GROUP BY DESC_HEADHUNTER)
 ORDER BY PEONUM DESC;
 
 ----
 
 
 SELECT NVL(A.DESC_HEADHUNTER, NVL(B.DESC_HEADHUNTER, C.DESC_HEADHUNTER)) DESC_HEADHUNTER,
        A.PEONUM SUMVALUE,
        B.PEONUM HIRENUM,
        C.PEONUM FIRENUM
   FROM (SELECT DESC_HEADHUNTER, COUNT(CANDIDATO) PEONUM
           FROM (SELECT DISTINCT S.CANDIDATO, S.DESC_HEADHUNTER
                   FROM ODS_HR_CANDIDATO_S S, ODM_HR_DW D
                  WHERE S.DITCH = '57'
                    AND D.PARENT_NODE = 'HX_HEAD'
                    AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
                    AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
                    AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05')
          GROUP BY DESC_HEADHUNTER) A
   LEFT JOIN (SELECT DESC_HEADHUNTER, COUNT(CANDIDATO) PEONUM
                FROM (SELECT DISTINCT S.CANDIDATO, S.DESC_HEADHUNTER
                        FROM ODS_HR_CANDIDATO_S S, ODM_HR_DW D
                       WHERE S.DITCH = '57'
                         AND D.PARENT_NODE = 'HX_HEAD'
                         AND S.STATUS_FLOW = '090'
                         AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
                         AND TO_CHAR(S.HIREDATE, 'yyyy') = '2018'
                         AND TO_CHAR(S.HIREDATE, 'MM') BETWEEN '01' AND '05')
               GROUP BY DESC_HEADHUNTER) B
     ON A.DESC_HEADHUNTER = B.DESC_HEADHUNTER
   LEFT JOIN (SELECT DESC_HEADHUNTER, COUNT(CANDIDATO) PEONUM
                FROM (SELECT DISTINCT S.CANDIDATO, S.DESC_HEADHUNTER
                        FROM ODS_HR_CANDIDATO_S S, ODM_HR_DW D
                       WHERE S.DITCH = '57'
                         AND D.PARENT_NODE = 'HX_HEAD'
                         AND S.STATUS_FLOW = '090'
                         AND S.PROBATION_LEAVE = 'Y'
                         AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
                         AND TO_CHAR(S.HIREDATE, 'yyyy') = '2018'
                         AND TO_CHAR(S.HIREDATE, 'MM') BETWEEN '01' AND '05')
               GROUP BY DESC_HEADHUNTER) C
     ON B.DESC_HEADHUNTER = C.DESC_HEADHUNTER;
     
     
     SELECT DESC_HEADHUNTER, COUNT(CANDIDATO) PEONUM
                FROM (SELECT DISTINCT S.CANDIDATO, S.PRO_LEVEL
                        FROM ODS_HR_CANDIDATO_S S, ODM_HR_DW D
                       WHERE S.DITCH = '57'
                         AND D.PARENT_NODE = 'HX_HEAD'
                         AND S.STATUS_FLOW = '090'
                         AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
                         AND TO_CHAR(S.HIREDATE, 'yyyy') = '2018'
                         AND TO_CHAR(S.HIREDATE, 'MM') BETWEEN '01' AND '05')
               GROUP BY DESC_HEADHUNTER;
               /*
SELECT DISTINCT S.CANDIDATO_NAME,null id,S.PRO_LEVEL,S.UNIT_NAME||'-'||S.DEPT_NAME UNITDEPT,SUBSTR(s.pro_name,5) pro_name,S.DESC_HEADHUNTER,  S.HIREDATE,NULL OFFERDATE ,S.FIREDATE,S.PROBATION_LEAVE
          FROM ODS_HR_CANDIDATO_S S, ODM_HR_DW D
          WHERE S.DITCH = '57' 
           AND D.PARENT_NODE =  ${if(len(DWMC)=0,"'HX_HEAD'","'"+DWMC+"'")}
           AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
           ${if(len(YEAR)=0,"","AND TO_CHAR(S.HIREDATE, 'yyyy') = '"+YEAR+"'")}
           AND S.STATUS_FLOW = '090'
           ${if(or(len(start)=0,len(end)=0),"","AND TO_CHAR(S.HIREDATE, 'MM') BETWEEN '"+start+"' AND '"+end + "'")}
           ORDER BY S.HIREDATE
           */

