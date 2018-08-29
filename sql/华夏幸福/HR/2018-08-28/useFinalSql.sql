--TITLE 
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

--FIRST
SELECT RES.DESCR, RES.TREE_NODE, COUNT(RES.CANDIDATO)
  FROM (SELECT DISTINCT S.CANDIDATO, D.TREE_NODE, D.DESCR
          FROM ODS_HR_CANDIDATO_S S, ODM_HR_DW D
         WHERE D.PARENT_NODE = 'HX_HEAD'
           AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
           AND S.DITCH = '57'
           AND TO_CHAR(S.HIREDATE, 'yyyy') = '2018'
           AND S.STATUS_FLOW = '090'
           AND TO_CHAR(S.HIREDATE, 'MM') BETWEEN '01' AND '05') RES
 GROUP BY RES.DESCR, RES.TREE_NODE;

--SECOND 
SELECT NVL(A.DESC_HEADHUNTER, NVL(B.DESC_HEADHUNTER, C.DESC_HEADHUNTER)) DESC_HEADHUNTER,
       A.PEONUM SUMVALUE,
       B.PEONUM HIRENUM,
       C.PEONUM FIRENUM,
       CASE
         WHEN A.PEONUM IS NULL OR A.PEONUM = 0 THEN
          0
         ELSE
          NVL(B.PEONUM, 0) / A.PEONUM
       END RZZHL,
       CASE
         WHEN B.PEONUM IS NULL OR B.PEONUM = 0 THEN
          0
         ELSE
          NVL(C.PEONUM, 0) / B.PEONUM
       END RZLZL
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
-- THIRD
SELECT PRO_LEVEL, COUNT(CANDIDATO) PEONUM
  FROM (SELECT DISTINCT S.CANDIDATO, S.PRO_LEVEL
          FROM ODS_HR_CANDIDATO_S S, ODM_HR_DW D
         WHERE S.DITCH = '57'
           AND D.PARENT_NODE = 'HX_HEAD'
           AND S.STATUS_FLOW = '090'
           AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
           AND TO_CHAR(S.HIREDATE, 'yyyy') = '2018'
           AND TO_CHAR(S.HIREDATE, 'MM') BETWEEN '01' AND '05')
 GROUP BY PRO_LEVEL
 ORDER BY PRO_LEVEL;

-- FORTH
SELECT PRO_LEVEL, COUNT(CANDIDATO) PEONUM
  FROM (SELECT DISTINCT S.CANDIDATO, S.PRO_LEVEL
          FROM ODS_HR_CANDIDATO_S S, ODM_HR_DW D
         WHERE S.DITCH = '57'
           AND D.PARENT_NODE = 'HX_HEAD'
           AND S.STATUS_FLOW = '090'
           AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
           AND TO_CHAR(S.DATE_FLOW, 'yyyy') = '2018'
           AND TO_CHAR(S.DATE_FLOW, 'MM') BETWEEN '01' AND '05')
 GROUP BY PRO_LEVEL
 ORDER BY PRO_LEVEL;

--FIFTH
SELECT DESC_HEADHUNTER, COUNT(CANDIDATO) PEONUM
  FROM (SELECT DISTINCT S.CANDIDATO, S.DESC_HEADHUNTER
          FROM ODS_HR_CANDIDATO_S S, ODM_HR_DW D
         WHERE S.DITCH = '57'
           AND D.PARENT_NODE = 'HX_HEAD'
           AND S.STATUS_FLOW = '090'
           AND S.PRO_LEVEL = '04'
           AND INSTR(S.TREE_NODE_ID, D.PARENT_NODES) > 0
           AND TO_CHAR(S.HIREDATE, 'yyyy') = '2018'
           AND TO_CHAR(S.HIREDATE, 'MM') BETWEEN '01' AND '05')
 GROUP BY DESC_HEADHUNTER
