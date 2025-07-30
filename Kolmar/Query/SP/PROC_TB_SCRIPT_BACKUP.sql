
 CREATE PROC [dbo].[PROC_TB_SCRIPT_BACKUP]
 
 AS
 
 
 DECLARE @DATE DATE=GETDATE();
 
 DELETE FROM TB_SCRIPT_BACKUP
 WHERE BACKUPDATE<=DATEADD(day,-15,@DATE) -- 30일 이전 데이터 삭제
 OR BACKUPDATE=@DATE; -- 현재 일자 데이터가 남아있는 경우 삭제
 
 
 WITH ObjectDefinitions AS (
     SELECT
         o.name AS ObjectName,  -- 스크립트 명칭 (SP명 ,뷰 명칭)
         o.type_desc AS ObjectType,   -- 스크립트 유형( SP, VIew)
         m.definition AS ObjectDefinition -- 스크립트 텍스트
     FROM
         sys.objects o
     INNER JOIN
         sys.sql_modules m ON o.object_id = m.object_id
     WHERE
         o.type IN ('P', 'V') -- P: Stored Procedure, V: View
 )
 
 ,
 SplitLines AS (
     SELECT
         ObjectName,  -- 스크립트 명칭 (SP명 ,뷰 명칭)
         ObjectType,  -- 스크립트 유형( SP, VIew)
         ROW_NUMBER() OVER (PARTITION BY ObjectName ORDER BY (SELECT NULL)) AS LineNumber, -- 스크립트 작성 라인 순서 Order by 반드시 포함 요청
         value AS LineContent -- 라인별 definition 스크립트.
     FROM
         ObjectDefinitions
     CROSS APPLY
         STRING_SPLIT(ObjectDefinition,char(13)) -- Split by line breaks
 
 
 )
 INSERT INTO TB_SCRIPT_BACKUP
 SELECT
     ObjectName, -- 스크립트 명칭 (SP명 ,뷰 명칭)
     ObjectType, -- 스크립트 유형( SP, VIew)
     LineNumber, -- 스크립트 작성 라인 순서 Order by 반드시 포함 요청
     LineContent, -- 라인별 definition 스크립트.
  @DATE AS BACKUPDATE --백업일자
 FROM
     SplitLines
 ORDER BY
     ObjectName, LineNumber;
