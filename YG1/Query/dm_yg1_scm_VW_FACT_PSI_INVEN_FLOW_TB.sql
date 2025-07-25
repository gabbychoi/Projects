CREATE VIEW  [dm_yg1_scm].[VW_FACT_PSI_INVEN_FLOW_TB] AS 
/****************************************************************************************************************
View 명  : VW_FACT_PSI_INVEN_FLOW_TB
View 제목 : SCM 재고 흐름 - PIVOT VIEW 
최초작성자 : 김기만
최초작성일 : 2024.11.22
View 실행 예 : SELECT * FROM DM_YG1.dm_yg1_scm.VW_FACT_PSI_INVEN_FLOW_TB 
View 설명 : SCM 재고 흐름 - PIVOT VIEW
   
변경이력  : 변경일/변경자/요청자/요청일/내용 
     
******************************************************************************************************************/
WITH Unpivoted AS (
SELECT CLIENT, SAP_LOAD_DATE, ERSDA, MATNR, REGION, PRODH, VTEXT,
CASE
WHEN Week = 'CurrentINVEN'         THEN -1
WHEN Week in ('0WeekINVEN', '0WeekPROD', '0WeekSales') THEN 0
WHEN Week in ('1WeekINVEN', '1WeekPROD', '1WeekSales') THEN 1
WHEN Week in ('2WeekINVEN', '2WeekPROD', '2WeekSales') THEN 2
WHEN Week in ('3WeekINVEN', '3WeekPROD', '3WeekSales') THEN 3
WHEN Week in ('4WeekINVEN', '4WeekPROD', '4WeekSales') THEN 4
WHEN Week in ('5WeekINVEN', '5WeekPROD', '5WeekSales') THEN 5
WHEN Week in ('6WeekINVEN', '6WeekPROD', '6WeekSales') THEN 6
      WHEN Week in ('7WeekINVEN', '7WeekPROD', '7WeekSales') THEN 7
      WHEN Week in ('8WeekINVEN', '8WeekPROD', '8WeekSales') THEN 8
      WHEN Week in ('9WeekINVEN', '9WeekPROD', '9WeekSales') THEN 9
      WHEN Week in ('10WeekINVEN', '10WeekPROD', '10WeekSales') THEN 10
      WHEN Week in ('11WeekINVEN', '11WeekPROD', '11WeekSales') THEN 11
      WHEN Week in ('12WeekINVEN', '12WeekPROD', '12WeekSales') THEN 12
END AS 'WEEK',
     CASE
      WHEN WEEK IN ('CurrentINVEN', '0WeekINVEN', '1WeekINVEN', '2WeekINVEN', '3WeekINVEN', '4WeekINVEN', '5WeekINVEN', '6WeekINVEN', '7WeekINVEN', '8WeekINVEN', '9WeekINVEN', '10WeekINVEN', '11WeekINVEN', '12WeekINVEN') THEN '재고'
      WHEN WEEK IN ('0WeekPROD' , '1WeekPROD' , '2WeekPROD' , '3WeekPROD' , '4WeekPROD' , '5WeekPROD' , '6WeekPROD', '7WeekPROD', '8WeekPROD', '9WeekPROD', '10WeekPROD', '11WeekPROD', '12WeekPROD') THEN '공급'
      WHEN WEEK IN ('0WeekSales', '1WeekSales', '2WeekSales', '3WeekSales', '4WeekSales', '5WeekSales', '6WeekSales', '7WeekSales', '8WeekSales', '9WeekSales', '10WeekSales', '11WeekSales', '12WeekSales') THEN '수요'
     END AS 'TYPE',
VALUE
FROM (
SELECT CLIENT, SAP_LOAD_DATE, ERSDA, MATNR, REGION, PRODH, VTEXT,
[CurrentINVEN], 
[0WeekINVEN], [1WeekINVEN], [2WeekINVEN], [3WeekINVEN], [4WeekINVEN], [5WeekINVEN], [6WeekINVEN], [7WeekINVEN], [8WeekINVEN], [9WeekINVEN], [10WeekINVEN], [11WeekINVEN], [12WeekINVEN]
    , [0WeekPROD] , [1WeekPROD] , [2WeekPROD] , [3WeekPROD] , [4WeekPROD] , [5WeekPROD] , [6WeekPROD], [7WeekPROD], [8WeekPROD], [9WeekPROD], [10WeekPROD], [11WeekPROD], [12WeekPROD]
    , [0WeekSales], [1WeekSales], [2WeekSales], [3WeekSales], [4WeekSales], [5WeekSales], [6WeekSales], [7WeekSales], [8WeekSales], [9WeekSales], [10WeekSales], [11WeekSales], [12WeekSales]
FROM DM_YG1.dm_yg1_scm.FACT_PSI_INVEN_FLOW_TB
    WHERE [CurrentINVEN] + [0WeekINVEN] + [1WeekINVEN] + [2WeekINVEN] + [3WeekINVEN] + [4WeekINVEN] + [5WeekINVEN] + [6WeekINVEN] + [7WeekINVEN] + [8WeekINVEN] + [9WeekINVEN] + [10WeekINVEN] + [11WeekINVEN] + [12WeekINVEN] <> 0
       OR [0WeekPROD] + [1WeekPROD] + [2WeekPROD] + [3WeekPROD] + [4WeekPROD] + [5WeekPROD] + [6WeekPROD] + [7WeekPROD] + [8WeekPROD] + [9WeekPROD] + [10WeekPROD] + [11WeekPROD] + [12WeekPROD] > 0
    OR [0WeekSales] + [1WeekSales] + [2WeekSales] + [3WeekSales] + [4WeekSales] + [5WeekSales] + [6WeekSales] + [7WeekSales] + [8WeekSales] + [9WeekSales] + [10WeekSales] + [11WeekSales] + [12WeekSales] > 0
) AS SourceTable
UNPIVOT (
VALUE FOR Week IN ([CurrentINVEN], [0WeekINVEN], [1WeekINVEN], [2WeekINVEN], [3WeekINVEN], [4WeekINVEN], [5WeekINVEN], [6WeekINVEN], [7WeekINVEN], [8WeekINVEN], [9WeekINVEN], [10WeekINVEN], [11WeekINVEN], [12WeekINVEN]
           , [0WeekPROD] , [1WeekPROD] , [2WeekPROD] , [3WeekPROD] , [4WeekPROD] , [5WeekPROD] , [6WeekPROD], [7WeekPROD], [8WeekPROD], [9WeekPROD], [10WeekPROD], [11WeekPROD], [12WeekPROD]
           , [0WeekSales], [1WeekSales], [2WeekSales], [3WeekSales], [4WeekSales], [5WeekSales], [6WeekSales], [7WeekSales], [8WeekSales], [9WeekSales], [10WeekSales], [11WeekSales], [12WeekSales])
) AS UnpivotTable
 WHERE (
    (WEEK IN ('0WeekPROD' , '1WeekPROD' , '2WeekPROD' , '3WeekPROD' , '4WeekPROD' , '5WeekPROD' , '6WeekPROD', '7WeekPROD', '8WeekPROD', '9WeekPROD', '10WeekPROD', '11WeekPROD', '12WeekPROD'
     , '0WeekSales', '1WeekSales', '2WeekSales', '3WeekSales', '4WeekSales', '5WeekSales', '6WeekSales', '7WeekSales', '8WeekSales', '9WeekSales', '10WeekSales', '11WeekSales', '12WeekSales')
    AND VALUE > 0)
   OR (WEEK IN ('CurrentINVEN', '0WeekINVEN', '1WeekINVEN', '2WeekINVEN', '3WeekINVEN', '4WeekINVEN', '5WeekINVEN', '6WeekINVEN', '7WeekINVEN', '8WeekINVEN', '9WeekINVEN', '10WeekINVEN', '11WeekINVEN', '12WeekINVEN')
    AND VALUE <> 0)
    )
   AND [ERSDA] >= DATEADD(MONTH, -3, GETDATE())
)
SELECT *, CAST(CONCAT(YEAR(DATEADD(day, 26 - DATEPART(isowk, [TARGET_DATE]) * 7, [TARGET_DATE])), FORMAT(TARGET_WEEK, '00')) AS INT) AS SORT
FROM (
 SELECT CLIENT, SAP_LOAD_DATE, ERSDA, [WEEK], REGION, MATNR, PRODH, VTEXT
   , SUM([SALES])          AS SALES
   , SUM([INVEN])          AS INVEN
   , SUM([PROD])          AS PROD
   , SUM([INVEN_FLOW])        AS INVEN_FLOW
   , DATEADD(DAY, WEEK * 7, ERSDA)     AS TARGET_DATE
   , DATEPART(ISO_WEEK, DATEADD(WEEK, [WEEK], ERSDA)) AS TARGET_WEEK
 FROM (
   SELECT  CLIENT, SAP_LOAD_DATE, ERSDA, [WEEK], [TYPE], REGION, MATNR, PRODH, VTEXT, 
     CASE [TYPE] 
      WHEN '수요' THEN VALUE
      ELSE 0 
     END AS SALES, 
     CASE [TYPE] 
      WHEN '재고' THEN VALUE
      ELSE 0 
     END AS INVEN, 
     CASE [TYPE] 
      WHEN '공급' THEN VALUE
      ELSE 0 
     END AS PROD, 
     CASE [TYPE] 
      WHEN '재고' THEN VALUE - LAG(VALUE, 1, 0) OVER (PARTITION BY CLIENT, SAP_LOAD_DATE, ERSDA, [TYPE], MATNR, REGION ORDER BY WEEK) 
      ELSE 0
     END AS INVEN_FLOW
   FROM Unpivoted
  ) A
 GROUP BY CLIENT, SAP_LOAD_DATE, ERSDA, [WEEK], REGION, MATNR, PRODH, VTEXT
 ) B
 WHERE WEEK > -1