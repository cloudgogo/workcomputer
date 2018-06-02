WITH DIM_DATEKJ AS
 (SELECT CASE
           WHEN &date = '当年' THEN
            PERIOD_YEAR
           WHEN &date = '当季' THEN
            PERIOD_QUARTER
           WHEN &date = '当月' THEN
            PERIOD_MONTH
         END AS CALIBER --找到我当前时间参数口径（当年、当季、当月）
    FROM DIM_PERIOD --时间维度
   WHERE PERIOD_KEY = to_char(sysdate - 1, 'yyyyMMdd')), --当前时间口径 年、季度、月份

DIM_DATEMX AS
 (SELECT DISTINCT CASE
                    WHEN &date = '当年' THEN
                     PERIOD_YEAR
                    WHEN &date = '当季' THEN
                     PERIOD_QUARTER
                    WHEN &date = '当月' THEN
                     PERIOD_MONTH
                  END AS DIM_CALIBER, --口径
                  CASE
                    WHEN &date = '当年' THEN
                     PERIOD_QUARTER
                    WHEN &date = '当季' THEN
                     PERIOD_MONTH
                    WHEN &date = '当月' THEN
                     WEEK_NBR_IN_MONTH
                  END AS DIM_CALIBER_S --口径2
    FROM DIM_PERIOD --时间维度
  ), --时间口径维度
DIM_DATES AS
 (SELECT CALIBER,
         CASE
           WHEN &date = '当年' THEN
            substr(CALIBER, 1, 4)
           WHEN &date = '当季' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'Q0' ||
            substr(CALIBER, 1, 1)
           WHEN &date = '当月' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(CALIBER, 1, 2)
         END as Statistical_time,
         1 ordernum
    FROM DIM_DATEKJ
  UNION ALL
  SELECT b.DIM_CALIBER_S as CALIBER,
         CASE
           WHEN &date = '当年' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'Q0' ||
            substr(b.DIM_CALIBER_S, 1, 1)
           WHEN &date = '当季' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(b.DIM_CALIBER_S, 1, 2)
           WHEN &date = '当月' THEN
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(to_char(sysdate - 1, 'yyyyMMdd'), 5, 2) || 'W' ||
            substr(b.DIM_CALIBER_S, 2, 1)
         END as Statistical_time,
         case when substr(b.DIM_CALIBER_S,2,1)='季' then cast (substr(b.DIM_CALIBER_S,1,1) as number)+1 
           when substr(b.DIM_CALIBER_S,3,1)='月' then cast (substr(b.DIM_CALIBER_S,1,2) as number)+1 
           when substr(b.DIM_CALIBER_S,3,1)='周' then cast (substr(b.DIM_CALIBER_S,2,1) as number)+1 
         end ordernum
    FROM DIM_DATEKJ a
    LEFT JOIN DIM_DATEMX b
      ON a.CALIBER = b.DIM_CALIBER) --整理时间维度
      select  *  from  DIM_DATES ;
      /*
  
  select * from  DIM_PERIOD
  select case when substr(p.period_month,3,1)='月' then cast (substr(p.period_month,1,2) as number) end a from DIM_PERIOD p*/
