SELECT T.SEG1,
       T.ROW_NUM,
       T.ROW_NAME,
       T.PERIOD_END+NVL(T.PERIOD_UNPOSTED,0) PERIOD_END,--本期末+本期未过账
       T.PERIOD_AMT+NVL(T.PERIOD_UNPOSTED,0) PERIOD_AMT --本期发生+本期未过账
  FROM (select V.PARENT_VALUE SEG1,
               R.ROW_NUM,
               R.ROW_NAME,
               R.LINE_NUM,
               SUM(DECODE(R.CHANGE_SIGN,
                          'Y',
                          DECODE(C.SIGN,
                                 '+',
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.BEGIN_BALANCE_DR, 0) -
                                         NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0)),
                                         -1 * (NVL(GB2.BEGIN_BALANCE_DR, 0) -
                                         NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0)))),
                                 -1 *
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.BEGIN_BALANCE_DR, 0) -
                                         NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0)),
                                         -1 * (NVL(GB2.BEGIN_BALANCE_DR, 0) -
                                         NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0))))) * (-1),
                          DECODE(C.SIGN,
                                 '+',
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.BEGIN_BALANCE_DR, 0) -
                                         NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0)),
                                         -1 * (NVL(GB2.BEGIN_BALANCE_DR, 0) -
                                         NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0)))),
                                 -1 *
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.BEGIN_BALANCE_DR, 0) -
                                         NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0)),
                                         -1 * (NVL(GB2.BEGIN_BALANCE_DR, 0) -
                                         NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0))))))) PERIOD_END,
               SUM(DECODE(R.CHANGE_SIGN,
                          'Y',
                          DECODE(C.SIGN,
                                 '+',
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0)),
                                         -1 * (NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0)))),
                                 -1 *
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0)),
                                         -1 * (NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0))))) * (-1),
                          DECODE(C.SIGN,
                                 '+',
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0)),
                                         -1 * (NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0)))),
                                 -1 *
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0)),
                                         -1 * (NVL(GB2.PERIOD_NET_DR, 0) -
                                         NVL(GB2.PERIOD_NET_CR, 0))))))) PERIOD_AMT,
               SUM(DECODE(R.CHANGE_SIGN,
                          'Y',
                          DECODE(C.SIGN,
                                 '+',
                                 (DECODE(IC.SIGN,
                                         '+',
                                         NVL(GJ.ENTERED_AMT, 0),
                                         -1 * NVL(GJ.ENTERED_AMT, 0))),
                                 -1 *
                                 (DECODE(IC.SIGN,
                                         '+',
                                         NVL(GJ.ENTERED_AMT, 0),
                                         -1 * NVL(GJ.ENTERED_AMT, 0)))) * (-1),
                          DECODE(C.SIGN,
                                 '+',
                                 (DECODE(IC.SIGN,
                                         '+',
                                         NVL(GJ.ENTERED_AMT, 0),
                                         -1 * NVL(GJ.ENTERED_AMT, 0))),
                                 -1 *
                                 (DECODE(IC.SIGN,
                                         '+',
                                         NVL(GJ.ENTERED_AMT, 0),
                                         -1 * NVL(GJ.ENTERED_AMT, 0)))))) PERIOD_UNPOSTED
          FROM CUX.CUX_HRS_DEF_ROW_SET S,
               CUX.CUX_HRS_DEF_ROW R,
               CUX.CUX_HRS_DEF_ROW_CALCULATION C,
               CUX.CUX_HRS_DEF_ITEM_CONTENT IC,
               apps.gl_code_combinations GCC,
               apps.gl_ledgers gl,
               apps.CUX_HRS_CORE_DIM_CHILD_V V,
               CUX.CUX_HRS_ITEM_CONTENT_RANGE ICR,
               apps.gl_balances gb2,
               (SELECT jl.code_combination_id,
                       SUM(NVL(ACCOUNTED_DR,0) - NVL(ACCOUNTED_CR,0)) ENTERED_AMT   --取所有币种折算成本位币的金额
                  FROM apps.gl_je_headers jh, apps.gl_je_lines jl
                 WHERE 1 = 1
                   and jh.je_header_id = jl.je_header_id
                   and jh.ledger_id = ${P_LEDGER}
                   and jh.period_name = '${P_PERIOD}'
                   and jh.actual_flag = 'A'
                   and jl.period_name = jh.period_name
                   AND jl.status != 'P'
                   and decode('${P_INCLUDE_UNPOSTED}', 'Y', 1, 0) = 1
                 GROUP BY jl.code_combination_id) GJ
        
         WHERE S.ROW_SET_NAME = '${rowSetName}'
           AND S.ROW_SET_ID = R.ROW_SET_ID
           AND R.DISPLAY_FLAG = 'Y'
           AND R.ROW_ID = C.ROW_ID
           AND C.CAL_ITEM_CODE = IC.ITEM_CODE
           and gl.ledger_id = ${P_LEDGER}
           AND IC.ITEM_CONTENT_ID = ICR.ITEM_CONTENT_ID
           AND GCC.SEGMENT1 <= NVL(ICR.SEGMENT1_HIGH, GCC.SEGMENT1)
           AND GCC.SEGMENT1 >= NVL(ICR.SEGMENT1_LOW, GCC.SEGMENT1)
           AND GCC.SEGMENT2 <= NVL(ICR.SEGMENT2_HIGH, GCC.SEGMENT2)
           AND GCC.SEGMENT2 >= NVL(ICR.SEGMENT2_LOW, GCC.SEGMENT2)
           AND GCC.SEGMENT3 <= NVL(ICR.SEGMENT3_HIGH, GCC.SEGMENT3)
           AND GCC.SEGMENT3 >= NVL(ICR.SEGMENT3_LOW, GCC.SEGMENT3)
           AND GCC.SEGMENT8 <= NVL(ICR.SEGMENT8_HIGH, GCC.SEGMENT8)
           AND GCC.SEGMENT8 >= NVL(ICR.SEGMENT8_LOW, GCC.SEGMENT8)
           AND GCC.CHART_OF_ACCOUNTS_ID = gl.CHART_OF_ACCOUNTS_ID
           and gcc.enabled_flag = 'Y'
           and gcc.summary_flag = 'N'
           AND V.PARENT_VALUE IN ('${P_SEG1}')
           AND V.DIM_SEGMENT = 'SEGMENT1'
           AND GCC.SEGMENT1 = V.DIM_VALUE
           AND ${IF(LEN(P_SEG2) == 0,"1=1"," EXISTS (SELECT 1 FROM apps.CUX_HRS_CORE_DIM_CHILD_V  V2 WHERE V2.DIM_SEGMENT = 'SEGMENT2' AND GCC.SEGMENT2 = V2.DIM_VALUE AND V2.parent_value IN ('" +P_SEG2 + "'))")}
           and gb2.ledger_id(+) = ${P_LEDGER}
           and gb2.code_combination_id(+) = GCC.code_combination_id
           and gb2.currency_code(+) = '${P_CURRENCY}'
           and gb2.period_name(+) = '${P_PERIOD}'
           and gb2.actual_flag(+) = 'A'
           AND GJ.code_combination_id(+) = GCC.code_combination_id
         GROUP BY V.PARENT_VALUE, R.ROW_NUM, R.ROW_NAME,
               R.LINE_NUM) T
 order by T.SEG1, to_number(T.ROW_NUM), T.ROW_NAME
