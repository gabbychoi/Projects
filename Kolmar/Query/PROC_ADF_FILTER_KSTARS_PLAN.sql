CREATE PROC [dbo].[PROC_ADF_FILTER_KSTARS_PLAN]
 
 AS
 
 
 
 BEGIN
 
 WITH NumberedRows AS (
     SELECT
           KSTAR -- 계정명
         , ROW_NUMBER() OVER (ORDER BY KSTAR) AS RowNum -- 페이징 설정을 위한 Rownum 고정 작업
     FROM TB_SAP_ODATA_KSTARS_PLAN
 ),
 
 GroupedRows AS (
     SELECT
           KSTAR -- KSTAR 
         , (RowNum - 1) / 30 AS GroupNum -- 30개씩 묶기 위한 몫 산출 작업
     FROM NumberedRows
 )
 -- WITH 함수 종료
 
 -- 본 쿼리 시작
  SELECT
     ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS setname -- 세트 명
   , 'KSTAR eq ' + STRING_AGG(CONCAT('''',KSTAR,''''), ' or KSTAR eq ')  AS condition -- Filter condition or 기반 Odata 기본 채택
   , 'KSTAR IN ('+STRING_AGG(CONCAT('''',KSTAR,''''), ',')+')' as VALIDWHERE_RFC  --Filter Condition In 기반 RFC 필요시 채택.
 
  FROM GroupedRows
  GROUP BY 
     GroupNum;
 -- 본 쿼리 종료
 
 END
