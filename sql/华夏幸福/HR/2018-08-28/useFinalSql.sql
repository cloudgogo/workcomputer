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
                   AND R.RZQUDAO = '��ͷ')) HIRENUMBER,
       (SELECT COUNT(*) LZRS
          FROM (SELECT *
                  FROM ODM_HR_RZTZ R
                 WHERE TO_CHAR(R.RZDATE, 'yyyy') = '2018'
                   AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
                   AND R.RZQUDAO = '��ͷ'
                   AND R.ISLIZHI = '��ְ'
                   AND ABS(MONTHS_BETWEEN(R.RZDATE, R.LZDATE)) < 6)) FIRENUMBER
  FROM DUAL;


--first
SELECT TREE_NODE, DESCR, COUNT(YGID)
  FROM (select DISTINCT D.TREE_NODE, D.DESCR, R.YGID
          from ODM_HR_DW d, ODM_HR_RZTZ R
         where d.parent_node = 'HX_HEAD'
           AND INSTR(R.TREE_NODE_ID, D.PARENT_NODES) > 0
           AND TO_CHAR(R.RZDATE, 'yyyy') = '2018'
           AND TO_CHAR(R.RZDATE, 'MM') BETWEEN '01' AND '05'
           AND R.RZQUDAO = '��ͷ') RES
 group by tREE_NODE, DESCR;
 
 
 --second
 
 
 
