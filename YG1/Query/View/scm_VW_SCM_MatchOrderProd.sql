create   VIEW [scm].[VW_SCM_MatchOrderProd]
AS
WITH supply_so as(
SELECT 
A.MANDT, --CLIENT
ERSDA, --수행일
MATNR, --MATERIAL
FERTH, --UNcoat
KWMENG, --QTY
P_QTY, --PENDING QTY
BSTDK_E, -- Customer Delivery Date
B.AUDAT, -- Doc. Date
A.VBELN,
A.POSNR,
ETL_DATE
FROM [scm].[TB_DW_FACT_ZDWT010_Z25SD003] A
JOIN ODS_YG1.ods_scm.TB_ODS_ZDWT010_Z25SD003_VBAK B
ON A.MANDT=B.MANDT AND A.VBELN=B.VBELN
)
,OrderQty AS (
SELECT MANDT,ERSDA,MATNR,BDMNG as qty
FROM scm.TB_DW_FACT_ZDWT011_Z25PP016
UNION ALL
SELECT MANDT,ERSDA,MATNR,KWMENG
FROM scm.[TB_DW_FACT_ZDWT010_Z25SD003]
),
EDPQty AS (
-- prod_edp_df와 order_qty_df를 outer join (pd.merge with how='outer')
SELECT 
  P.MANDT,
  P.ERSDA,
COALESCE(p.MATNR, o.MATNR) MATNR, 
ISNULL(p.GAMNG, 0) AS GAMNG, 
ISNULL(o.Qty, 0) AS Qty
FROM scm.TB_DW_DIM_ZDWT005_COOIS p
FULL OUTER JOIN OrderQty o 
 ON p.MATNR = o.MATNR AND p.ERSDA=O.ERSDA AND P.MANDT=o.MANDT
),
TRDiffQty AS (
SELECT 
 MANDT,ERSDA,
MATNR,
Qty - GAMNG AS TR_EXCEPT_QTY
FROM EDPQty
) , getProdQty AS (
-- 차감 필요 수량이 0보다 큰 EDP만 반환
SELECT 
MANDT,ERSDA, MATNR, TR_EXCEPT_QTY
FROM TRDiffQty
WHERE TR_EXCEPT_QTY > 0)
, Ranked_TR AS (
SELECT 
  MANDT,
  ERSDA,
  RSNUM,
  RSDAT,
t.MATNR,
t.BDMNG,
t.BDTER,
ROW_NUMBER() OVER (PARTITION BY t.MATNR ORDER BY t.BDTER DESC, t.BDMNG ASC) AS rn
FROM 
scm.TB_DW_FACT_ZDWT011_Z25PP016 t
),
Filtered_TR AS (
SELECT 
  t1.MANDT,
  t1.ERSDA,
t1.MATNR,
  RSNUM,
  RSDAT,
t1.BDMNG,
t1.BDTER,
CASE 
WHEN t1.BDMNG - COALESCE(f.TR_EXCEPT_QTY, 0) > 0 THEN t1.BDMNG - COALESCE(f.TR_EXCEPT_QTY, 0)
ELSE 0
END AS QTY_AFTER_TR
FROM 
Ranked_TR t1
LEFT JOIN 
getProdQty f 
ON 
t1.MATNR = f.MATNR
), filterTrQty AS (
SELECT * 
FROM Filtered_TR
WHERE QTY_AFTER_TR > 0
),
concat_order AS (
-- Step 1: Filtering and preparing filter_tr_df and oversea_so_df with renamed columns
SELECT 
 MANDT,
 ERSDA,
'TR' AS Type, 
RSNUM AS 주문_Order_Key, 
MATNR, 
DATEFROMPARTS(RSDAT/10000,(RSDAT%10000)/100,RSDAT%100) AS Created_on, 
DATEADD(day,42,DATEFROMPARTS(RSDAT/10000,(RSDAT%10000)/100,RSDAT%100)) AS RDD,
 QTY_AFTER_TR,
 NULL as "조정 납기"
FROM filterTrQty
UNION ALL
SELECT 
 MANDT,
 ERSDA,
 'SO' AS Type, 
 VBELN+'-'+POSNR AS 주문_Order_Key, 
 MATNR, 
 DATEFROMPARTS(AUDAT/10000,(AUDAT%10000)/100,AUDAT%100) AS Created_on, 
 DATEADD(day,42,DATEFROMPARTS(AUDAT/10000,(AUDAT%10000)/100,AUDAT%100)) AS RDD, 
 KWMENG,
 CASE WHEN BSTDK_E>0 THEN DATEFROMPARTS(BSTDK_E /10000,( BSTDK_E%10000)/100, BSTDK_E%100)ELSE NULL END AS "조정 납기" 
FROM  SUPPLY_SO
),
sorted_prod AS (
-- Step 3: Sort raw_prod_df by Created on and Qty
SELECT 
  MANDT,
  ERSDA,
AUFNR AS 생산_Order_Key, 
MATNR ,
DATEFROMPARTS(ERDAT/10000,(ERDAT%10000)/100,ERDAT%100) AS "Created on", 
  DATEADD(day,42,DATEFROMPARTS(ERDAT/10000,(ERDAT%10000)/100,ERDAT%100)) AS PRDD, 
GAMNG AS Qty
     FROM scm.TB_DW_DIM_ZDWT005_COOIS
),
matched_orders AS (
-- Step 4: Match production orders with sales orders based on EDP and quantity
SELECT 
  S.MANDT,
  S.ERSDA,
s.Type,
p.생산_Order_Key,
s.주문_Order_Key,
s.MATNR,
CASE WHEN s.QTY_AFTER_TR>= p.Qty THEN p.Qty ELSE QTY_AFTER_TR END AS Qty,
p."Created on",
s.RDD AS "주문 납기 RDD",
CASE 
WHEN s."조정 납기" IS NOT NULL THEN CASE WHEN p."Created on" >=DATEADD(DAY,-14,s."조정 납기") THEN p."Created on"  ELSE DATEADD(DAY,-14,s."조정 납기") END
ELSE NULL
END AS "조정 납기",
  PRDD AS "생산 계획 RDD"
FROM concat_order s
JOIN sorted_prod p
ON s.MATNR = p.MATNR AND S.MANDT=P.MANDT AND s.ERSDA=P.ERSDA
),
result_match AS (
-- Step 5: Generate result match dataframe
SELECT 
  MANDT,
  ERSDA,
Type, 
생산_Order_Key, 
주문_Order_Key, 
MATNR, 
Qty, 
Created on, 
DATEADD( DAY,42,"Created on") AS "생성일 6주 RDD", 
주문 납기 RDD, 
조정 납기,
  "생산 계획 RDD"
FROM matched_orders
),
final_result AS (
-- Step 6: Match with production plan dates
SELECT 
 MANDT,
 ERSDA,
r.[Type], 
r.생산_Order_Key, 
r.주문_Order_Key, 
r.MATNR AS EDP, 
r.Qty, 
r."Created on", 
r."생성일 6주 RDD", 
r."생산 계획 RDD", 
r."주문 납기 RDD", 
r."조정 납기"
FROM result_match r
)
SELECT * FROM final_result;