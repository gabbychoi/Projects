/* balance 구하기

A 은행은 자사은행 계좌로 결제하는 카드 상품을 발급하고 있다.
카드는 월마다 fee가 5만큼 부과되는데, fee를 면제해주는 조건을 다음과같이 걸고 있다.

"월 3건 이상이며 비용 100 이상의 실적이 있는 경우 fee 를 면제한다."


이때 어떤 사용자의 2020년 1년간 실적을 다음과 같이 나타낸다 하자.

create table transactions(
amount int not null,
date date not null
)
여기서 amount 는 0이 아니며 음수는 cost, 양수는 은행을 통한 출금계좌의 입금이다.

이제 1년간 사용자의 계좌에 남을 balance를 구하여라

*/




create index ix_amount ON transactions(amount, DATE_PART('month', date));

--cost를 month 단위로 효율적으로 scan 할 수 있도록 하는 인덱스 생성. 
-- amount를 앞에 두었기에 sumamount 에서도 해당 인덱스를 활용

with fees AS(
    SELECT
    DATE_PART('month',date) as MONTH

    from transactions
    WHERE AMOUNT<0
    GROUP BY DATE_PART('month',date)
    HAVING SUM(AMOUNT)<=-100 AND COUNT(1)>=3

    -- 각각의 월에 대해 100 이상의 cost를 수행했는지와 3 회 이상의 transaction이 이루어졌는지 평가.



), sumamount as (

    SELECT SUM(AMOUNT) as AMT FROM transactions
    -- 모든 값에 대한 합계 수행
)

SELECT (select AMT from sumamount)-(select 5*(12-count(1)) from fees)
-- 계산된 AMT에 평가된 fee를 제외한 결과 출력



-- 쟁점 : 해당 partial index 로 더 빠르게 계산이 가능했는가?