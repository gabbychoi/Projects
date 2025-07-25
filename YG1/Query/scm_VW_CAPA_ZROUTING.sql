CREATE VIEW scm.VW_CAPA_ZROUTING
AS
SELECT MATNR as [material],
    ARBPL as [Work ctr], 
    VGW01 AS SET_UP_TIME,
    VGW02/BMSCH AS cycle_time,
    VORNR AS [Operation/Activity],
    PLNAL as [공정순서]
,*
FROM SCM.TB_SCM_ZROUTING
WHERE 1=1
AND WERKS=1000