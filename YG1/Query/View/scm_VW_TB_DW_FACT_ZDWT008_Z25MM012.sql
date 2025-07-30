CREATE VIEW SCM.[VW_TB_DW_FACT_ZDWT008_Z25MM012]
as
SELECT 
EBELN as [Po Document],
EBELP as [Po Item],
EINDT as [Doc.Date],
BEDAT as [PO Deliv.date],
A.MATNR AS Material,
B.FERTH AS [Non coat.Item],
WERKS AS PLANT,
A.GROES as [Size/Dim.],
MAKTX [Material Description],
MENGE AS [PO QTY],
LMEIN AS [ORDER_UNIT],
NETPR AS [NET_PRICE],
WAERS AS [CURRENCY],
GR_QTY AS [Delivered.Qty],
LIFNR AS [Vendor],
NAME1 AS [Vendor Name],
LGORT AS [Storage Location],
A.EKGRP AS [Pur.Group],
B.MATKL AS [Material Group]
FROM scm.TB_DW_FACT_ZDWT008_Z25MM012 A
JOIN DW_YG1.dbo.TB_DW_DIM_MARA B 
ON  1=1 
 AND A.MATNR=B.MATNR 
 AND A.MANDT=B.MANDT