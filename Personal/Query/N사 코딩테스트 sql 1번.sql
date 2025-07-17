/*

통화시간 구하기.

A통신사에서는 통화시간이 일정 시간이 넘는 사람들을 선별해 특별한 이벤트를 열고자 한다. 
통화시간을 일정 기준을 충족하는 사람에게 프로모션을 위해 그 인원을 파악하기 위한 쿼리를 짜고자 한다.

테이블 구조는 다음과 같다.


CREATE TABLE PHONES (
NAME VARCHAR(30) NOT NULL,
PHONE_NUMBER INT NOT NULL UNIQUE
)


CREATE TABLE CALLES (
ID INT NOT NULL PRIMARY KEY,
CALLER int NOT NULL,
CALLEE INT NOT NULL,
DURATION INT NOT NULL
)

CALLER CALLEE 는 수신자,발신자 번호이며 DURATION은 통화시간(분) 이다.
여기서 우리는 CALLEE, CALLER를 모두 포함해 총합 10분이상의 DURATION을 지니는
사람의 NAME을 알고자 한다.
출력은 NAME을 기준으로 정렬되어야 한다.

*/

ALTER TABLE PHONES 
ADD CONSTRAINT PK_PHONES 
PRIMARY KEY(PHONE_NUMBER);
-- PK 를 NAME PHONE_NUMBER 순으로 구성할 경우 정렬의 필요성이 사라지지만, 
-- PK를 이용한 조인이 작동하지 않게 됩니다. 
-- 따라서 Name을 빼고 PHONE NUMBER 로만 PK를 구성하겠습니다.
-- 실제 환경에서는 두 방식에 대한 비교가 필요하지만 
-- 현재는 스캔 효율성을 우선시해 다음과 같이 구성합니다.

CREATE INDEX IX_CALLER 
ON CALLS (CALLER);
--발신자에 대한 인덱스입니다.
CREATE INDEX IX_CALLEE 
ON CALLS (CALLEE);
--수신자 스캔을 위한 인덱스입니다.

SELECT B.NAME
FROM(

SELECT
A.NAME
,B.Duration
FROM PHONES A
JOIN calls B
ON A.PHONE_NUMBER=B.CALLER

UNION ALL
-- 두 조건을 따로 수행하며 각각의 인덱스를 통해 스캔을 하게 됩니다.
SELECT 
A.NAME
,B.Duration
FROM PHONES A
JOIN calls B
ON A.PHONE_NUMBER=B.CALLEE

) B
GROUP BY B.NAME
HAVING SUM(DURATION)>=10
ORDER BY B.NAME
--언급한것과 같이 정렬조건을 줍니다. name이 선행으로 오면 이 과정이 필요없게 되는 대신 스캔 효율성이 저하됩니다.
-- 쟁점 : caller 와 callee 를 세로로 둔 cte 구성시


GO

WITH CTE AS (

SELECT Caller as phone_number,  duration
from Calls
union all

SELECT CAllee, duration
from calls

)

SELECT
A.NAME
FROM PHONES A
JOIN CTE B
ON A.PHONE_NUMBER=B.PHONE_NUMBER
GROUP BY A.NAME
HAVING SUM(B.DURATION)>=10 