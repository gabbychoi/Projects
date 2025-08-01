USE [DM_YG1]
GO

/****** Object:  StoredProcedure [dm_yg1_scm].[PROC_FACT_SCM_SUPPLY_SIMULATION_TB_ROUTING]    Script Date: 2025-07-25 오후 12:42:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/****************************************************************************************************************
SP 명		: PROC_FACT_SCM_SUPPLY_SIMULATION_TB_ROUTING
SP 제목		: 조달생산가시화 라우팅 정보
최초작성자	: 최은수
최초작성일	: 2024.10.25


	
******************************************************************************************************************/
CREATE PROCEDURE [dm_yg1_scm].[PROC_FACT_SCM_SUPPLY_SIMULATION_TB_ROUTING]

AS
BEGIN

	
	--공통변수
	DECLARE @SP_START_EXEC		DATETIME = GETDATE()	-- SP 실행시작시간
	DECLARE @INSERT_CNT	INT = 0			-- INSERT 건수
	DECLARE @UPDATE_CNT	INT = 0			-- UPDATE 건수
	DECLARE @DELETE_CNT	INT = 0			-- DELETE 건수
	DECLARE	@TABLE_NM	VARCHAR(50) = 'FACT_SCM_SUPPLY_SIMULATION_TB_ROUTING'	-- TARGET TABLE NAME
	DECLARE @ERR_MSG	VARCHAR(4000)
	DECLARE @ERR_NUM	NVARCHAR(20)
	DECLARE @ERR_LINE	INT

	
	
	DECLARE @COMPANY_CD	VARCHAR(12)	= '1000'	-- 회사코드 (SAP 필드명 : BUKRS) 

	BEGIN TRY

	DELETE FROM DM_YG1.dm_yg1_scm.FACT_SCM_SUPPLY_SIMULATION_TB_ROUTING
	WHERE SAP_LOAD_DATE IN (SELECT ERSDA
	FROM DW_YG1.scm.TB_DW_DIM_ZDWT005_COOIS WITH(NOLOCK)
	WHERE ERSDA=(SELECT MAX(ERSDA) FROM  DW_YG1.scm.TB_DW_DIM_ZDWT005_COOIS WITH(NOLOCK))
	)
	SET @DELETE_CNT+=@@ROWCOUNT


	INSERT INTO DM_YG1.dm_yg1_scm.FACT_SCM_SUPPLY_SIMULATION_TB_ROUTING
	        ([CLIENT]
           ,[SAP_LOAD_DATE]
           ,[PO]
           ,[REMAINED_LT]
           ,[WORK_COUNT]
           ,[WORK_CENTER_TEXT]
           ,[WORK_STATUS]
           ,[WORK_DATE]
           ,[STATUS]
           ,[ETL_DATE]
		   ,AUFPL
		   ,APLZL)

	SELECT 
	B.MANDT AS CLIENT,
	B.ERSDA AS SAP_LOAD_DATE,
	B.AUFNR PO,

	CASE WHEN A.SSELD>'00000000' THEN (MAXAPLZL-A.APLZL)*5  ELSE MAXAPLZL END REMAINED_LT,
	MAXAPLZL as WORK_COUNT,
	B.KTSCH WORK_CENTER_TEXT,
	B.VORNR WORK_STATUS,
	A.SSELD WORK_DATE,
	CASE WHEN CONVERT(VARCHAR,A.VORNR)='00'+CONVERT(VARCHAR,B.VORNR) THEN '현공정' ELSE NULL END [STATUS],
	@SP_START_EXEC AS ETL_DATE
	,B.AUFPL
	,B.APLZL
	FROM DW_YG1.scm.TB_DW_FACT_ZDWT005_ROUTING_TB B WITH(NOLOCK)
	LEFT OUTER JOIN
	 (
	SELECT A.*,CASE WHEN A.VORNR='REL' THEN 0
	WHEN A.VORNR IS NOT NULL THEN APLZL
	ELSE 999 END AS APLZL
	FROM DW_YG1.scm.TB_DW_FACT_ZDWT006_Z25PP031 A WITH(NOLOCK)
	LEFT OUTER JOIN DW_YG1.scm.TB_DW_FACT_ZDWT005_ROUTING_TB B WITH(NOLOCK)
	ON A.MANDT=B.MANDT AND A.VORNR=FORMAT(B.VORNR,'0000') AND A.AUFNR=B.AUFNR AND A.ERSDA=B.ERSDA
	) A 
	ON A.MANDT=B.MANDT AND A.AUFNR=B.AUFNR AND A.ERSDA=B.ERSDA -- AND A.KTSCH=B.KTSCH 
	LEFT OUTER JOIN ( SELECT AUFNR, MANDT,ERSDA,COUNT(1) AS WORK_COUNT FROM DW_YG1.scm.TB_DW_FACT_ZDWT005_ROUTING_TB  WITH(NOLOCK)
	GROUP BY AUFNR, MANDT,ERSDA) C
	ON A.MANDT=C.MANDT AND A.AUFNR=C.AUFNR AND A.ERSDA=C.ERSDA
	LEFT OUTER JOIN(
	SELECT MANDT,ERSDA,AUFNR, MAX(APLZL) as MAXAPLZL
	FROM DW_YG1.scm.TB_DW_FACT_ZDWT005_ROUTING_TB WITH(NOLOCK)
	GROUP BY MANDT,ERSDA,AUFNR)  D
	ON A.MANDT=D.MANDT AND A.AUFNR=D.AUFNR AND A.ERSDA=D.ERSDA

	WHERE A.ERSDA=(SELECT MAX(ERSDA) FROM  DW_YG1.scm.TB_DW_DIM_ZDWT005_COOIS WITH(NOLOCK))
	
	
	SET @INSERT_CNT+=@@ROWCOUNT

	
	UPDATE dm_yg1_scm.FACT_SCM_SUPPLY_SIMULATION_TB_ROUTING

	SET REMAINED_LT=0
	WHERE REMAINED_LT<0
	
	SET @UPDATE_CNT=@@ROWCOUNT
	


	UPDATE A

	SET WORK_PROCESS=
	CASE WHEN B.WORK_STATUS>A.WORK_STATUS THEN '이전 공정'
	WHEN B.WORK_STATUS<A.WORK_STATUS THEN '이후 공정'
	ELSE '현공정' END
	FROM DM_YG1.dm_yg1_scm.FACT_SCM_SUPPLY_SIMULATION_TB_ROUTING  A WITH(NOLOCK)

	JOIN (
	SELECT CLIENT,SAP_LOAD_DATE,PO,WORK_STATUS
	FROM DM_YG1.dm_yg1_scm.FACT_SCM_SUPPLY_SIMULATION_TB_ROUTING WITH(NOLOCK)
	WHERE [STATUS] ='현공정'
	) B
	ON A.PO=B.PO AND A.CLIENT=B.CLIENT AND A.SAP_LOAD_DATE=B.SAP_LOAD_DATE
	WHERE A.SAP_LOAD_DATE=(SELECT MAX(ERSDA) FROM  DW_YG1.scm.TB_DW_DIM_ZDWT005_COOIS WITH(NOLOCK))
	
	SET @UPDATE_CNT+=@@ROWCOUNT

	UPDATE A

	SET WORK_PROCESS= '미투입'
	FROM DM_YG1.dm_yg1_scm.FACT_SCM_SUPPLY_SIMULATION_TB_ROUTING  A WITH(NOLOCK)
	WHERE 1=1 
	AND WORK_PROCESS IS NULL 
	AND A.SAP_LOAD_DATE=(SELECT MAX(ERSDA) FROM  DW_YG1.scm.TB_DW_DIM_ZDWT005_COOIS WITH(NOLOCK))

	SET @UPDATE_CNT+=@@ROWCOUNT




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


