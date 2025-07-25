create   VIEW [scm].[VW_TB_DW_FACT_ZDWT011_Z25PP016_SUPPLY_SIMULATION_TR]
AS
SELECT 
  MANDT CLIENT
 ,LGORT [Issue S/L]
 ,MATNR [EDP]
 ,FERTH [Uncoating Code]
 ,MAKTX [EDP Description]
 ,BDMNG [   Qty]
 ,ZFIX [Fixed]
 ,RSDAT [Creat Date]
 ,BDTER [Required Date]
 ,RSNUM [Reservation]
 ,DOSTK [Do current stock1]
 ,SAFS1 [Safety Stock1]
 ,AVAS1 [Avail stock1]
 ,EXCST [Ex Current]
 ,SAFS2 [Safety Stock2]
 ,AVAS2 [Avail stock2]
 ,RSPOS [Res. Item]
 ,GRDP_PLC [PLC]
 ,MEINS [UoM]
 ,GRDP_ABC [ABC]
 ,UMLGO [Rec.Sloc]
 ,SBTER [Delivery date]
 ,ERSDA SIMULATION_DATE
FROM SCM.TB_DW_FACT_ZDWT011_Z25PP016