CREATE VIEW [scm].[VW_TB_DW_DIM_ZDWT005_ROUTING_TB_SUPPLY_SIMULATION_ROUTING]
AS
SELECT A.[MANDT] ClIENT
,[AUFNR] [Order]
,[VORNR] [Oper./Act.]
   ,B.ARBPL AS [Work cntr.]
,A.[KTSCH] [Text key]
,[LTXA1] [Opr. short text]
,[AUTYP] [Category]
,[GAMNG] [Op. Qty]
,[IAMNG] [  Yield]
,[IASMG] [Scrap]
,[BMEINS] [Act/Op.UoM]
,[GSTRI] [Act. start]
,[GLTRI] [Act.finish]
,[ZTNOR] [              Move time]
,[ZEITN] [Unit]
,[WARTZ] [             Queue time]
,[WRTZE] [Unit Time]
,[BMSCH] [Base Qty]
,[IGMNG] [  Yield2]
,[VGW01][set_up_time]
,[VGW02] [cycle_time]
,[VGW03] [Std Value]
,[AUART] [Type]
,[ERSDA] SIMULATION_DATE
FROM [scm].[TB_DW_FACT_ZDWT005_ROUTING_TB] A
LEFT OUTER JOIN scm.TB_DW_DIM_CRHD B
ON A.KTSCH=B.KTSCH