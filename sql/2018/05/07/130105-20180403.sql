SELECT T.TYPE,
       T.segment1,
       T.segment2,
       T.BOND_CODE,
       T.BOND_NAME,
       P.attribute5,
       P.prod_type2,
       T.BOND_ID,
       T.togl_date,
       T.bc_concactenated,
       T.category_name,
       --T.trade_source,   UPDATED BY QD 20180206
       p.prod_market,       --ADDED BY QD 20180206
       T.quantity,
       T.cost,
       T.int_adjust,
       T.mkt_value_chg,
       T.mkt_value,
       T.int_recb,
       T.ub_int_recb,
       T.int_income,
       T.invest_gain,
       T.mkt_value_chg_gain
  FROM ( /*财务性投资持仓*/
        SELECT 'STOCK' TYPE, --模块
                info.segment1, --机构,
                info.segment2, --部门,
                info.stock_code BOND_CODE, --证券代码,
                info.stock_name BOND_NAME, --证券名称,
                info.stock_id BOND_ID, --内部编码,
                book.togl_date, --持仓日期,
                info.bc_concactenated, --资产单元,
                cla.category_name, --投资类型,
                info.trade_source,-- 市场,
                book.stock_quantity quantity, --持仓数量,
                book.cost, --持仓成本,
                book.int_adjust, --利息调整,
                book.mkt_value_chg, --公允价值变动,
                book.mkt_value, --市值,
                book.int_recb, --应收股利,
                book.ub_int_recb, --未入账应收利息,
                book.int_income, --本年股息红利收入,
                book.invest_gain, --本年投资买卖收益,
                book.mkt_value_chg_gain --本年公允变动损益
          FROM (SELECT *
                   FROM xxt.xxt_stock_book_b b
                  WHERE (stock_id, balance_id) IN
                        (SELECT stock_id, MAX(balance_id) balance_id
                           FROM xxt.xxt_stock_book_b
                          WHERE togl_date <= TO_DATE('2018-04-30', 'YYYY-MM-DD')
                          AND ACTIVITY_CODE<>100
                          GROUP BY stock_id)
                    AND stock_id = b.stock_id) book,
                
                xxt.xxt_stock_info_b   info,
                xxt.xxt_stock_class_b  cla,
                xxt.xxt_stock_ledger_b le
         WHERE book.stock_id = info.stock_id
           AND info.asset_type = cla.category_code
           and info.segment1 in ('130105') --'130103' --参数1 
              --and info.segment2 = '${P_SEG2}' --'131111' --参数2 可以为空
         /*  AND ${IF(LEN(P_SEG2) == 0,
                    "1=1",
                    "info.segment2 IN ('" + P_SEG2 + "')")
         }*/
           and (book.stock_quantity <> 0 OR book.cost <> 0 OR
               book.mkt_value <> 0 OR book.int_recb <> 0 or
               book.int_income <> 0 OR book.invest_gain <> 0 or
               book.mkt_value_chg_gain <> 0)
           and le.ledger_id = 1001 --参数，安全性控制
           and le.segment1 = info.segment1
           and ('N' = 'Y' OR
               (book.stock_quantity <> 0 OR book.cost <> 0)) --是否显示0持仓
        UNION ALL
        /*债券投资持仓*/
        SELECT 'BOND' TYPE, --类型,
               info.segment1, --公司,
               info.segment2, --部门,
               info.bond_code BOND_CODE, --证券代码,
               info.bond_name BOND_NAME, --证券名称,
               info.bond_id BOND_ID, --资产ID,
               book.togl_date, --持仓日期, 
               info.bc_concactenated, --资产单元, 
               cla.asset_class_name category_name, --资产类别,
               info.trade_source,    --市场, --市场要更改      
               book.quantity, --数量,
               book.initial_cost cost, --成本,
               book.int_adjust, --利息调整,
               book.mkt_value_chg, --公允价值变动,
               book.book_value, --市值, -- 需要确认 lxq 20170802 mkt_value
               book.int_recb, --应收利息,
               book.Ub_Int_Recb, --未入账应收利息,
               book.int_income, --本年利息收入,
               book.invest_gain, --本年投资买卖收益,
               book.mkt_value_chg_gain --本年公允变动损益
        
          FROM (SELECT *
                  FROM xxt.xxt_bond_book_b b
                 WHERE (bond_id, balance_id) IN
                       (SELECT bond_id, MAX(balance_id) balance_id
                          FROM xxt.xxt_bond_book_b
                         WHERE togl_date <= TO_DATE('2018-04-30', 'YYYY-MM-DD')
                         AND ACTIVITY_CODE<>100
                         GROUP BY bond_id)
                   AND bond_id = b.bond_id) book,
               xxt.xxt_bond_info_b info,
               
               xxt.xxt_bond_asset_class_b cla,
               xxt.xxt_BOND_ledger_b      le
         WHERE book.bond_id = info.bond_id
              
           AND info.asset_class = cla.asset_class_code
           and info.segment1 in ('130105') --'130103' --参数1 
              --and info.segment2 = '${P_SEG2}' --'131111' --参数2 可以为空
           /*
           AND ${IF(LEN(P_SEG2) == 0,
                    "1=1",
                    "info.segment2 IN ('" + P_SEG2 + "')")
         }*/
           and (book.quantity <> 0 OR book.initial_cost <> 0 OR
               book.mkt_value <> 0 OR book.int_recb <> 0 or
               book.int_income <> 0 OR book.invest_gain <> 0 or
               book.mkt_value_chg_gain <> 0)
           and le.ledger_id = 1001 --参数，安全性控制
           and le.segment1 = info.segment1
           and ('N' = 'Y' OR
               (book.quantity <> 0 OR book.initial_cost <> 0)) --是否显示0持仓
        ) T,
        (SELECT ffvv.flex_value,
               ffvv.description,
               ffvv.attribute5,
               prod_type2.description prod_type2,
               
               ffvv.attribute1,                      ---- ADDED BY QD 20180206    
               prod_market.description prod_market  ---- ADDED BY QD 20180206 
               
          FROM apps.fnd_flex_value_sets ffvs,
               apps.fnd_flex_values_vl ffvv,
               (SELECT ffvv1.flex_value, ffvv1.description
                  FROM apps.fnd_flex_value_sets ffvs1, apps.fnd_flex_values_vl ffvv1
                 WHERE ffvs1.flex_value_set_id = ffvv1.flex_value_set_id
                   AND ffvs1.flex_value_set_name = 'XD_SEC_V2_PROD_CATGRY') prod_type2,
                   
              -------------------BEGIN----------------------- ADDED BY QD 20180206    
                 
                 (SELECT ffvv2.flex_value, ffvv2.description
                  FROM apps.fnd_flex_value_sets ffvs2, apps.fnd_flex_values_vl ffvv2
                 WHERE ffvs2.flex_value_set_id = ffvv2.flex_value_set_id
                   AND ffvs2.flex_value_set_name = 'XD_SEC_V1_HS_MARKET') prod_market   
        ----------------------------END-----------------------------
         WHERE 1 = 1
           AND ffvs.flex_value_set_id = ffvv.flex_value_set_id
           AND ffvs.flex_value_set_name = 'XXT_FIN_COA_PRODUCTION'
           
           AND ffvv.attribute1 = prod_market.flex_value(+)  --ADDED BY QD 20180206    
           
           AND ffvv.attribute5 = prod_type2.flex_value(+)) P
           WHERE T.BOND_CODE=P.FLEX_VALUE
 order by T.segment1, T.segment2,P.attribute5, T.TYPE,T.bond_code, 
       P.prod_type2,T.bond_id,T.togl_date,T.bc_concactenated
