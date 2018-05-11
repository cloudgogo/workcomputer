select *
  from CUX_HRS_CORE_DIM_CHILD_V
 where dim_segment = 'SEGMENT2'
   AND PARENT_VALUE = '131136'

;
SELECT R.ROW_ID,
       R.ATTRIBUTE1     LEDGER_ID,
       R.ATTRIBUTE2     COM1,
       IC.SEGMENT1_LOW,
       IC.SEGMENT1_HIGH,
       IC.SEGMENT2_LOW,
       IC.SEGMENT2_HIGH,
       R.ATTRIBUTE3     COM2,
       R.ATTRIBUTE4     COM4,
       R.ATTRIBUTE4
  FROM CUX.CUX_HRS_DEF_ROW_SET         RS,
       CUX.CUX_HRS_DEF_ROW             R,
       CUX.CUX_HRS_DEF_ROW_CALCULATION C,
       CUX.CUX_HRS_DEF_ITEM_HEADER     H,
       CUX.CUX_HRS_DEF_ITEM_CONTENT    IC
 WHERE RS.ROW_SET_NAME = 'ORG_P200V1'
   AND RS.ROW_SET_ID = R.ROW_SET_ID
   AND C.ROW_ID = R.ROW_ID
   AND R.DISPLAY_FLAG = 'Y'
   AND C.CAL_ITEM_CODE = H.ITEM_CODE
   AND H.ITEM_HEADER_ID = IC.ITEM_HEADER_ID
   AND R.ATTRIBUTE1 = 1001
   AND R.ATTRIBUTE2 IN ('130101')
   AND R.ATTRIBUTE3 IN ('131136')

;
SELECT RESULT.SEG1,
       RESULT.SEG2,
       RESULT.ROW_NUM,
       RESULT.ROW_NAME,
       SUM(PERIOD_END) PERIOD_END,
       SUM(PERIOD_AMT) PERIOD_AMT
  FROM (select *
          from (SELECT T.SEG1,
                       T.SEG2,
                       T.ROW_NUM,
                       T.ROW_NAME,
                       T.PERIOD_END + NVL(T.PERIOD_UNPOSTED, 0) PERIOD_END, --本期末+本期未过账
                       T.PERIOD_AMT + NVL(T.PERIOD_UNPOSTED, 0) PERIOD_AMT --本期发生+本期未过账
                  FROM (select
                        
                         V.COM1 SEG1,
                         V.COM2 SEG2,
                         
                         R.ROW_NUM,
                         R.ROW_NAME,
                         R.LINE_NUM,
                         SUM(DECODE(R.CHANGE_SIGN, 'Y', -1, 1) *
                             DECODE(C.SIGN, '+', 1, -1) *
                             DECODE(IC.SIGN, '+', 1, -1) *
                             (NVL(GB2.BEGIN_BALANCE_DR, 0) -
                              NVL(GB2.BEGIN_BALANCE_CR, 0) +
                              NVL(GB2.PERIOD_NET_DR, 0) -
                              NVL(GB2.PERIOD_NET_CR, 0))) PERIOD_END,
                         SUM(DECODE(R.CHANGE_SIGN, 'Y', -1, 1) *
                             DECODE(C.SIGN, '+', 1, -1) *
                             DECODE(IC.SIGN, '+', 1, -1) *
                             (NVL(GB2.PERIOD_NET_DR, 0) -
                              NVL(GB2.PERIOD_NET_CR, 0))) PERIOD_AMT,
                         SUM(DECODE(R.CHANGE_SIGN, 'Y', -1, 1) *
                             DECODE(C.SIGN, '+', 1, -1) *
                             DECODE(IC.SIGN, '+', 1, -1) *
                             NVL(GJ.ENTERED_AMT, 0)) PERIOD_UNPOSTED
                          FROM CUX.CUX_HRS_DEF_ROW_SET         S,
                               CUX.CUX_HRS_DEF_ROW             R,
                               CUX.CUX_HRS_DEF_ROW_CALCULATION C,
                               CUX.CUX_HRS_DEF_ITEM_CONTENT    IC,
                               apps.gl_code_combinations       GCC,
                               apps.gl_ledgers                 gl,
                               
                               --apps.CUX_HRS_CORE_DIM_CHILD_V V,
                               --apps.CUX_HRS_CORE_DIM_CHILD_V V2,
                               (SELECT R.ROW_ID,
                                       R.ATTRIBUTE1     LEDGER_ID,
                                       R.ATTRIBUTE2     COM1,
                                       IC.SEGMENT1_LOW,
                                       IC.SEGMENT1_HIGH,
                                       IC.SEGMENT2_LOW,
                                       IC.SEGMENT2_HIGH,
                                       R.ATTRIBUTE3     COM2,
                                       R.ATTRIBUTE4     COM4,
                                       R.ATTRIBUTE4
                                  FROM CUX.CUX_HRS_DEF_ROW_SET         RS,
                                       CUX.CUX_HRS_DEF_ROW             R,
                                       CUX.CUX_HRS_DEF_ROW_CALCULATION C,
                                       CUX.CUX_HRS_DEF_ITEM_HEADER     H,
                                       CUX.CUX_HRS_DEF_ITEM_CONTENT    IC
                                 WHERE RS.ROW_SET_NAME = 'ORG_P200V1'
                                   AND RS.ROW_SET_ID = R.ROW_SET_ID
                                   AND C.ROW_ID = R.ROW_ID
                                   AND R.DISPLAY_FLAG = 'Y'
                                   AND C.CAL_ITEM_CODE = H.ITEM_CODE
                                   AND H.ITEM_HEADER_ID = IC.ITEM_HEADER_ID
                                   AND R.ATTRIBUTE1 = 1001
                                   AND R.ATTRIBUTE2 IN ('130101')
                                   AND R.ATTRIBUTE3 IN ('131136')) V,
                               
                               CUX.CUX_HRS_ITEM_CONTENT_RANGE ICR,
                               apps.gl_balances gb2,
                               (SELECT jl.code_combination_id,
                                       SUM(NVL(ACCOUNTED_DR, 0) -
                                           NVL(ACCOUNTED_CR, 0)) ENTERED_AMT --取所有币种折算成本位币的金额
                                  FROM apps.gl_je_headers jh,
                                       apps.gl_je_lines   jl
                                 WHERE 1 = 1
                                   and jh.je_header_id = jl.je_header_id
                                   and jh.ledger_id = 1001
                                   and jh.period_name = '2018-04'
                                   and jh.actual_flag = 'A'
                                   and jl.period_name = jh.period_name
                                   AND jl.status != 'P'
                                   /*and decode('${P_INCLUDE_UNPOSTED}',
                                              'Y',
                                              1,
                                              0) = 1*/
                                 GROUP BY jl.code_combination_id) GJ
                        
                         WHERE S.ROW_SET_NAME = 'P100V1'
                           AND S.ROW_SET_ID = R.ROW_SET_ID
                           AND R.DISPLAY_FLAG = 'Y'
                           AND R.ROW_ID = C.ROW_ID
                           AND C.CAL_ITEM_CODE = IC.ITEM_CODE
                           and gl.ledger_id = 1001
                           AND IC.ITEM_CONTENT_ID = ICR.ITEM_CONTENT_ID
                           AND GCC.SEGMENT1 between
                               NVL(ICR.SEGMENT1_LOW, GCC.SEGMENT1) AND
                               NVL(ICR.SEGMENT1_HIGH, GCC.SEGMENT1)
                           AND GCC.SEGMENT2 between
                               NVL(ICR.SEGMENT2_LOW, GCC.SEGMENT2) AND
                               NVL(ICR.SEGMENT2_HIGH, GCC.SEGMENT2)
                           AND GCC.SEGMENT3 between
                               NVL(ICR.SEGMENT3_LOW, GCC.SEGMENT3) AND
                               NVL(ICR.SEGMENT3_HIGH, GCC.SEGMENT3)
                           AND GCC.SEGMENT8 between
                               NVL(ICR.SEGMENT8_LOW, GCC.SEGMENT8) AND
                               NVL(ICR.SEGMENT8_HIGH, GCC.SEGMENT8)
                           AND GCC.CHART_OF_ACCOUNTS_ID =
                               gl.CHART_OF_ACCOUNTS_ID
                           and gcc.enabled_flag = 'Y'
                           and gcc.summary_flag = 'N'
                              
                              /*                         AND V.PARENT_VALUE IN ('130101')
                              AND V.DIM_SEGMENT = 'SEGMENT1'
                              AND GCC.SEGMENT1 = V.DIM_VALUE
                              AND V2.DIM_SEGMENT = 'SEGMENT2'
                              AND GCC.SEGMENT2 = V2.DIM_VALUE
                              AND V2.PARENT_VALUE IN ('131136')*/
                           AND GCC.SEGMENT1 BETWEEN V.SEGMENT1_LOW AND
                               V.SEGMENT1_HIGH
                           AND GCC.SEGMENT2 BETWEEN V.SEGMENT2_LOW AND
                               V.SEGMENT2_HIGH
                              
                           and gb2.ledger_id(+) = 1001
                           and gb2.code_combination_id(+) =
                               GCC.code_combination_id
                           and gb2.currency_code(+) = 'CNY'
                           and gb2.period_name(+) = '2018-04'
                           and gb2.actual_flag(+) = 'A'
                           AND GJ.code_combination_id(+) =
                               GCC.code_combination_id
                           and '1000' in ('1000', '1010', '2010')
                        
                         GROUP BY -- UPDATE
                                   V.COM1,
                                  V.COM2,
                                  
                                  R.ROW_NUM,
                                  R.ROW_NAME,
                                  R.LINE_NUM) T) T
        
        UNION ALL
        SELECT *
          FROM (select result.segment1 SEG1,
                       result.segment2 SEG2,
                       result.ROW_NUM,
                       result.ROW_NAME,
                       sum(sumamount) PERIOD_END,
                       sum(amount) PERIOD_AMT
                  from (select
                        /* l.segment1,
                        l.segment2,*/
                        
                         V.COM1 segment1,
                         V.COM2 segment2,
                         
                         R.ROW_NUM,
                         R.ROW_NAME,
                         R.LINE_NUM,
                         NVL(l.accounted_dr, 0) - NVL(l.accounted_cr, 0) amount,
                         0 sumamount
                          from CUX.CUX_HRS_DEF_ROW_SET         S,
                               CUX.CUX_HRS_DEF_ROW             R,
                               CUX.CUX_HRS_DEF_ROW_CALCULATION C,
                               CUX.CUX_HRS_DEF_ITEM_CONTENT    IC,
                               hrs_core_je_header              h,
                               hrs_core_je_line                l,
                               
                               (SELECT R.ROW_ID,
                                       R.ATTRIBUTE1     LEDGER_ID,
                                       R.ATTRIBUTE2     COM1,
                                       IC.SEGMENT1_LOW,
                                       IC.SEGMENT1_HIGH,
                                       IC.SEGMENT2_LOW,
                                       IC.SEGMENT2_HIGH,
                                       R.ATTRIBUTE3     COM2,
                                       R.ATTRIBUTE4     COM4,
                                       R.ATTRIBUTE4
                                  FROM CUX.CUX_HRS_DEF_ROW_SET         RS,
                                       CUX.CUX_HRS_DEF_ROW             R,
                                       CUX.CUX_HRS_DEF_ROW_CALCULATION C,
                                       CUX.CUX_HRS_DEF_ITEM_HEADER     H,
                                       CUX.CUX_HRS_DEF_ITEM_CONTENT    IC
                                 WHERE RS.ROW_SET_NAME = 'ORG_P200V1'
                                   AND RS.ROW_SET_ID = R.ROW_SET_ID
                                   AND C.ROW_ID = R.ROW_ID
                                   AND R.DISPLAY_FLAG = 'Y'
                                   AND C.CAL_ITEM_CODE = H.ITEM_CODE
                                   AND H.ITEM_HEADER_ID = IC.ITEM_HEADER_ID
                                   AND R.ATTRIBUTE1 = 1001
                                   AND R.ATTRIBUTE2 IN ('130101')
                                   AND R.ATTRIBUTE3 IN ('131136')) V
                        /*  apps.CUX_HRS_CORE_DIM_CHILD_V   V,
                        apps.CUX_HRS_CORE_DIM_CHILD_V   V2*/
                         where S.ROW_SET_NAME = 'P100V1'
                           AND S.ROW_SET_ID = R.ROW_SET_ID
                           AND R.DISPLAY_FLAG = 'Y'
                           AND R.ROW_ID = C.ROW_ID
                           AND C.CAL_ITEM_CODE = IC.ITEM_CODE
                           and h.header_id = l.header_id
                           and l.segment1 between
                               nvl(ic.segment1_low, l.segment1) and
                               nvl(ic.segment1_high, l.segment1)
                           and l.segment2 between
                               nvl(ic.segment2_low, l.segment2) and
                               nvl(ic.segment2_high, l.segment2)
                           and l.segment3 between
                               nvl(ic.segment3_low, l.segment3) and
                               nvl(ic.segment3_high, l.segment3)
                           and l.segment8 between
                               nvl(ic.segment8_low, l.segment8) and
                               nvl(ic.segment8_high, l.segment8)
                              /*                          AND V.PARENT_VALUE IN ('130101')*/
                           AND H.LEDGER_ID = 1001
                              /*                          AND V.DIM_SEGMENT = 'SEGMENT1'
                              AND L.SEGMENT1 = V.DIM_VALUE
                              AND V2.DIM_SEGMENT = 'SEGMENT2'
                              AND L.SEGMENT2 = V2.DIM_VALUE
                              AND V2.PARENT_VALUE IN ('131136')*/
                              
                           AND l.SEGMENT1 BETWEEN V.SEGMENT1_LOW AND
                               V.SEGMENT1_HIGH
                           AND l.SEGMENT2 BETWEEN V.SEGMENT2_LOW AND
                               V.SEGMENT2_HIGH
                           and l.fin_element in ('1000', '1010', '2010')
                           and h.period_name = '2018-04'
                           AND H.CURRENCY_CODE = 'CNY'
                        union all
                        select V.COM1 segment1,
                               V.COM2 segment2,
                               
                               /*  l.segment1,
                               l.segment2,*/
                               R.ROW_NUM,
                               R.ROW_NAME,
                               R.LINE_NUM,
                               0 amount,
                               sum(NVL(l.accounted_dr, 0) -
                                   NVL(l.accounted_cr, 0)) sumamount
                          from CUX.CUX_HRS_DEF_ROW_SET         S,
                               CUX.CUX_HRS_DEF_ROW             R,
                               CUX.CUX_HRS_DEF_ROW_CALCULATION C,
                               CUX.CUX_HRS_DEF_ITEM_CONTENT    IC,
                               hrs_core_je_header              h,
                               hrs_core_je_line                l,
                               
                               (SELECT R.ROW_ID,
                                       R.ATTRIBUTE1     LEDGER_ID,
                                       R.ATTRIBUTE2     COM1,
                                       IC.SEGMENT1_LOW,
                                       IC.SEGMENT1_HIGH,
                                       IC.SEGMENT2_LOW,
                                       IC.SEGMENT2_HIGH,
                                       R.ATTRIBUTE3     COM2,
                                       R.ATTRIBUTE4     COM4,
                                       R.ATTRIBUTE4
                                  FROM CUX.CUX_HRS_DEF_ROW_SET         RS,
                                       CUX.CUX_HRS_DEF_ROW             R,
                                       CUX.CUX_HRS_DEF_ROW_CALCULATION C,
                                       CUX.CUX_HRS_DEF_ITEM_HEADER     H,
                                       CUX.CUX_HRS_DEF_ITEM_CONTENT    IC
                                 WHERE RS.ROW_SET_NAME = 'ORG_P200V1'
                                   AND RS.ROW_SET_ID = R.ROW_SET_ID
                                   AND C.ROW_ID = R.ROW_ID
                                   AND R.DISPLAY_FLAG = 'Y'
                                   AND C.CAL_ITEM_CODE = H.ITEM_CODE
                                   AND H.ITEM_HEADER_ID = IC.ITEM_HEADER_ID
                                   AND R.ATTRIBUTE1 = 1001
                                   AND R.ATTRIBUTE2 IN ('130101')
                                   AND R.ATTRIBUTE3 IN ('131136')) V
                        /*                        apps.CUX_HRS_CORE_DIM_CHILD_V   V,
                        apps.CUX_HRS_CORE_DIM_CHILD_V   V2*/
                         where S.ROW_SET_NAME = 'P100V1'
                           AND S.ROW_SET_ID = R.ROW_SET_ID
                           AND R.DISPLAY_FLAG = 'Y'
                           AND R.ROW_ID = C.ROW_ID
                           AND C.CAL_ITEM_CODE = IC.ITEM_CODE
                           and h.header_id = l.header_id
                           and l.segment1 between
                               nvl(ic.segment1_low, l.segment1) and
                               nvl(ic.segment1_high, l.segment1)
                           and l.segment2 between
                               nvl(ic.segment2_low, l.segment2) and
                               nvl(ic.segment2_high, l.segment2)
                           and l.segment3 between
                               nvl(ic.segment3_low, l.segment3) and
                               nvl(ic.segment3_high, l.segment3)
                           and l.segment8 between
                               nvl(ic.segment8_low, l.segment8) and
                               nvl(ic.segment8_high, l.segment8)
                              /*AND V.PARENT_VALUE IN ('130101')*/
                           AND H.LEDGER_ID = 1001
                              /*                           AND V.DIM_SEGMENT = 'SEGMENT1'
                              AND L.SEGMENT1 = V.DIM_VALUE
                              AND V2.DIM_SEGMENT = 'SEGMENT2'
                              AND L.SEGMENT2 = V2.DIM_VALUE*/
                           and l.fin_element in ('1000', '1010', '2010')
                              /*AND V2.PARENT_VALUE IN ('131136')*/
                           and h.period_name between
                               substr('2018-04', 1, 4) || '-01' and '2018-04'
                           AND H.CURRENCY_CODE = 'CNY'
                         group by /*l.segment1,
                                                                     l.segment2,*/
                                  V.COM1,
                                  V.COM2,
                                  
                                  R.ROW_NUM,
                                  R.ROW_NAME,
                                  R.LINE_NUM
                        
                        ) result
                 group by result.segment1,
                          result.segment2,
                          result.ROW_NUM,
                          result.ROW_NAME,
                          result.LINE_NUM) T) RESULT
 GROUP BY RESULT.SEG1, RESULT.SEG2, RESULT.ROW_NUM, RESULT.ROW_NAME
