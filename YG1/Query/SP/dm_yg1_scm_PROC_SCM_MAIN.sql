/****************************************************************************************************************
SP 명  : PROC_SCM_MAIN
SP 제목  : SCM 데이터마트 적재 프로시저
최초작성자 : 최은수
최초작성일 : 2024.11.22
SP 실행 예 : EXEC PROC_SCM_MAIN

    
 
******************************************************************************************************************/
CREATE PROCEDURE [dm_yg1_scm].[PROC_SCM_MAIN]
AS
BEGIN
 
 --공통변수
 DECLARE @SP_START_EXEC  DATETIME = GETDATE() -- SP 실행시작시간
 DECLARE @INSERT_CNT INT = 0   -- INSERT 건수
 DECLARE @UPDATE_CNT INT = 0   -- UPDATE 건수
 DECLARE @DELETE_CNT INT = 0   -- DELETE 건수
 DECLARE @TABLE_NM VARCHAR(50) = 'PROC_SCM_MAIN' -- TARGET TABLE NAME
 DECLARE @ERR_MSG VARCHAR(4000)
 DECLARE @ERR_NUM NVARCHAR(20)
 DECLARE @ERR_LINE INT
 
 
 DECLARE @COMPANY_CD VARCHAR(12) = '1000' -- 회사코드 (SAP 필드명 : BUKRS) 
 BEGIN TRY
  EXEC [dm_yg1_scm].[PROC_FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS] @SIMULATION_DT=@SP_START_EXEC
  --EXEC [dm_yg1_scm].[PROC_FACT_SCM_SUPPLY_SIMULATION_TB]
  EXEC [dm_yg1_scm].[PROC_FACT_SCM_SUPPLY_SIMULATION_TB_ROUTING]
  EXEC [dm_yg1_scm].[PROC_FACT_SCM_SUPPLY_SIMULATION_TB_REPORT]
  EXEC [dm_yg1_scm].[PROC_FACT_SCM_SUPPLY_SIMULATION_TB_INVEN_STATUS]
  EXEC [dm_yg1_scm].[PROC_FACT_SCM_SUPPLY_SIMULATION_PIVOT]
  EXEC [dm_yg1_scm].[PROC_FACT_PSI_INVEN_FLOW_TB]
  --EXEC [dm_yg1_scm].[PROC_FACT_PSI_INVENTORY_SUMMARY]
  EXEC [dm_yg1_scm].[PROC_FACT_SCM_CAPABALANCE_ORDER]
  EXEC [dm_yg1_scm].[PROC_FACT_SCM_CAPABALANCE_SIMULATION]
  EXEC [dm_yg1_scm].[PROC_FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS] @SP_START_EXEC
  EXEC [dm_yg1_scm].[PROC_FACT_SCM_CAPABALANCE_ORDER_N]
  INSERT INTO DW_YG1.DBO.TB_ETL_LOG
     (DB_NM   , SP_NM       , TABLE_NM  , START_DATE  , END_DATE  
     , INSERT_CNT , DELETE_CNT , UPDATE_CNT , SUCCEESS_YN , ERR_MSG   , ERR_NUM , ERR_LINE)
   VALUES (DB_NAME()  , OBJECT_NAME(@@PROCID)   , @TABLE_NM  , @SP_START_EXEC , GETDATE()
     , @INSERT_CNT , @DELETE_CNT , @UPDATE_CNT , 'Y'   , NULL    , NULL  , NULL)
   
 END TRY
 BEGIN CATCH
   
  SET @ERR_MSG = ERROR_MESSAGE()
  SET @ERR_NUM = ERROR_NUMBER()
  SET @ERR_LINE = ERROR_LINE()
  PRINT @ERR_MSG
  
  INSERT INTO DW_YG1.DBO.TB_ETL_LOG
    (DB_NM   , SP_NM       , TABLE_NM  , START_DATE  , END_DATE  
    , INSERT_CNT , DELETE_CNT , UPDATE_CNT , SUCCEESS_YN , ERR_MSG   , ERR_NUM  , ERR_LINE)
  VALUES (DB_NAME()  , OBJECT_NAME(@@PROCID)   , @TABLE_NM  , @SP_START_EXEC , GETDATE()
    , @INSERT_CNT , @DELETE_CNT , @UPDATE_CNT , 'N'   , ERROR_MESSAGE() , ERROR_NUMBER(), ERROR_LINE());
 END CATCH
END