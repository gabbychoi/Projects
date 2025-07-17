/* 값이 항상 증가한 상품.

A 쇼핑사는 하루에 한번 판매자가 상품가격을 변경할 수 있도록 시스템을 구축하였다.
이중 변경날짜에 모두 상품 가격이 이전 대비 증가한 제품이 있는지를 찾고자 한다.
가격 변경 이력 price_updates 테이블 구성은 다음과 같다.

product varchar(30) NOT NULL
date date NOT NULL,
PRICE INT NOT NULL

여기서 Product와 Date 의 조합은 유일하다.



*/


create index ix_price_date on price_updates(product,date)
--LAG 윈도우 함수를 빠르게 수행하기 위한 인덱스



with product_chain as(

SELECT 
    product, 
    date, 
    price, 
    LAG(date) OVER (PARTITION BY product ORDER BY date) AS prev_date
    --이전 일자에 대한 연결이 필요하며 여기서 ix_price_date의 인덱스가 사용됨.
FROM price_updates
), price_determined as (

	SELECT 
	a.product,
	case when a.price>b.price then 1 else 0 end as determined
	from price_updates b
	join product_chain a
	on a.prev_date=b.date 
	and a.product=b.product
	--마찬가지로 driving table 에서 인덱스가 활용됨

)
select product

from price_determined 
group by product
having min(determined)>0