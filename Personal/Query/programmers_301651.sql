
--Q. https://school.programmers.co.kr/learn/courses/30/lessons/301651



WITH RECURSIVE tree_cte AS (
    SELECT id, parent_id, 1 AS level
    FROM ECOLI_DATA
    WHERE  PARENT_ID IS NULL -- 루트 노드
    UNION ALL
    SELECT t.ID, t.PARENT_ID, cte.LEVEL + 1 -- 기존의 Level 에 +1 을 해줌.
    FROM ECOLI_DATA t
    
    INNER JOIN tree_cte cte  -- Recursive Join 단계
    ON t.PARENT_ID = cte.ID
), main as(
SELECT id,parent_id,level

from tree_cte  
where parent_id is not null  -- 최초 개체만 제외하고 대장균 정보를 모두 가져옵니다.

)

select 

count(id) as count, 
level as GENERATION

from(
    

-- 자식이 없는 개체
select id,level

from main
where id not in (select parent_id from main) 

union all

-- 독립 개체
SELECT id,level

fROM tree_cte
where parent_id is null 
and id not in (select parent_id from ECOLI_DATA
              where parent_id is not null
              ) 
)  a
GROUP BY level

order by level