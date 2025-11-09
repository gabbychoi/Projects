
--Q. https://school.programmers.co.kr/learn/courses/30/lessons/157339




-- 코드를 입력하세요
WITH CTE AS (
SELECT 
    A.car_id,
    B.car_type,
    30*DAILY_FEE as total_cost
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY A
JOIN CAR_RENTAL_COMPANY_CAR B
ON A.car_id=B.car_id
WHERE B.car_type in ('SUV','세단')
group by 
    A.car_id,
    B.car_type
having
        max(end_date) <'2022-11-01'
    or min(start_date) >='2022-12-01'
    
    
UNION ALL

SELECT 
    car_id,
    car_type,
    30*DAILY_FEE as total_cost
FROM CAR_RENTAL_COMPANY_CAR 
where car_id not in (select car_id from CAR_RENTAL_COMPANY_RENTAL_HISTORY)
and car_type in ('SUV','세단')
    
    
    ) 
, MAIN AS(

SELECT 
A.car_id,
A.car_type,
total_cost*(1-DISCOUNT_RATE*0.01) as total_cost

FROM CTE A
JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN  B
ON A.car_type=B.car_type
AND B.DURATION_TYPE='30일 이상'
AND total_cost*(1-DISCOUNT_RATE*0.01) between 500000 and 2000000

    
    )
    
SELECT 
car_id,
CAR_TYPE,
    convert(total_cost , UNSIGNED) AS FEE
FROM MAIN
order by total_cost desc,car_type asc,car_id desc 


    