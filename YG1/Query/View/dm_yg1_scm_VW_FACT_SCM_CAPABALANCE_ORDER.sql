CREATE   VIEW  [dm_yg1_scm].[VW_FACT_SCM_CAPABALANCE_ORDER] AS 
/****************************************************************************************************************
View 명  : VW_FACT_SCM_CAPABALANCE_ORDER
View 제목 : SCM 작번 별 마지막 생산 주차 - 생산 입고 일정 기준 수량
최초작성자 : 김기만
최초작성일 : 2024.11.28
View 실행 예 : SELECT * FROM DM_YG1.dm_yg1_scm.VW_FACT_SCM_CAPABALANCE_ORDER 
View 설명 : SCM 작번 별 마지막 생산 주차 - 생산 입고 일정 기준 수량
   
변경이력  : 변경일/변경자/요청자/요청일/내용 
     
******************************************************************************************************************/
SELECT PO
  , YEAR(DATEADD(day, 26 - DATEPART(ISO_WEEK, ADD_DATE) * 7, ADD_DATE)) AS ADD_YEAR
  , ADD_WEEK
  , WORK_YEAR
  , WORK_WEEK
  , MATKL
  , OPERATION_QTY
  , SAP_LOAD_DATE
  , PO_TYPE
FROM (
  SELECT PO
    , WORK_YEAR
    , WORK_WEEK
    , RDD
    , DATEADD(WEEK, 4, [RDD]) AS ADD_DATE
    , DATEPART(ISO_WEEK, DATEADD(WEEK, 4, [RDD])) AS ADD_WEEK
    , MATKL
    , MAX(OPERATION_QTY) AS OPERATION_QTY
    , SAP_LOAD_DATE
    , MAX(PO_TYPE) AS PO_TYPE
    FROM dm_yg1_scm.FACT_SCM_CAPABALANCE_ORDER_N FACT
   INNER JOIN dm_yg1_scm.DIM_SCM_WORKCENTER_CAPACITY WC
   ON FACT.WORK_CENTER = WC.WORK_CENTER
   WHERE (WORK_YEAR = LEFT(SAP_LOAD_DATE, 4) AND WORK_WEEK >= DATEPART(WEEK, CAST(CAST(SAP_LOAD_DATE AS CHAR(8)) AS DATE)))
      OR WORK_YEAR > LEFT(SAP_LOAD_DATE, 4)
   GROUP BY PO
    , WORK_YEAR
    , WORK_WEEK
    , RDD
    , MATKL
    , SAP_LOAD_DATE
  ) B