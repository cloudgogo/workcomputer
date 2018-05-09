SELECT T.SEG1,
       T.SEG2,
       T.ROW_NUM,
       T.ROW_NAME,
       T.PERIOD_END+NVL(T.PERIOD_UNPOSTED,0) PERIOD_END,--本期末+本期未过账
       T.PERIOD_AMT+NVL(T.PERIOD_UNPOSTED,0) PERIOD_AMT --本期发生+本期未过账
  FROM (select V.PARENT_VALUE SEG1,
               V2.PARENT_VALUE SEG2,
               R.ROW_NUM,
               R.ROW_NAME,
               R.LINE_NUM,
               SUM(DECODE(R.CHANGE_SIGN, 'Y', -1, 1) *
                   DECODE(C.SIGN, '+', 1, -1) * DECODE(IC.SIGN, '+', 1, -1) *
                   (NVL(GB2.BEGIN_BALANCE_DR, 0) -
                    NVL(GB2.BEGIN_BALANCE_CR, 0) + NVL(GB2.PERIOD_NET_DR, 0) -
                    NVL(GB2.PERIOD_NET_CR, 0))) PERIOD_END,
               SUM(DECODE(R.CHANGE_SIGN, 'Y', -1, 1) *
                   DECODE(C.SIGN, '+', 1, -1) * DECODE(IC.SIGN, '+', 1, -1) *
                   (NVL(GB2.PERIOD_NET_DR, 0) - NVL(GB2.PERIOD_NET_CR, 0))) PERIOD_AMT,
               SUM(DECODE(R.CHANGE_SIGN, 'Y', -1, 1) *
                   DECODE(C.SIGN, '+', 1, -1) * DECODE(IC.SIGN, '+', 1, -1) *
                   NVL(GJ.ENTERED_AMT, 0)) PERIOD_UNPOSTED
          FROM CUX.CUX_HRS_DEF_ROW_SET S,
               CUX.CUX_HRS_DEF_ROW R,
               CUX.CUX_HRS_DEF_ROW_CALCULATION C,
               CUX.CUX_HRS_DEF_ITEM_CONTENT IC,
               apps.gl_code_combinations GCC,
               apps.gl_ledgers gl,
               apps.CUX_HRS_CORE_DIM_CHILD_V V,
               apps.CUX_HRS_CORE_DIM_CHILD_V V2,
               CUX.CUX_HRS_ITEM_CONTENT_RANGE ICR,
               apps.gl_balances gb2,
               (SELECT jl.code_combination_id,
                       SUM(NVL(ACCOUNTED_DR,0) - NVL(ACCOUNTED_CR,0)) ENTERED_AMT   --取所有币种折算成本位币的金额
                  FROM apps.gl_je_headers jh, apps.gl_je_lines jl
                 WHERE 1 = 1
                   and jh.je_header_id = jl.je_header_id
                   and jh.ledger_id = 1001
                   and jh.period_name = '2018-05'
                   and jh.actual_flag = 'A'
                   and jl.period_name = jh.period_name
                   AND jl.status != 'P'
                  -- and decode('${P_INCLUDE_UNPOSTED}', 'Y', 1, 0) = 1
                 GROUP BY jl.code_combination_id) GJ
        
         WHERE S.ROW_SET_NAME = 'P100V1'
           AND S.ROW_SET_ID = R.ROW_SET_ID
           AND R.DISPLAY_FLAG = 'Y'
           AND R.ROW_ID = C.ROW_ID
           AND C.CAL_ITEM_CODE = IC.ITEM_CODE
           and gl.ledger_id = 1001
           AND IC.ITEM_CONTENT_ID = ICR.ITEM_CONTENT_ID
           AND GCC.SEGMENT1 between NVL(ICR.SEGMENT1_LOW, GCC.SEGMENT1)
           AND NVL(ICR.SEGMENT1_HIGH, GCC.SEGMENT1)
           AND GCC.SEGMENT2 between NVL(ICR.SEGMENT2_LOW, GCC.SEGMENT2)
           AND NVL(ICR.SEGMENT2_HIGH, GCC.SEGMENT2)
           AND GCC.SEGMENT3 between NVL(ICR.SEGMENT3_LOW, GCC.SEGMENT3)
           AND NVL(ICR.SEGMENT3_HIGH, GCC.SEGMENT3)
           AND GCC.SEGMENT8 between NVL(ICR.SEGMENT8_LOW, GCC.SEGMENT8)
           AND NVL(ICR.SEGMENT8_HIGH, GCC.SEGMENT8)
           AND GCC.CHART_OF_ACCOUNTS_ID = gl.CHART_OF_ACCOUNTS_ID
           and gcc.enabled_flag = 'Y'
           and gcc.summary_flag = 'N'
           AND V.PARENT_VALUE IN ('130101')
           AND V.DIM_SEGMENT = 'SEGMENT1'
           AND GCC.SEGMENT1 = V.DIM_VALUE
           AND V2.DIM_SEGMENT = 'SEGMENT2'
           AND GCC.SEGMENT2 = V2.DIM_VALUE
           AND V2.PARENT_VALUE IN ('T')
           and gb2.ledger_id(+) = 1001
           and gb2.code_combination_id(+) = GCC.code_combination_id
           and gb2.currency_code(+) = 'CNY'
           and gb2.period_name(+) = '2018-05'
           and gb2.actual_flag(+) = 'A'
           AND GJ.code_combination_id(+) = GCC.code_combination_id
         GROUP BY V.PARENT_VALUE,V2.PARENT_VALUE, R.ROW_NUM, R.ROW_NAME,
               R.LINE_NUM) T;
select result.segment1 SEG1,
       result.segment2 SEG2,
       result.ROW_NUM,
       result.ROW_NAME,
       sum(amount) PERIOD_END,
       sum(sumamount) PERIOD_AMT
  from (select l.segment1,
               l.segment2,
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
               apps.CUX_HRS_CORE_DIM_CHILD_V   V,
               apps.CUX_HRS_CORE_DIM_CHILD_V   V2
         where S.ROW_SET_NAME = 'P100V1'
           AND S.ROW_SET_ID = R.ROW_SET_ID
           AND R.DISPLAY_FLAG = 'Y'
           AND R.ROW_ID = C.ROW_ID
           AND C.CAL_ITEM_CODE = IC.ITEM_CODE
           and h.header_id = l.header_id
           and l.segment1 between nvl(ic.segment1_low, l.segment1) and
               nvl(ic.segment1_high, l.segment1)
           and l.segment2 between nvl(ic.segment2_low, l.segment2) and
               nvl(ic.segment2_high, l.segment2)
           and l.segment3 between nvl(ic.segment3_low, l.segment3) and
               nvl(ic.segment3_high, l.segment3)
           and l.segment8 between nvl(ic.segment8_low, l.segment8) and
               nvl(ic.segment8_high, l.segment8)
           AND V.PARENT_VALUE IN ('130101')
           AND H.LEDGER_ID = 1001
           AND V.DIM_SEGMENT = 'SEGMENT1'
           AND L.SEGMENT1 = V.DIM_VALUE
           AND V2.DIM_SEGMENT = 'SEGMENT2'
           AND L.SEGMENT2 = V2.DIM_VALUE
           AND V2.PARENT_VALUE IN ('T')
           and l.fin_element='2010'
           and h.period_name = '2018-05'
           AND H.CURRENCY_CODE = 'CNY'
        union all
        select l.segment1,
               l.segment2,
               R.ROW_NUM,
               R.ROW_NAME,
               R.LINE_NUM,
               0 amount,
               sum(NVL(l.accounted_dr, 0) - NVL(l.accounted_cr, 0)) sumamount
          from CUX.CUX_HRS_DEF_ROW_SET         S,
               CUX.CUX_HRS_DEF_ROW             R,
               CUX.CUX_HRS_DEF_ROW_CALCULATION C,
               CUX.CUX_HRS_DEF_ITEM_CONTENT    IC,
               hrs_core_je_header              h,
               hrs_core_je_line                l,
               apps.CUX_HRS_CORE_DIM_CHILD_V   V,
               apps.CUX_HRS_CORE_DIM_CHILD_V   V2
         where S.ROW_SET_NAME = 'P100V1'
           AND S.ROW_SET_ID = R.ROW_SET_ID
           AND R.DISPLAY_FLAG = 'Y'
           AND R.ROW_ID = C.ROW_ID
           AND C.CAL_ITEM_CODE = IC.ITEM_CODE
           and h.header_id = l.header_id
           and l.segment1 between nvl(ic.segment1_low, l.segment1) and
               nvl(ic.segment1_high, l.segment1)
           and l.segment2 between nvl(ic.segment2_low, l.segment2) and
               nvl(ic.segment2_high, l.segment2)
           and l.segment3 between nvl(ic.segment3_low, l.segment3) and
               nvl(ic.segment3_high, l.segment3)
           and l.segment8 between nvl(ic.segment8_low, l.segment8) and
               nvl(ic.segment8_high, l.segment8)
           AND V.PARENT_VALUE IN ('T')
           AND H.LEDGER_ID = 1001
           AND V.DIM_SEGMENT = 'SEGMENT1'
           AND L.SEGMENT1 = V.DIM_VALUE
           AND V2.DIM_SEGMENT = 'SEGMENT2'
           AND L.SEGMENT2 = V2.DIM_VALUE
           and l.fin_element='2010'
           AND V2.PARENT_VALUE IN ('T')
           and h.period_name between substr('2018-05',1,4)||'-01' and '2018-05'
           AND H.CURRENCY_CODE = 'CNY'
         group by l.segment1, l.segment2, R.ROW_NUM, R.ROW_NAME, R.LINE_NUM
        
        ) result
 group by result.segment1,
          result.segment2,
          result.ROW_NUM,
          result.ROW_NAME,
          result.LINE_NUM;              
          

SELECT T.SEG1,
       T.SEG2,
       T.ROW_NUM,
       T.ROW_NAME,
       T.PERIOD_END+NVL(T.PERIOD_UNPOSTED,0) PERIOD_END,--本期末+本期未过账
       T.PERIOD_AMT+NVL(T.PERIOD_UNPOSTED,0) PERIOD_AMT --本期发生+本期未过账
  FROM (select V.PARENT_VALUE SEG1,
               V2.PARENT_VALUE SEG2,
               R.ROW_NUM,
               R.ROW_NAME,
               R.LINE_NUM,
               SUM(DECODE(R.CHANGE_SIGN, 'Y', -1, 1) *
                   DECODE(C.SIGN, '+', 1, -1) * DECODE(IC.SIGN, '+', 1, -1) *
                   (NVL(GB2.BEGIN_BALANCE_DR, 0) -
                    NVL(GB2.BEGIN_BALANCE_CR, 0) + NVL(GB2.PERIOD_NET_DR, 0) -
                    NVL(GB2.PERIOD_NET_CR, 0))) PERIOD_END,
               SUM(DECODE(R.CHANGE_SIGN, 'Y', -1, 1) *
                   DECODE(C.SIGN, '+', 1, -1) * DECODE(IC.SIGN, '+', 1, -1) *
                   (NVL(GB2.PERIOD_NET_DR, 0) - NVL(GB2.PERIOD_NET_CR, 0))) PERIOD_AMT,
               SUM(DECODE(R.CHANGE_SIGN, 'Y', -1, 1) *
                   DECODE(C.SIGN, '+', 1, -1) * DECODE(IC.SIGN, '+', 1, -1) *
                   NVL(GJ.ENTERED_AMT, 0)) PERIOD_UNPOSTED
          FROM CUX.CUX_HRS_DEF_ROW_SET S,
               CUX.CUX_HRS_DEF_ROW R,
               CUX.CUX_HRS_DEF_ROW_CALCULATION C,
               CUX.CUX_HRS_DEF_ITEM_CONTENT IC,
               apps.gl_code_combinations GCC,
               apps.gl_ledgers gl,
               apps.CUX_HRS_CORE_DIM_CHILD_V V,
               apps.CUX_HRS_CORE_DIM_CHILD_V V2,
               CUX.CUX_HRS_ITEM_CONTENT_RANGE ICR,
               apps.gl_balances gb2,
               (SELECT jl.code_combination_id,
                       SUM(NVL(ACCOUNTED_DR,0) - NVL(ACCOUNTED_CR,0)) ENTERED_AMT   --取所有币种折算成本位币的金额
                  FROM apps.gl_je_headers jh, apps.gl_je_lines jl
                 WHERE 1 = 1
                   and jh.je_header_id = jl.je_header_id
                   and jh.ledger_id = 1001
                   and jh.period_name = '2018-05'
                   and jh.actual_flag = 'A'
                   and jl.period_name = jh.period_name
                   AND jl.status != 'P'
                  -- and decode('${P_INCLUDE_UNPOSTED}', 'Y', 1, 0) = 1
                 GROUP BY jl.code_combination_id) GJ
        
         WHERE S.ROW_SET_NAME = 'P100V1'
           AND S.ROW_SET_ID = R.ROW_SET_ID
           AND R.DISPLAY_FLAG = 'Y'
           AND R.ROW_ID = C.ROW_ID
           AND C.CAL_ITEM_CODE = IC.ITEM_CODE
           and gl.ledger_id = 1001
           AND IC.ITEM_CONTENT_ID = ICR.ITEM_CONTENT_ID
           AND GCC.SEGMENT1 between NVL(ICR.SEGMENT1_LOW, GCC.SEGMENT1)
           AND NVL(ICR.SEGMENT1_HIGH, GCC.SEGMENT1)
           AND GCC.SEGMENT2 between NVL(ICR.SEGMENT2_LOW, GCC.SEGMENT2)
           AND NVL(ICR.SEGMENT2_HIGH, GCC.SEGMENT2)
           AND GCC.SEGMENT3 between NVL(ICR.SEGMENT3_LOW, GCC.SEGMENT3)
           AND NVL(ICR.SEGMENT3_HIGH, GCC.SEGMENT3)
           AND GCC.SEGMENT8 between NVL(ICR.SEGMENT8_LOW, GCC.SEGMENT8)
           AND NVL(ICR.SEGMENT8_HIGH, GCC.SEGMENT8)
           AND GCC.CHART_OF_ACCOUNTS_ID = gl.CHART_OF_ACCOUNTS_ID
           and gcc.enabled_flag = 'Y'
           and gcc.summary_flag = 'N'
           AND V.PARENT_VALUE IN ('130101')
           AND V.DIM_SEGMENT = 'SEGMENT1'
           AND GCC.SEGMENT1 = V.DIM_VALUE
           AND V2.DIM_SEGMENT = 'SEGMENT2'
           AND GCC.SEGMENT2 = V2.DIM_VALUE
           AND V2.PARENT_VALUE IN ('T')
           and gb2.ledger_id(+) = 1001
           and gb2.code_combination_id(+) = GCC.code_combination_id
           and gb2.currency_code(+) = 'CNY'
           and gb2.period_name(+) = '2018-05'
           and gb2.actual_flag(+) = 'A'
           AND GJ.code_combination_id(+) = GCC.code_combination_id
         GROUP BY V.PARENT_VALUE,V2.PARENT_VALUE, R.ROW_NUM, R.ROW_NAME,
               R.LINE_NUM) T

UNION ALL
select result.segment1 SEG1,
       result.segment2 SEG2,
       result.ROW_NUM,
       result.ROW_NAME,
       sum(amount) PERIOD_END,
       sum(sumamount) PERIOD_AMT
  from (select l.segment1,
               l.segment2,
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
               apps.CUX_HRS_CORE_DIM_CHILD_V   V,
               apps.CUX_HRS_CORE_DIM_CHILD_V   V2
         where S.ROW_SET_NAME = 'P100V1'
           AND S.ROW_SET_ID = R.ROW_SET_ID
           AND R.DISPLAY_FLAG = 'Y'
           AND R.ROW_ID = C.ROW_ID
           AND C.CAL_ITEM_CODE = IC.ITEM_CODE
           and h.header_id = l.header_id
           and l.segment1 between nvl(ic.segment1_low, l.segment1) and
               nvl(ic.segment1_high, l.segment1)
           and l.segment2 between nvl(ic.segment2_low, l.segment2) and
               nvl(ic.segment2_high, l.segment2)
           and l.segment3 between nvl(ic.segment3_low, l.segment3) and
               nvl(ic.segment3_high, l.segment3)
           and l.segment8 between nvl(ic.segment8_low, l.segment8) and
               nvl(ic.segment8_high, l.segment8)
           AND V.PARENT_VALUE IN ('130101')
           AND H.LEDGER_ID = 1001
           AND V.DIM_SEGMENT = 'SEGMENT1'
           AND L.SEGMENT1 = V.DIM_VALUE
           AND V2.DIM_SEGMENT = 'SEGMENT2'
           AND L.SEGMENT2 = V2.DIM_VALUE
           AND V2.PARENT_VALUE IN ('T')
           and l.fin_element='2010'
           and h.period_name = '2018-05'
           AND H.CURRENCY_CODE = 'CNY'
        union all
        select l.segment1,
               l.segment2,
               R.ROW_NUM,
               R.ROW_NAME,
               R.LINE_NUM,
               0 amount,
               sum(NVL(l.accounted_dr, 0) - NVL(l.accounted_cr, 0)) sumamount
          from CUX.CUX_HRS_DEF_ROW_SET         S,
               CUX.CUX_HRS_DEF_ROW             R,
               CUX.CUX_HRS_DEF_ROW_CALCULATION C,
               CUX.CUX_HRS_DEF_ITEM_CONTENT    IC,
               hrs_core_je_header              h,
               hrs_core_je_line                l,
               apps.CUX_HRS_CORE_DIM_CHILD_V   V,
               apps.CUX_HRS_CORE_DIM_CHILD_V   V2
         where S.ROW_SET_NAME = 'P100V1'
           AND S.ROW_SET_ID = R.ROW_SET_ID
           AND R.DISPLAY_FLAG = 'Y'
           AND R.ROW_ID = C.ROW_ID
           AND C.CAL_ITEM_CODE = IC.ITEM_CODE
           and h.header_id = l.header_id
           and l.segment1 between nvl(ic.segment1_low, l.segment1) and
               nvl(ic.segment1_high, l.segment1)
           and l.segment2 between nvl(ic.segment2_low, l.segment2) and
               nvl(ic.segment2_high, l.segment2)
           and l.segment3 between nvl(ic.segment3_low, l.segment3) and
               nvl(ic.segment3_high, l.segment3)
           and l.segment8 between nvl(ic.segment8_low, l.segment8) and
               nvl(ic.segment8_high, l.segment8)
           AND V.PARENT_VALUE IN ('T')
           AND H.LEDGER_ID = 1001
           AND V.DIM_SEGMENT = 'SEGMENT1'
           AND L.SEGMENT1 = V.DIM_VALUE
           AND V2.DIM_SEGMENT = 'SEGMENT2'
           AND L.SEGMENT2 = V2.DIM_VALUE
           and l.fin_element='2010'
           AND V2.PARENT_VALUE IN ('T')
           and h.period_name between substr('2018-05',1,4)||'-01' and '2018-05'
           AND H.CURRENCY_CODE = 'CNY'
         group by l.segment1, l.segment2, R.ROW_NUM, R.ROW_NAME, R.LINE_NUM
        
        ) result
 group by result.segment1,
          result.segment2,
          result.ROW_NUM,
          result.ROW_NAME,
          result.LINE_NUM

;
SELECT * FROM (

SELECT * FROM (SELECT T.SEG1,
       T.SEG2,
       T.ROW_NUM,
       T.ROW_NAME,
       T.PERIOD_END+NVL(T.PERIOD_UNPOSTED,0) PERIOD_END,--本期末+本期未过账
       T.PERIOD_AMT+NVL(T.PERIOD_UNPOSTED,0) PERIOD_AMT --本期发生+本期未过账
  FROM (select V.PARENT_VALUE SEG1,
               V2.PARENT_VALUE SEG2,
               R.ROW_NUM,
               R.ROW_NAME,
               R.LINE_NUM,
               SUM(DECODE(R.CHANGE_SIGN, 'Y', -1, 1) *
                   DECODE(C.SIGN, '+', 1, -1) * DECODE(IC.SIGN, '+', 1, -1) *
                   (NVL(GB2.BEGIN_BALANCE_DR, 0) -
                    NVL(GB2.BEGIN_BALANCE_CR, 0) + NVL(GB2.PERIOD_NET_DR, 0) -
                    NVL(GB2.PERIOD_NET_CR, 0))) PERIOD_END,
               SUM(DECODE(R.CHANGE_SIGN, 'Y', -1, 1) *
                   DECODE(C.SIGN, '+', 1, -1) * DECODE(IC.SIGN, '+', 1, -1) *
                   (NVL(GB2.PERIOD_NET_DR, 0) - NVL(GB2.PERIOD_NET_CR, 0))) PERIOD_AMT,
               SUM(DECODE(R.CHANGE_SIGN, 'Y', -1, 1) *
                   DECODE(C.SIGN, '+', 1, -1) * DECODE(IC.SIGN, '+', 1, -1) *
                   NVL(GJ.ENTERED_AMT, 0)) PERIOD_UNPOSTED
          FROM CUX.CUX_HRS_DEF_ROW_SET S,
               CUX.CUX_HRS_DEF_ROW R,
               CUX.CUX_HRS_DEF_ROW_CALCULATION C,
               CUX.CUX_HRS_DEF_ITEM_CONTENT IC,
               apps.gl_code_combinations GCC,
               apps.gl_ledgers gl,
               apps.CUX_HRS_CORE_DIM_CHILD_V V,
               apps.CUX_HRS_CORE_DIM_CHILD_V V2,
               CUX.CUX_HRS_ITEM_CONTENT_RANGE ICR,
               apps.gl_balances gb2,
               (SELECT jl.code_combination_id,
                       SUM(NVL(ACCOUNTED_DR,0) - NVL(ACCOUNTED_CR,0)) ENTERED_AMT   --取所有币种折算成本位币的金额
                  FROM apps.gl_je_headers jh, apps.gl_je_lines jl
                 WHERE 1 = 1
                   and jh.je_header_id = jl.je_header_id
                   and jh.ledger_id = 1001
                   and jh.period_name = '2018-05'
                   and jh.actual_flag = 'A'
                   and jl.period_name = jh.period_name
                   AND jl.status != 'P'
                  -- and decode('${P_INCLUDE_UNPOSTED}', 'Y', 1, 0) = 1
                 GROUP BY jl.code_combination_id) GJ
        
         WHERE S.ROW_SET_NAME = 'P100V1'
           AND S.ROW_SET_ID = R.ROW_SET_ID
           AND R.DISPLAY_FLAG = 'Y'
           AND R.ROW_ID = C.ROW_ID
           AND C.CAL_ITEM_CODE = IC.ITEM_CODE
           and gl.ledger_id = 1001
           AND IC.ITEM_CONTENT_ID = ICR.ITEM_CONTENT_ID
           AND GCC.SEGMENT1 between NVL(ICR.SEGMENT1_LOW, GCC.SEGMENT1)
           AND NVL(ICR.SEGMENT1_HIGH, GCC.SEGMENT1)
           AND GCC.SEGMENT2 between NVL(ICR.SEGMENT2_LOW, GCC.SEGMENT2)
           AND NVL(ICR.SEGMENT2_HIGH, GCC.SEGMENT2)
           AND GCC.SEGMENT3 between NVL(ICR.SEGMENT3_LOW, GCC.SEGMENT3)
           AND NVL(ICR.SEGMENT3_HIGH, GCC.SEGMENT3)
           AND GCC.SEGMENT8 between NVL(ICR.SEGMENT8_LOW, GCC.SEGMENT8)
           AND NVL(ICR.SEGMENT8_HIGH, GCC.SEGMENT8)
           AND GCC.CHART_OF_ACCOUNTS_ID = gl.CHART_OF_ACCOUNTS_ID
           and gcc.enabled_flag = 'Y'
           and gcc.summary_flag = 'N'
           AND V.PARENT_VALUE IN ('130101')
           AND V.DIM_SEGMENT = 'SEGMENT1'
           AND GCC.SEGMENT1 = V.DIM_VALUE
           AND V2.DIM_SEGMENT = 'SEGMENT2'
           AND GCC.SEGMENT2 = V2.DIM_VALUE
           AND V2.PARENT_VALUE IN ('T')
           and gb2.ledger_id(+) = 1001
           and gb2.code_combination_id(+) = GCC.code_combination_id
           and gb2.currency_code(+) = 'CNY'
           and gb2.period_name(+) = '2018-05'
           and gb2.actual_flag(+) = 'A'
           AND GJ.code_combination_id(+) = GCC.code_combination_id
         GROUP BY V.PARENT_VALUE,V2.PARENT_VALUE, R.ROW_NUM, R.ROW_NAME,
               R.LINE_NUM) T)T

UNION ALL
select * from (
select result.segment1 SEG1,
       result.segment2 SEG2,
       result.ROW_NUM,
       result.ROW_NAME,
       sum(amount) PERIOD_END,
       sum(sumamount) PERIOD_AMT
  from (select l.segment1,
               l.segment2,
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
               apps.CUX_HRS_CORE_DIM_CHILD_V   V,
               apps.CUX_HRS_CORE_DIM_CHILD_V   V2
         where S.ROW_SET_NAME = 'P100V1'
           AND S.ROW_SET_ID = R.ROW_SET_ID
           AND R.DISPLAY_FLAG = 'Y'
           AND R.ROW_ID = C.ROW_ID
           AND C.CAL_ITEM_CODE = IC.ITEM_CODE
           and h.header_id = l.header_id
           and l.segment1 between nvl(ic.segment1_low, l.segment1) and
               nvl(ic.segment1_high, l.segment1)
           and l.segment2 between nvl(ic.segment2_low, l.segment2) and
               nvl(ic.segment2_high, l.segment2)
           and l.segment3 between nvl(ic.segment3_low, l.segment3) and
               nvl(ic.segment3_high, l.segment3)
           and l.segment8 between nvl(ic.segment8_low, l.segment8) and
               nvl(ic.segment8_high, l.segment8)
           AND V.PARENT_VALUE IN ('130101')
           AND H.LEDGER_ID = 1001
           AND V.DIM_SEGMENT = 'SEGMENT1'
           AND L.SEGMENT1 = V.DIM_VALUE
           AND V2.DIM_SEGMENT = 'SEGMENT2'
           AND L.SEGMENT2 = V2.DIM_VALUE
           AND V2.PARENT_VALUE IN ('T')
           and l.fin_element='2010'
           and h.period_name = '2018-05'
           AND H.CURRENCY_CODE = 'CNY'
        union all
        select l.segment1,
               l.segment2,
               R.ROW_NUM,
               R.ROW_NAME,
               R.LINE_NUM,
               0 amount,
               sum(NVL(l.accounted_dr, 0) - NVL(l.accounted_cr, 0)) sumamount
          from CUX.CUX_HRS_DEF_ROW_SET         S,
               CUX.CUX_HRS_DEF_ROW             R,
               CUX.CUX_HRS_DEF_ROW_CALCULATION C,
               CUX.CUX_HRS_DEF_ITEM_CONTENT    IC,
               hrs_core_je_header              h,
               hrs_core_je_line                l,
               apps.CUX_HRS_CORE_DIM_CHILD_V   V,
               apps.CUX_HRS_CORE_DIM_CHILD_V   V2
         where S.ROW_SET_NAME = 'P100V1'
           AND S.ROW_SET_ID = R.ROW_SET_ID
           AND R.DISPLAY_FLAG = 'Y'
           AND R.ROW_ID = C.ROW_ID
           AND C.CAL_ITEM_CODE = IC.ITEM_CODE
           and h.header_id = l.header_id
           and l.segment1 between nvl(ic.segment1_low, l.segment1) and
               nvl(ic.segment1_high, l.segment1)
           and l.segment2 between nvl(ic.segment2_low, l.segment2) and
               nvl(ic.segment2_high, l.segment2)
           and l.segment3 between nvl(ic.segment3_low, l.segment3) and
               nvl(ic.segment3_high, l.segment3)
           and l.segment8 between nvl(ic.segment8_low, l.segment8) and
               nvl(ic.segment8_high, l.segment8)
           AND V.PARENT_VALUE IN ('T')
           AND H.LEDGER_ID = 1001
           AND V.DIM_SEGMENT = 'SEGMENT1'
           AND L.SEGMENT1 = V.DIM_VALUE
           AND V2.DIM_SEGMENT = 'SEGMENT2'
           AND L.SEGMENT2 = V2.DIM_VALUE
           and l.fin_element='2010'
           AND V2.PARENT_VALUE IN ('T')
           and h.period_name between substr('2018-05',1,4)||'-01' and '2018-05'
           AND H.CURRENCY_CODE = 'CNY'
         group by l.segment1, l.segment2, R.ROW_NUM, R.ROW_NAME, R.LINE_NUM
        
        ) result
 group by result.segment1,
          result.segment2,
          result.ROW_NUM,
          result.ROW_NAME,
          result.LINE_NUM)T)RESULT