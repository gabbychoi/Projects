CREATE   VIEW  [scm].[VW_TB_DW_FACT_ZDWT010_Z25SD003]
AS
SELECT 
[MANDT] CLIENT
,[VKORG] [Sales Organization]
,VTWEG [Distribution Chan.]
,VBELN [Sales Doc No]
,POSNR [Item No]
,MATNR [Material]
,FERTH [Uncoat]
,KWMENG [Order Qty]
,MEINS UNIT
,P_QTY [Pending Qty]
,RFMNG_1 [Deliv Qty]
,BSTDK_E  [Customer Delivery Date]
,[ERSDA] SIMULATION_DATE
FROM SCM.TB_DW_FACT_ZDWT010_Z25SD003