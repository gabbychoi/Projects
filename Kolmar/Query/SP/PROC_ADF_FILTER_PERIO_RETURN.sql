

 
 
 /*
 
 CREATED : 2025-05-29
 생성자 : 최은수
 
 
 */
 
 CREATE  PROC [dbo].[PROC_ADF_FILTER_PERIO_RETURN]
  -- DATSCOLUMN 명칭
  @Filteryearcolumn VARCHAR(20),
  @FilterMonthcolumn VARCHAR(20),
  --Range 입력
  @STARTDATE INT,
  @ENDDATE INT,
  @ROWCOUNT INT
 
 AS
 
 BEGIN
 
 
 -- 필터 생성을 위한 1일과 말일 생성
 WITH FILTERDATE AS (
 
  SELECT DISTINCT
   YEAR(CALENDARDATE) as PERIO_Y
   ,MONTH(CALENDARDATE) as PERIO_M
 
 
  FROM [dbo].[TB_CALENDAR_DATE]
  -- 입력한 Date에 대해서만 Filter 생성 수행
   WHERE 1=1
      AND [CalendarDateYYYYMMDD] BETWEEN @STARTDATE AND @ENDDATE
 
 )
 --filter 파라미터 직접 생성
  SELECT 
    CONCAT('?$filter='
     ,@Filteryearcolumn    --filter 컬럼 명 입력
     ,' eq '''
     ,PERIO_Y            --Range 범위 시작
     ,''' and ',
     @FilterMonthcolumn
     ,' eq '''
     ,PERIO_M
     ,'''&$top=',@ROWCOUNT) AS [FILTER]
  FROM FILTERDATE;
 
 
 END
 
