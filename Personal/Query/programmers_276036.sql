-- https://school.programmers.co.kr/learn/courses/30/lessons/276036

-- 코드를 입력하세요

WITH SPLITED AS(
        SELECT 
        d.ID
        ,d.EMAIL
        ,s.code AS unit

        -- ID Code 를 기준 2의 배수 꼴이므로 코드의 2배에 대한 모듈로 나머지 값을 나누어 Amount 를 구한다.
        ,((d.SKILL_CODE MOD (s.code * 2)) DIV s.code) AS amount
        FROM DEVELOPERS d
        CROSS JOIN SKILLCODES S
         WHERE ((d.SKILL_CODE MOD (s.code * 2)) DIV s.code)>0

    ), AGRADES AS (
        -- A Grade 선평가 작업.
        SELECT DISTINCT 
        'A' as grade 
        ,ID
        ,EMAIL
        FROM SPLITED A
        JOIN SKILLCODES B
        ON A.Unit=B.CODE
        WHERE 1=1
            AND B.CATEGORY='Front End'
            AND A.ID IN (
                        SELECT DISTINCT  
                            ID
                        FROM SPLITED A
                        JOIN SKILLCODES B
                        ON A.Unit=B.CODE
                        WHERE B.NAME='Python')
    ),BGRADES AS(
    
        -- B Grade 선평가 작업.
        SELECT DISTINCT 
            'B' as grade 
            ,ID
            ,EMAIL
        FROM SPLITED A
        JOIN SKILLCODES B
        ON A.Unit=B.CODE
        WHERE 1=1
            AND B.NAME='C#'
            AND A.ID NOT IN (SELECT ID FROM AGRADES)
        -- C# 과 python Front 모두 역량을 가진 개발자는 A 로 분류해야 하기에 이 경우를 빼줌.
    
    ),CGRADES AS (
    
        SELECT DISTINCT 
            'C' as grade 
            ,ID
            ,EMAIL
        FROM SPLITED A
        JOIN SKILLCODES B
        ON A.Unit=B.CODE
        WHERE 1=1 
            AND B.CATEGORY='Front End'
            AND A.ID NOT IN (SELECT ID 
                             FROM AGRADES 
                             UNION ALL 
                             SELECT ID 
                             FROM BGRADES)
    -- Front 의 경우 C#, python 을 가진 경우는 제외해야 하기에 해당 과정을 진행해준다.
    )
    SELECT 
         GRADE
        ,ID
        ,EMAIL
    FROM AGRADES
    UNION ALL
    SELECT 
         GRADE
        ,ID
        ,EMAIL
    FROM BGRADES
    UNION ALL
    SELECT 
         GRADE
        ,ID
        ,EMAIL
    FROM CGRADES
    ORDER BY GRADE,ID;
    -- UNION 해 준 뒤 GRADE 와 ID 순으로 정렬한다.