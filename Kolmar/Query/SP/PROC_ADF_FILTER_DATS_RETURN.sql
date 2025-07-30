
 
 /*
 
 CREATED : 2025-05-28
 생성자 : 최은수
 
 
 */
 
 CREATE  PROC [dbo].[PROC_ADF_FILTER_DATS_RETURN]
 
     @Filterdatecolumn NVARCHAR(10) -- DATSCOLUMN 명칭
      , @STARTDATE INT                 --Range 입력
      , @ENDDATE INT                  --Range 입력
 AS
 
 BEGIN
 
 
 -- 필터 생성을 위한 1일과 말일 생성
 WITH FILTERDATE AS (
 
  SELECT 
         DISTINCT
      FORMAT( CALENDARDATE
          , 'yyyyMM01'
       ) AS STARTDATE
    , FORMAT( EOMONTH(CALENDARDATE)
             , 'yyyyMMdd'
       ) AS ENDDATE
  FROM dbo.TB_CALENDAR_DATE
     WHERE 1=1
     AND CalendarDateYYYYMMDD BETWEEN @STARTDATE AND @ENDDATE  -- 입력한 Date에 대해서만 Filter 생성 수행
 )
 -- WITH함수 종료
 
 
 --본 쿼리 시작
 --filter 파라미터 직접 생성
  SELECT 
      CONCAT( '$filter='
       , @Filterdatecolumn    --filter 컬럼 명 입력
       , ' ge '''
       , STARTDATE            --Range 범위 시작
       ,  ''' AND '
       , @Filterdatecolumn    --filter 컬럼 명 입력
       , ' le '''
       , ENDDATE              --Range 범위 끝
       , ''''
       ) AS [FILTER]
  FROM FILTERDATE;
 
 END
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
