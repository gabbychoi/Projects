CREATE VIEW [scm].[VW_TB_DW_CAPA_ORDER_PLAN]
AS
SELECT 
AUFNR AS [생산 Order Key]
,ORDER_TYPE as [타입]
,LATEST_WORK_YEAR [최종 작업 배치 년도]
,LATEST_WORK_WEEK as [최종 작업 배치 주차]
,VORNR [Operation/Activity]
,QTY as qty
,MATNR as material
,AUDAT as [Created On]
,PLNAL as [공정 순서]
,WORK_TIME AS [생산 시간]
,WORK_CENTER AS [Work Ctr]
,WORK_CENTER AS [기준 정보 Work Ctr]
,ERSDA AS SIMULATION_DATE
FROM scm.TB_DW_CAPA_ORDER_PLAN