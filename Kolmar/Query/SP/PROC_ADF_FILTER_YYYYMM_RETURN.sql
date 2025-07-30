
 
 /*
 
 CREATED : 2025-05-28
 생성자 : 최은수
 
 
 */
 
 CREATE  PROC [dbo].[PROC_ADF_FILTER_YYYYMM_RETURN]
 
    @Filterdatecolumn NVARCHAR(20)  -- DATSCOLUMN 명칭
  , @STARTDATE INT                  --Range 입력
  , @ENDDATE INT                    --Range 입력
 
 AS
 
 BEGIN
 
 
 -- 필터 생성을 위한 1일과 말일 생성
 WITH FILTERDATE AS (
 
  SELECT 
         DISTINCT
      FORMAT( CALENDARDATE
          ,'yyyy0MM'
       ) AS STARTDATE  -- 필터링 시작 perio 포맷 기준
      
    , FORMAT( CALENDARDATE
          ,'yyyyMM'
       ) AS DELETEDATE  -- 삭제 컬럼 명시
 
  FROM dbo.TB_CALENDAR_DATE
     WHERE 1=1    -- 입력한 Date에 대해서만 Filter 생성 수행
     AND  FORMAT( CALENDARDATE
              ,'yyyyMM'
        ) BETWEEN @STARTDATE AND @ENDDATE
 )
 -- WITH 함수 종료
 
 -- 본 쿼리 시작
 --filter 파라미터 직접 생성
  SELECT 
       CONCAT(  '$filter='
         , @Filterdatecolumn    --filter 컬럼 명 입력
         , ' eq '''
         , STARTDATE               --Range 범위 끝
         , ''''
        ) AS [FILTER]
     , STARTDATE  AS ODATAFILTER
     , DELETEDATE AS DELETECOLUMN
  FROM FILTERDATE;
 
 END
 
