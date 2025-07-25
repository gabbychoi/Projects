CREATE VIEW [scm].[VM_PSI_REGIONAL_SUPPLY_DATA]
AS
SELECT [Area], [GRDP_005] AS 'EDP', [NEWRDD] as 'RDD', [Qty]
FROM [DW_YG1].[scm].[TB_SCM_PSI_04_ProductionBalance_Result]