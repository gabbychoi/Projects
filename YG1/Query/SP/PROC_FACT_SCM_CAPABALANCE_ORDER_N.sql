USE [DM_YG1]
GO

/****** Object:  StoredProcedure [dm_yg1_scm].[PROC_FACT_SCM_CAPABALANCE_ORDER_N]    Script Date: 2025-07-25 오후 12:36:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







/****************************************************************************************************************
SP 명		: PROC_FACT_SCM_CAPABALANCE_ORDER_N
SP 제목		: CAPABALANCE Table Insert
최초작성자	: 최은수
최초작성일	: 2024.12.22

			 

	
******************************************************************************************************************/

CREATE   PROCEDURE [dm_yg1_scm].[PROC_FACT_SCM_CAPABALANCE_ORDER_N]
AS
BEGIN

	
	--공통변수
	DECLARE @SP_START_EXEC		DATETIME = GETDATE()	-- SP 실행시작시간
	DECLARE @INSERT_CNT	INT = 0			-- INSERT 건수
	DECLARE @UPDATE_CNT	INT = 0			-- UPDATE 건수
	DECLARE @DELETE_CNT	INT = 0			-- DELETE 건수
	DECLARE	@TABLE_NM	VARCHAR(50) = 'FACT_SCM_CAPABALANCE_ORDER'	-- TARGET TABLE NAME
	DECLARE @ERR_MSG	VARCHAR(4000)
	DECLARE @ERR_NUM	NVARCHAR(20)
	DECLARE @ERR_LINE	INT
	DECLARE @ERSDA INT =(SELECT MAX(ERSDA) FROM  DW_YG1.scm.TB_DW_FACT_ZDWT005_ROUTING_TB WITH(NOLOCK))
	DECLARE @PREV_DAY INT =(SELECT MAX(ERSDA) FROM  DW_YG1.scm.TB_DW_FACT_ZDWT005_ROUTING_TB WITH(NOLOCK)
	WHERE ERSDA<@ERSDA
	)
	
	
	
	DECLARE @COMPANY_CD	VARCHAR(12)	= '1000'	-- 회사코드 (SAP 필드명 : BUKRS) 

	BEGIN TRY

	DELETE FROM DM_YG1.dm_yg1_scm.[FACT_SCM_CAPABALANCE_ORDER_N]
	WHERE [SAP_LOAD_DATE]=@ERSDA
	SET @DELETE_CNT=@@ROWCOUNT


	
INSERT INTO  dm_yg1_scm.FACT_SCM_CAPABALANCE_ORDER_N
(
	   [CLIENT]
      ,[SAP_LOAD_DATE]
      ,[PO]
      ,[PO_TYPE]
      ,[KTSCH]
      ,[WORK_CENTER]
      ,[VORNR]
      ,[APLZL]
      ,[MFG_GROUP]
      ,[MATNR]
      ,[LT]
      ,[LTXA1]
      ,[OPERATION_QTY]
      ,[WORK_YEAR]
      ,[WORK_WEEK]
      ,[ERDAT]
      ,[RDD]
      ,[ETL_TIME]
	  )
	  SELECT 
	  [CLIENT]
      ,@ERSDA
      ,[PO]
      ,'이전 매칭 작번'
      ,[KTSCH]
      ,[WORK_CENTER]
      ,[VORNR]
      ,[APLZL]
      ,[MFG_GROUP]
      ,[MATNR]
      ,[LT]
      ,[LTXA1]
      ,[OPERATION_QTY]
      ,[WORK_YEAR]
      ,[WORK_WEEK]
      ,[ERDAT]
      ,[RDD]
      ,[ETL_TIME]

	  FROM  dm_yg1_scm.FACT_SCM_CAPABALANCE_ORDER_N WITH(NOLOCK)
	  WHERE SAP_LOAD_DATE=@PREV_DAY


	  /*

	DELETE FROM dm_yg1_scm.FACT_SCM_CAPABALANCE_ORDER_N
	WHERE SAP_LOAD_DATE=@SAP_LOAD_DATE
	AND PO IN (SELECT PO FROM dm_yg1_scm.FACT_SCM_CAPABALANCE_ORDER WHERE SAP_LOAD_DATE=@SAP_LOAD_DATE)
	
	INSERT INTO  dm_yg1_scm.FACT_SCM_CAPABALANCE_ORDER_N
	(
	   [CLIENT]
      ,[SAP_LOAD_DATE]
      ,[PO]
      ,[PO_TYPE]
      ,[KTSCH]
      ,[WORK_CENTER]
      ,[VORNR]
      ,[APLZL]
      ,[MFG_GROUP]
      ,[MATNR]
      ,[LT]
      ,[LTXA1]
      ,[OPERATION_QTY]
      ,[WORK_YEAR]
      ,[WORK_WEEK]
      ,[ERDAT]
      ,[RDD]
      ,[ETL_TIME]
	  )
	  SELECT 
	  [CLIENT]
      ,@SAP_LOAD_DATE
      ,[PO]
      ,'신규 작번'
      ,[KTSCH]
      ,[WORK_CENTER]
      ,[VORNR]
      ,[APLZL]
      ,[MFG_GROUP]
      ,[MATNR]
      ,[LT]
      ,[LTXA1]
      ,[OPERATION_QTY]
      ,[WORK_YEAR]
      ,[WORK_WEEK]
      ,[ERDAT]
      ,[RDD]
      ,[ETL_TIME]

	  FROM  dm_yg1_scm.FACT_SCM_CAPABALANCE_ORDER
	  WHERE SAP_LOAD_DATE=@SAP_LOAD_DATE

	  UPDATE A
	  SET PO_TYPE='이전 매칭 작번'

	  FROM dm_yg1_scm.FACT_SCM_CAPABALANCE_ORDER_N A
	  JOIN dm_yg1_scm.FACT_SCM_CAPABALANCE_ORDER_N B
	  ON A.PO=B.PO AND A.SAP_LOAD_DATE=@SAP_LOAD_DATE
	  AND B.SAP_LOAD_DATE=@PREV_DAY

	  */


	  MERGE INTO dm_yg1_scm.FACT_SCM_CAPABALANCE_ORDER_N A


	  USING (

	  SELECT *
	  FROM dm_yg1_scm.FACT_SCM_CAPABALANCE_ORDER WITH(NOLOCK)
	  WHERE SAP_LOAD_DATE=@ERSDA
	  
	  ) B
	  ON A.SAP_LOAD_DATE=B.SAP_LOAD_DATE
	  AND A.PO=B.PO
	  AND A.APLZL=B.APLZL
	  WHEN MATCHED THEN

	  UPDATE
		SET 
	   [CLIENT]=B.[CLIENT]
      ,[SAP_LOAD_DATE]=@ERSDA
      ,[PO]=B.[PO]
      ,[PO_TYPE]='이전 매칭 작번'
      ,[KTSCH]=B.[KTSCH]
      ,[WORK_CENTER]=B.[WORK_CENTER]
      ,[VORNR]=B.[VORNR]
      ,[APLZL]=B.[APLZL]
      ,[MFG_GROUP]=B.[MFG_GROUP]
      ,[MATNR]=B.[MATNR]
      ,[LT]=B.[LT]
      ,[LTXA1]=B.[LTXA1]
      ,[OPERATION_QTY]=B.[OPERATION_QTY]
      ,[WORK_YEAR]=B.[WORK_YEAR]
      ,[WORK_WEEK]=B.[WORK_WEEK]
      ,[ERDAT]=B.[ERDAT]
      ,[RDD]=B.[RDD]
      ,[ETL_TIME]=B.[ETL_TIME]
	  WHEN NOT MATCHED THEN

	  INSERT (
	   [CLIENT]
      ,[SAP_LOAD_DATE]
      ,[PO]
      ,[PO_TYPE]
      ,[KTSCH]
      ,[WORK_CENTER]
      ,[VORNR]
      ,[APLZL]
      ,[MFG_GROUP]
      ,[MATNR]
      ,[LT]
      ,[LTXA1]
      ,[OPERATION_QTY]
      ,[WORK_YEAR]
      ,[WORK_WEEK]
      ,[ERDAT]
      ,[RDD]
      ,[ETL_TIME]
	  )VALUES(
	   B.[CLIENT]
      ,@ERSDA
      ,B.[PO]
      ,'신규 작번'
      ,B.[KTSCH]
      ,B.[WORK_CENTER]
      ,B.[VORNR]
      ,B.[APLZL]
      ,B.[MFG_GROUP]
      ,B.[MATNR]
      ,B.[LT]
      ,B.[LTXA1]
      ,B.[OPERATION_QTY]
      ,B.[WORK_YEAR]
      ,B.[WORK_WEEK]
      ,B.[ERDAT]
      ,B.[RDD]
      ,B.[ETL_TIME]
	  )


	  ;



		SET @INSERT_CNT	= @@ROWCOUNT

		INSERT INTO DW_YG1.DBO.TB_ETL_LOG
					(DB_NM			, SP_NM							, TABLE_NM		, START_DATE		, END_DATE		
					, INSERT_CNT	, DELETE_CNT	, UPDATE_CNT	, SUCCEESS_YN	, ERR_MSG			, ERR_NUM	, ERR_LINE)
			VALUES	(DB_NAME()		, OBJECT_NAME(@@PROCID)			, @TABLE_NM		, @SP_START_EXEC	, GETDATE()
					, @INSERT_CNT	, @DELETE_CNT	, @UPDATE_CNT	, 'Y'			, NULL				, NULL		, NULL)
			
	END TRY

	BEGIN CATCH
			
		SET @ERR_MSG	= ERROR_MESSAGE()
		SET @ERR_NUM	= ERROR_NUMBER()
		SET @ERR_LINE	= ERROR_LINE()

		PRINT	@ERR_MSG
		
		INSERT INTO DW_YG1.DBO.TB_ETL_LOG
				(DB_NM			, SP_NM							, TABLE_NM		, START_DATE		, END_DATE		
				, INSERT_CNT	, DELETE_CNT	, UPDATE_CNT	, SUCCEESS_YN	, ERR_MSG			, ERR_NUM		, ERR_LINE)
		VALUES	(DB_NAME()		, OBJECT_NAME(@@PROCID)			, @TABLE_NM		, @SP_START_EXEC	, GETDATE()
				, @INSERT_CNT	, @DELETE_CNT	, @UPDATE_CNT	, 'N'			, ERROR_MESSAGE()	, ERROR_NUMBER(), ERROR_LINE());
	END CATCH
END

GO


