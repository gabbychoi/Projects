CREATE VIEW scm.VW_TB_SCM_ZROUTING_CAPA
AS
SELECT MATNR as [material],
ARBPL AS [Work Ctr],
VGW01 AS [set_up_time],
VGW02 AS [cycle_time],
VORNR AS [Operation/Activity],
PLNAL AS[공정 순서]
FROM DW_YG1.scm.TB_SCM_ZROUTING