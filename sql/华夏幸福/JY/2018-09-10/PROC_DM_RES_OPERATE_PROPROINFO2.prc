CREATE OR REPLACE PROCEDURE PROC_DM_RES_OPERATE_PROPROINFO
/**
   * 名称： PROC_DM_RES_OPERATE_PROPROINFO
   * 功能描述：加载DM_RES_OPERATE_PROPROJECTINFO表数据
   * 参数：
   *     DATADATE 待处理交易流水的日期   VARCHAR(8) YYYYMMDD 不使用
   *
   * 处理流程：
   * 1、
   * 2
   *
   * 修改日期      修改人  修改内容
   * 负责人 ：     高祥云
   */
IS
   status NUMBER;
/*   error_info VARCHAR2(100);*/

 /**
    错误日志参数
  */
  ERR_CODE   VARCHAR2(100); --错误代码
  ERR_MSG    VARCHAR2(300); --错误信息
  BEGIN_DATE DATE;          --存储过程开始执行时间
  ERROR_CD   VARCHAR2(2000);--错误部分
  SPNAME     VARCHAR2(50);  --存储过程名称
  SPCONTENT VARCHAR2(100);  --存储过程名称含义

BEGIN
  BEGIN_DATE := SYSDATE;  --赋值日志开始时间
  SPNAME := 'PROC_DM_RES_OPERATE_PROPROINFO'; --注意修改
  SPCONTENT := '加载DM_RES_OPERATE_PROPROJECTINFO表数据'; --注意修改
  ERROR_CD := '0001---清空表数据';

EXECUTE IMMEDIATE 'TRUNCATE TABLE DM_RES_OPERATE_PROPROJECTINFO';
COMMIT;
ERROR_CD := '0002---加载年度数据';


INSERT INTO DM_RES_OPERATE_PROPROJECTINFO
  (org_classify,
   buid,
   buname,
   areaid,
   areaname,
   orgid,
   orgname,
   proid,
   proname,
   coverarea,
   acreage,
   availableacreage,
   totalvalue,
   surplusvalue,
   bitchprice,
   planningtime,
   diffplanningtime,
   planning_points,
   dealtime,
   starttime,
   diffstarttime,
   delisting_planning,
   plantime,
   diffplantime,
   delisting_programme,
   demonstrationtime,
   diffdemonstrationtime,
   delisting_emonstration_plo,
   openingtime,
   diffopeningtime,
   delisting_opening,
   cashflowsbacktime,
   diffcashflowsbacktime,
   delisting_reflow,
   etl_date)
  WITH W1 AS
   (SELECT T1.*
      FROM BASS_ODS.ODS_V_OPERATE_PROPROJECTINFO T1
     WHERE TO_CHAR(NVL(T1.REALDEALTIME, T1.PLANDEALTIME), 'YYYY') =
           TO_CHAR(SYSDATE, 'YYYY')
       AND BATCHNAME = '第1批次'
       AND (ISCOUNTDISCIPLINE <> '不计算' OR ISCOUNTDISCIPLINE IS NULL)),
  W2 AS
   (SELECT W1.AREAID,
           W1.AREANAME,
           W1.BUID,
           W1.BUNAME,
           W1.ORGID,
           W1.ORGNAME,
           W1.PROID,
           W1.PRONAME,
           W1.COVERAREA,
           W1.ACREAGE,
           W1.AVAILABLEACREAGE,
           W1.TOTALVALUE,
           W1.SURPLUSVALUE,
           DECODE(NVL(W1.ACREAGE, 0), 0, 0, W1.TOTALVALUE / W1.ACREAGE) BITCHPRICE,
           NVL(W1.REALPLANNINGTIME, W1.PLANNINGTIME) PLANNINGTIME,
           ABS(NVL(W1.REALPLANNINGTIME, W1.PLANNINGTIME) -
               NVL(W1.REALDEALTIME, W1.PLANDEALTIME)) DIFFPLANNINGTIME,
           T1.PLANNING_POINTS,
           NVL(W1.REALDEALTIME, W1.PLANDEALTIME) DEALTIME,
           NVL(W1.REALSTARTTIME, W1.PLANSTARTTIME) STARTTIME,
           NVL(W1.REALSTARTTIME, W1.PLANSTARTTIME) -
           NVL(W1.REALDEALTIME, W1.PLANDEALTIME) DIFFSTARTTIME,
           T1.DELISTING_PLANNING,
           NVL(W1.REALPLANTIME, W1.PLANTIME) PLANTIME,
           NVL(W1.REALPLANTIME, W1.PLANTIME) -
           NVL(W1.REALDEALTIME, W1.PLANDEALTIME) DIFFPLANTIME,
           T1.DELISTING_PROGRAMME,
           NVL(W1.REALDEMONSTRATIONTIME, W1.PLANDEMONSTRATIONTIME) DEMONSTRATIONTIME,
           NVL(W1.REALDEMONSTRATIONTIME, W1.PLANDEMONSTRATIONTIME) -
           NVL(W1.REALDEALTIME, W1.PLANDEALTIME) DIFFDEMONSTRATIONTIME,
           T1.DELISTING_EMONSTRATION_PLO,
           NVL(W1.REALOPENINGTIME, W1.PLANOPENINGTIME) OPENINGTIME,
           NVL(W1.REALOPENINGTIME, W1.PLANOPENINGTIME) -
           NVL(W1.REALDEALTIME, W1.PLANDEALTIME) DIFFOPENINGTIME,
           T1.DELISTING_OPENING,
           NVL(W1.REALCASHFLOWSBACKTIME, W1.PLANCASHFLOWSBACKTIME) CASHFLOWSBACKTIME,
           NVL(W1.REALCASHFLOWSBACKTIME, W1.PLANCASHFLOWSBACKTIME) -
           NVL(W1.REALDEALTIME, W1.PLANDEALTIME) DIFFCASHFLOWSBACKTIME,
           T1.DELISTING_REFLOW
      FROM W1
      JOIN BASS_ODS.ODS_DISCIPLINE_BENCHMARKS T1
        ON W1.AREAID = T1.AREA_ORG_ID
    /* WHERE NVL(W1.REALPLANNINGTIME, W1.PLANNINGTIME) IS NOT NULL
       AND NVL(W1.REALDEALTIME, W1.PLANDEALTIME) IS NOT NULL
       AND NVL(W1.REALSTARTTIME, W1.PLANSTARTTIME) IS NOT NULL
       AND NVL(W1.REALPLANTIME, W1.PLANTIME) IS NOT NULL
       AND NVL(W1.REALDEMONSTRATIONTIME, W1.PLANDEMONSTRATIONTIME) IS NOT NULL
       AND NVL(W1.REALOPENINGTIME, W1.PLANOPENINGTIME) IS NOT NULL
       AND NVL(W1.REALCASHFLOWSBACKTIME, W1.PLANCASHFLOWSBACKTIME) IS NOT NULL
       AND NVL(W1.REALDEALTIME, W1.PLANDEALTIME) >=
           NVL(W1.REALPLANNINGTIME, W1.PLANNINGTIME)
       AND NVL(W1.REALSTARTTIME, W1.PLANSTARTTIME) >=
           NVL(W1.REALDEALTIME, W1.PLANDEALTIME)
       AND NVL(W1.REALPLANTIME, W1.PLANTIME) >=
           NVL(W1.REALDEALTIME, W1.PLANDEALTIME)
       AND NVL(W1.REALDEMONSTRATIONTIME, W1.PLANDEMONSTRATIONTIME) >=
           NVL(W1.REALDEALTIME, W1.PLANDEALTIME)
       AND NVL(W1.REALOPENINGTIME, W1.PLANOPENINGTIME) >=
           NVL(W1.REALDEALTIME, W1.PLANDEALTIME)
       AND NVL(W1.REALCASHFLOWSBACKTIME, W1.PLANCASHFLOWSBACKTIME) >=
           NVL(W1.REALDEALTIME, W1.PLANDEALTIME))*/
  SELECT O.ORG_CLASSIFY, W2.*, BEGIN_DATE
    FROM W2
    LEFT JOIN DIM_ORG O
      ON W2.AREAID = O.ORG_ID  ;
      
    COMMIT;
   /*
      处理日志
    */
    ERR_MSG  := '存储过程'||SPNAME||'-'||SPCONTENT||' 执行成功！';
    
    
    status := 0;
  
  
    INSERT INTO etl_log
      (BEGINDATE, ENDDATE, SPNAME,STATUS,ERROR_CD, ERRCODE, ERRMSG, TRANDATE)
    VALUES
      (SYSDATE, SYSDATE,SPNAME, '0',ERROR_CD, ERR_CODE, ERR_MSG, SYSDATE);  --状态为0-成功 1-失败
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
      status := 1;
/*      error_info :=SQLCODE;*/
      ERR_CODE := SQLCODE;
      ERR_MSG  := '存储过程'||SPNAME||'-'||SPCONTENT||'('|| dbms_utility.format_error_backtrace ||'):'||' 数据失败：' || SQLERRM;
      --记录日志
      INSERT INTO etl_log
      (BEGINDATE, ENDDATE, SPNAME,STATUS, ERROR_CD,ERRCODE, ERRMSG, TRANDATE)
    VALUES
      (SYSDATE, SYSDATE,SPNAME, '1',ERROR_CD, ERR_CODE, ERR_MSG, SYSDATE);  --状态为0-成功 1-失败
    COMMIT;

END;
/
