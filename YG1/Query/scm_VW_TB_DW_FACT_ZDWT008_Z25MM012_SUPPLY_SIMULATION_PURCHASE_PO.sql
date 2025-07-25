CREATE VIEW scm.VW_TB_DW_FACT_ZDWT008_Z25MM012_SUPPLY_SIMULATION_PURCHASE_PO
AS
SELECT [MANDT] as [CLIENT]
,[AEDAT] as [PO Doc Date]
,[LIFNR] [Vendor]
,[WAERS] [Currency]
,[WKURS] [Exchange_rate]
,[EBELN] [PO NO.]
,[EBELP] [PO NO. Item]
,[MATNR] [Material Code]
,[NETPR] [        Price]
,[MENGE] [ PO Qty.]
,[EINDT] [PO Delivery Date]
,[CHARG] [Batch]
,[MTART] [Material Type]
,[WERKS] Plant
,[MEINS] Unit
,[PEINH] [  Price]
,[MAKTX][Descr]
,[STOCK] [Stock in Transit]
,[PO_BAL] [Po Balance]
,[PE_QTY] [PO Pending]
   ,NETPR*MENGE AS [        Amount]
,ERSDA as SIMULATION_DATE
FROM [scm].[TB_DW_FACT_ZDWT008_Z25MM012]