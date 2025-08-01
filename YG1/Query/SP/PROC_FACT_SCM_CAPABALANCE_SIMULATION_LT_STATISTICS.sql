USE [DM_YG1]
GO

/****** Object:  StoredProcedure [dm_yg1_scm].[PROC_FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS]    Script Date: 2025-07-25 오후 12:39:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/****************************************************************************************************************

	
******************************************************************************************************************/
CREATE PROCEDURE [dm_yg1_scm].[PROC_FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS]
@SIMULATION_DT DATE
AS
BEGIN

	
	--공통변수
	DECLARE @SP_START_EXEC		DATETIME = GETDATE()	-- SP 실행시작시간
	DECLARE @INSERT_CNT	INT = 0			-- INSERT 건수
	DECLARE @UPDATE_CNT	INT = 0			-- UPDATE 건수
	DECLARE @DELETE_CNT	INT = 0			-- DELETE 건수
	DECLARE	@TABLE_NM	VARCHAR(50) = 'FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS'	-- TARGET TABLE NAME
	DECLARE @ERR_MSG	VARCHAR(4000)
	DECLARE @ERR_NUM	NVARCHAR(20)
	DECLARE @ERR_LINE	INT
	DECLARE @ERSDA INT =FORMAT(@SIMULATION_DT,'yyyyMMdd')

	
	
	DECLARE @COMPANY_CD	VARCHAR(12)	= '1000'	-- 회사코드 (SAP 필드명 : BUKRS) 

	BEGIN TRY

		-- 
		DELETE FROM dm_yg1_scm.FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS
		WHERE SAP_LOAD_DATE=@ERSDA

		DELETE FROM dm_yg1_scm.FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS_WORKCENTER
		WHERE SAP_LOAD_DATE=@ERSDA
		
		DELETE FROM [dm_yg1_scm].[FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS_WORKCENTER_MFG]
		WHERE SAP_LOAD_DATE=@ERSDA

		DELETE FROM dm_Yg1_Scm.FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS_SUMAMRY
		WHERE SAP_LOAD_DATE=@ERSDA

		DROP TABLE IF EXISTs #TFACT_SCM_CAPABALANCE_SIMULATION
		
		SELECT *
		INTO #TFACT_SCM_CAPABALANCE_SIMULATION
		FROM(
		SELECT A.[WORK_CENTER],ETL_TIME,CLIENT,SAP_LOAD_DATE,
			   SUM(OPERATION_HOUR)/MAX([CAPA_PER_WEEK]) AS LT
			   ,SUM(OPERATION_QTY) AS TARGET_QTY
		FROM [dm_yg1_scm].[FACT_SCM_CAPABALANCE_SIMULATION] A WITH(NOLOCK)
		JOIN (
		sELECT WORK_CENTER,WORK_CENTER_COUNT * CORRECTION_RATE*20*6*60 AS [CAPA_PER_WEEK]
		FROM [dm_yg1_scm].[DIM_SCM_WORKCENTER_CAPACITY]  WITH(NOLOCK)) B 
		ON A.WORK_CENTER=B.WORK_CENTER
		WHERE 1=1
		AND sap_load_date=@ERSDA
  
		  GROUP BY CLIENT,SAP_LOAD_DATE,A.[WORK_CENTER] ,ETL_TIME
		  ) A
		  ;
		  

		WITH TABLE_A AS (
		SELECT CLIENT,SAP_LOAD_DATE, WORK_CENTER,MFG_GROUP
				,SUM(OPERATION_HOUR) OPER_HOUR
		
		FROM [dm_yg1_scm].[FACT_SCM_CAPABALANCE_SIMULATION]  WITH(NOLOCK)
		WHERE WORK_CENTER<>''
		AND sap_load_date=@ERSDA
		GROUP BY WORK_CENTER,MFG_GROUP,CLIENT,SAP_LOAD_DATE
		), STATIS_WORK_CENTER AS (
			SELECT 
				CLIENT,
				SAP_LOAD_DATE,
				WORK_CENTER,
				AVG(OPER_HOUR) AS Mean_Oper_Hour,
				STDEV(OPER_HOUR) AS StdDev_Oper_Hour
			FROM 
				TABLE_A
			GROUP BY 
				CLIENT,
				SAP_LOAD_DATE,
				WORK_CENTER
		), NORMALIZED_STATIS_WORK_CENTER AS (

		SELECT 
		A.CLIENT,
		A.SAP_LOAD_DATE,
		A.WORK_CENTER,
		A.MFG_GROUP,
		(OPER_HOUR-Mean_Oper_Hour)/StdDev_Oper_Hour as NORM_VALUE
		FROM TABLE_A A
		JOIN STATIS_WORK_CENTER B
		ON A.WORK_CENTER=B.WORK_CENTER
		)
		, STATIS_MFG_GROUP AS (
			SELECT 
				CLIENT,
				SAP_LOAD_DATE,
				MFG_GROUP,
				AVG(OPER_HOUR) AS Mean_Oper_Hour,
				STDEV(OPER_HOUR) AS StdDev_Oper_Hour
			FROM 
				TABLE_A
			GROUP BY 
				CLIENT,
				SAP_LOAD_DATE,
				MFG_GROUP
		), NORMALIZED_STATIS_MFG_GROUP AS (

		SELECT 
		A.CLIENT,
		A.SAP_LOAD_DATE,
		A.MFG_GROUP,
		A.WORK_CENTER,
		(OPER_HOUR-Mean_Oper_Hour)/StdDev_Oper_Hour as NORM_VALUE
		FROM TABLE_A A
		JOIN STATIS_MFG_GROUP B
		ON A.MFG_GROUP=B.MFG_GROUP
		)
		INSERT INTO [dm_yg1_scm].[FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS_WORKCENTER_MFG]
		SELECT 
		CLIENT,
		SAP_LOAD_DATe,
		'WORK_CENTER' as STAT_FLAG,
		WORK_CENTER,
		MFG_GROUP,
		NORM_VALUE,
		@SP_START_EXEC
		FROM NORMALIZED_STATIS_WORK_CENTER
		UNION ALL
		SELECT 
		CLIENT,
		SAP_LOAD_DATe,
		'MFG' as STAT_FLAG,
		MFG_GROUP,
		WORK_CENTER,
		NORM_VALUE,
		@SP_START_EXEC
		FROM NORMALIZED_STATIS_MFG_GROUP;
		




		-- 주간 워크센터 통계정보 입력 쿼리
		INSERT INTO dm_yg1_scm.FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS
		SELECT 
		CLIENT,
		SAP_LOAD_DATE,
		AVG([squaremultiple]) as LT_VARIANT,
		SQRT(AVG([squaremultiple])) AS LT_SIGMA
		,MAX(MU) AS LT_EXPECTATION
		,NULL
		,ETL_TIME

		FROM(

		SELECT * ,(SELECT AVG(LT) FROM #TFACT_SCM_CAPABALANCE_SIMULATION) as [mu]
		,square(LT-(SELECT AVG(LT) FROM #TFACT_SCM_CAPABALANCE_SIMULATION)) as [squaremultiple]
		FROM #TFACT_SCM_CAPABALANCE_SIMULATION
				) A
		GROUP BY 
		CLIENT,
		SAP_LOAD_DATE,ETL_TIME

		SELECT *
		FROM #TFACT_SCM_CAPABALANCE_SIMULATION
		--주간 카파시티 조회 쿼리

		update dm_yg1_scm.FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS

		SET LT_FULFILLMENT_RATE=(
		SELECT OPERATION_HOUR/CAPA_PER_WEEK AS CAPA
		FROM(
			SELECT SUM(OPERATION_HOUR) AS OPERATION_HOUR
			FROM [dm_yg1_scm].[FACT_SCM_CAPABALANCE_SIMULATION] 
			where SAP_LOAD_DATE=@ERSDA
			) A
			JOIN 
			(
		SELECT SUM(WORK_CENTER_COUNT * CORRECTION_RATE*20*6*60) AS [CAPA_PER_WEEK]
		FROM [dm_yg1_scm].[DIM_SCM_WORKCENTER_CAPACITY] 
			) B
			ON 1=1 
			)			where SAP_LOAD_DATE=@ERSDA

		-- 워크센터별 통계
		INSERT INTO dm_yg1_scm.FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS_WORKCENTER
		SELECT 
		CLIENT,
		SAP_LOAD_DATE,
		WORK_CENTER,
		LT,
		TARGET_QTY,
		ETL_TIME
		FROM #TFACT_SCM_CAPABALANCE_SIMULATION
		
		INSERT INTO dm_Yg1_Scm.FACT_SCM_CAPABALANCE_SIMULATION_LT_STATISTICS_SUMAMRY
		SELECT 
		CLIENT,
		SAP_LOAD_DATE,

		'MFG' AS DIM,

		STDEV(LT) as STDDEV_MFG,
		AVG(LT) AS AVG_MFG,
		MAX(LT) AS MAX_MFG,
		MIN(LT) AS MIN_MFG,
		@SP_START_EXEC


		FROM (

		SELECT MFG_GROUP,CLIENT,SAP_LOAD_DATE,
		SUM(LT) LT
		FROM(
		SELECT CLIENT,SAP_LOAD_DATE,A.WORK_CENTER, MFG_GROUP
					,SUM(OPERATION_HOUR)/AVG(CAPA_SCORE) AS  LT
		
			FROM dm_yg1.[dm_yg1_scm].[FACT_SCM_CAPABALANCE_SIMULATION] A
			JOIN (SELECT WORK_CENTER,WORK_CENTER_COUNT*CORRECTION_RATE*20*6*60 AS CAPA_SCORE 
			FROM dm_yg1.[dm_yg1_scm].[DIM_SCM_WORKCENTER_CAPACITY]) B
			ON A.WORK_CENTER=B.WORK_CENTER
			WHERE SAP_LOAD_DATE=@ERSDA
			group by CLIENT,SAP_LOAD_DATE,A.WORK_CENTER,MFG_GROUP
			) a
			GROUP BY MFG_GROUP,CLIENT,SAP_LOAD_DATE

			)A

		GROUP BY 
		CLIENT,
		SAP_LOAD_DATE
		UNION ALL


		SELECT 
		
		CLIENT,
		SAP_LOAD_DATE,
		'WORK_CENTER' AS DIM,

		STDEV(LT) as STDDEV_MFG,
		AVG(LT) AS AVG_MFG,
		MAX(LT) AS MAX_MFG,
		MIN(LT) AS MIN_MFG,
		@SP_START_EXEC



		FROM (

		SELECT WORK_CENTER,CLIENT,SAP_LOAD_DATE,
		SUM(LT) LT
		FROM(
		SELECT A.WORK_CENTER,CLIENT,SAP_LOAD_DATE
					,SUM(OPERATION_HOUR)/AVG(CAPA_SCORE) AS  LT
		
			FROM dm_yg1.[dm_yg1_scm].[FACT_SCM_CAPABALANCE_SIMULATION] A
			JOIN (SELECT WORK_CENTER,WORK_CENTER_COUNT*CORRECTION_RATE*20*6*60 AS CAPA_SCORE 
			FROM dm_yg1.[dm_yg1_scm].[DIM_SCM_WORKCENTER_CAPACITY]) B
			ON A.WORK_CENTER=B.WORK_CENTER
			WHERE SAP_LOAD_DATE=@ERSDA
			group by A.WORK_CENTER,CLIENT,SAP_LOAD_DATE
			) a
			GROUP BY WORK_CENTER,CLIENT,SAP_LOAD_DATE

			)A
			
		GROUP BY 
		CLIENT,
		SAP_LOAD_DATE


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


