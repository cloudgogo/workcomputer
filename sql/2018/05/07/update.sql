
SELECT t1.seg1,
       t1.row_name,
       t1.attribute1,
       T1.ATTRIBUTE2,
       CASE WHEN T1.ATTRIBUTE2='1' THEN 
       t1.period_end
       ELSE
       t1.period_amt END PEROD_END,
       t1.period_amt,
       t1.period_end c_period_end,
       t1.b_period_end b_period_end,
       t1.b_period_unposted b_period_unposted,
       t1.b_period_amt b_period_amt,
       t1.accounted_cr accounted_cr,
       t1.period_cr period_cr,
       
       'C120V1' report_name,
       'YEAR' TYPE
  FROM (SELECT t.seg1,
               t.row_num,
               t.row_name,
               t.attribute1,
               t.attribute2,
               t.period_end + nvl(t.period_unposted, 0) period_end,
               t.period_amt + nvl(t.accounted_cr, 0) - nvl(t.period_cr, 0) period_amt,
               t.period_end b_period_end,
               t.period_unposted b_period_unposted,
               t.period_amt b_period_amt,
               t.accounted_cr accounted_cr,
               t.period_cr period_cr
          FROM (SELECT gcc.segment1 seg1,
                       r.row_num,
                       r.row_name,
                       r.attribute1,
                       r.attribute2,
                       SUM(CASE WHEN GB2.PERIOD_NAME='2018-04' THEN 
                DECODE(R.CHANGE_SIGN,
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
                                         NVL(GB2.PERIOD_NET_CR, 0))))))END) PERIOD_END,
                       SUM(CASE WHEN GB2.PERIOD_NAME='2018-04' THEN 
               DECODE(R.CHANGE_SIGN,
                          'Y',
                          DECODE(C.SIGN,
                                 '+',
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_CR, 0)),
                                         -1 * (NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_CR, 0)))),
                                 -1 *
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_CR, 0)),
                                         -1 * (NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_CR, 0))))) * (-1),
                          DECODE(C.SIGN,
                                 '+',
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_CR, 0)),
                                         -1 * (NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_CR, 0)))),
                                 -1 *
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_CR, 0)),
                                         -1 * (NVL(GB2.BEGIN_BALANCE_CR, 0) +
                                         NVL(GB2.PERIOD_NET_CR, 0))))))END) PERIOD_AMT,
                       
                            SUM(CASE WHEN GB2.PERIOD_NAME=SUBSTR('2018-04',1,4)||'-01' THEN 
                DECODE(R.CHANGE_SIGN,
                          'Y',
                          DECODE(C.SIGN,
                                 '+',
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.BEGIN_BALANCE_CR, 0)),
                                         -1 * (NVL(GB2.BEGIN_BALANCE_CR, 0)))),
                                 -1 *
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.BEGIN_BALANCE_CR, 0)),
                                         -1 * (NVL(GB2.BEGIN_BALANCE_CR, 0))))) * (-1),
                          DECODE(C.SIGN,
                                 '+',
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.BEGIN_BALANCE_CR, 0)),
                                         -1 * (NVL(GB2.BEGIN_BALANCE_CR, 0)))),
                                 -1 *
                                 (DECODE(IC.SIGN,
                                         '+',
                                         (NVL(GB2.BEGIN_BALANCE_CR, 0)),
                                         -1 * (NVL(GB2.BEGIN_BALANCE_CR, 0))))))END) PERIOD_CR,
                       SUM(decode(r.change_sign,
                                  'Y',
                                  decode(c.sign,
                                         '+',
                                         (decode(ic.sign,
                                                 '+',
                                                 nvl(gj.entered_amt, 0),
                                                 -1 * nvl(gj.entered_amt, 0))),
                                         -1 *
                                         (decode(ic.sign,
                                                 '+',
                                                 nvl(gj.entered_amt, 0),
                                                 -1 * nvl(gj.entered_amt, 0)))) * (-1),
                                  decode(c.sign,
                                         '+',
                                         (decode(ic.sign,
                                                 '+',
                                                 nvl(gj.entered_amt, 0),
                                                 -1 * nvl(gj.entered_amt, 0))),
                                         -1 *
                                         (decode(ic.sign,
                                                 '+',
                                                 nvl(gj.entered_amt, 0),
                                                 -1 * nvl(gj.entered_amt, 0)))))) period_unposted,
                       SUM(decode(r.change_sign,
                                  'Y',
                                  decode(c.sign,
                                         '+',
                                         (decode(ic.sign,
                                                 '+',
                                                 nvl(gj.accounted_cr, 0),
                                                 -1 * nvl(gj.accounted_cr, 0))),
                                         -1 *
                                         (decode(ic.sign,
                                                 '+',
                                                 nvl(gj.accounted_cr, 0),
                                                 -1 * nvl(gj.accounted_cr, 0)))) * (-1),
                                  decode(c.sign,
                                         '+',
                                         (decode(ic.sign,
                                                 '+',
                                                 nvl(gj.accounted_cr, 0),
                                                 -1 * nvl(gj.accounted_cr, 0))),
                                         -1 *
                                         (decode(ic.sign,
                                                 '+',
                                                 nvl(gj.accounted_cr, 0),
                                                 -1 * nvl(gj.accounted_cr, 0)))))) accounted_cr
                  FROM cux.cux_hrs_def_row_set s,
                       cux.cux_hrs_def_row r,
                       cux.cux_hrs_def_row_calculation c,
                       cux.cux_hrs_def_item_content ic,
                       apps.gl_code_combinations gcc,
                       apps.gl_ledgers gl,
                       
                       cux.cux_hrs_item_content_range icr,
                       apps.gl_balances gb2,
                       (SELECT jl.code_combination_id,
                               jh.ledger_id,
                               
                               SUM(nvl(accounted_dr, 0) - nvl(accounted_cr, 0)) entered_amt, --取所有币种折算成本位币的金额
                               SUM(nvl(accounted_cr, 0)) accounted_cr
                          FROM gl_je_headers jh, gl_je_lines jl
                         WHERE 1 = 1
                           AND jh.je_header_id = jl.je_header_id
                           AND jh.ledger_id = 1001
                           AND jh.period_name IN
                               ('2018-04', substr('2018-04', 1, 4) || '-01')
                           AND jh.actual_flag = 'A'
                           AND jl.status != 'P'
                           and 1 = 1
                         GROUP BY jl.code_combination_id, jh.ledger_id) gj
                
                 WHERE s.row_set_name = 'C120V1'
                   AND s.row_set_id = r.row_set_id
                   AND r.display_flag = 'Y'
                   AND r.row_id = c.row_id
                   AND c.cal_item_code = ic.item_code
                   AND gl.ledger_id = 1001
                   AND ic.item_content_id = icr.item_content_id
                   AND gcc.segment1 <= nvl(icr.segment1_high, gcc.segment1)
                   AND gcc.segment1 >= nvl(icr.segment1_low, gcc.segment1)
                   AND gcc.segment2 <= nvl(icr.segment2_high, gcc.segment2)
                   AND gcc.segment2 >= nvl(icr.segment2_low, gcc.segment2)
                   AND gcc.segment3 <= nvl(icr.segment3_high, gcc.segment3)
                   AND gcc.segment3 >= nvl(icr.segment3_low, gcc.segment3)
                   AND gcc.segment4 <= nvl(icr.segment4_high, gcc.segment4)
                   AND gcc.segment4 >= nvl(icr.segment4_low, gcc.segment4)
                   AND gcc.segment5 <= nvl(icr.segment5_high, gcc.segment5)
                   AND gcc.segment5 >= nvl(icr.segment5_low, gcc.segment5)
                   AND gcc.segment6 <= nvl(icr.segment6_high, gcc.segment6)
                   AND gcc.segment6 >= nvl(icr.segment6_low, gcc.segment6)
                   AND gcc.segment7 <= nvl(icr.segment7_high, gcc.segment7)
                   AND gcc.segment7 >= nvl(icr.segment7_low, gcc.segment7)
                   AND gcc.segment8 <= nvl(icr.segment8_high, gcc.segment8)
                   AND gcc.segment8 >= nvl(icr.segment8_low, gcc.segment8)
                   AND gcc.segment9 <= nvl(icr.segment9_high, gcc.segment9)
                   AND gcc.segment9 >= nvl(icr.segment9_low, gcc.segment9)
                   AND gcc.chart_of_accounts_id = gl.chart_of_accounts_id
                   AND gcc.summary_flag = 'N'
                   AND gcc.enabled_flag = 'Y'
                   AND gcc.segment1 BETWEEN  '130101' AND '130101'
                 
                   
                   AND gb2.ledger_id = 1001
                   AND gl.ledger_id = gb2.ledger_id
                   AND gb2.code_combination_id(+) = gcc.code_combination_id
                   AND gb2.currency_code(+) = 'CNY'
                   AND gb2.period_name(+) IN
                       ('2018-04', substr('2018-04', 1, 4) || '-01')
                   AND gb2.actual_flag(+) = 'A'
                   AND gj.code_combination_id(+) = gcc.code_combination_id
                --   AND R.ATTRIBUTE2='1'
                 
                 GROUP BY gcc.segment1,
                          r.row_num,
                          r.row_name,
                          r.attribute1,
                          r.attribute2) t) t1
                          order by attribute1