Question 1

with temp1 as
(
	Select prod as PRODUCT, max(quant) as MAX_Q, min(quant) as MIN_Q, avg(quant) as AVG_Q
	from sales
	group by prod
),
temp2 as
(
	select temp1.PRODUCT, temp1.MAX_Q, cust as MAX_CUST, month as MAX_MONTH, day as MAX_DAY, year as MAX_YEAR, state as ST, temp1.AVG_Q, temp1.MIN_Q as MIN_Q
	from temp1,sales
	where temp1.PRODUCT = sales.prod and temp1.MAX_Q = sales.quant
)

select temp2.PRODUCT, temp2.MAX_Q, temp2.MAX_CUST, temp2.MAX_MONTH, temp2.MAX_DAY, temp2.MAX_YEAR, temp2.ST, temp2.MIN_Q, cust as MIN_CUST, month as MIN_MONTH, day as MIN_DAY, year as MIN_YEAR, state as ST, temp2.AVG_Q
from temp2,sales
where temp2.PRODUCT = sales.prod and temp2.MIN_Q = sales.quant

============================================================================================================================
Question 2

create view NY as
(
	select cust, prod, max(quant) as NY_MAX
	from sales
	where state='NY'
	group by cust, prod
	order by cust
)

create view NJ as
(
	select cust, prod, min(quant) as NJ_MIN
	from sales
	where (state='NJ' and year>2000)
	group by cust, prod
	order by cust
)

create view CT as
(
	select cust, prod, min(quant) as CT_MIN
	from sales
	where (state='CT' and year>2000)
	group by cust, prod
	order by cust
)

create view NYdata as
(
	select NY.cust as CUSTOMER, NY.prod as PRODUCT, NY.NY_MAX as NY_MAX, sales.month as MONTH, sales.day as DAY, sales.year as YEAR
	from sales, NY
	where NY.cust = sales.cust and NY.prod = sales.prod and sales.state = 'NY' and sales.quant = NY.NY_MAX
)

create view NJdata as
(
	select NJ.cust as CUSTOMER, NJ.prod as PRODUCT, NJ.NJ_MIN as NJ_MIN, sales.month as MONTH, sales.day as DAY, sales.year as YEAR
	from sales, NJ
	where NJ.cust = sales.cust and NJ.prod = sales.prod and sales.state = 'NJ' and sales.quant = NJ.NJ_MIN
)

create view CTdata as
(
	select CT.cust as CUSTOMER, CT.prod as PRODUCT, CT.CT_MIN, sales.month as MONTH, sales.day as DAY, sales.year as YEAR
	from sales,CT
	where CT.cust = sales.cust and CT.prod = sales.prod and sales.state = 'CT' and sales.quant = CT.CT_MIN
)

select *
from NYdata natural full join NJdata natural full join CTdata

============================================================================================================================
Question 3

create view totalsum as
(
	select month, prod, sum(quant) as TOTAL_QUANT
	from sales
	group by month, prod
	order by month, prod
)

create view maxsum as
(
	select totalsum.month as MONTH, totalsum.prod as MOST_POPULAR_PROD, totalsum.TOTAL_QUANT as MOST_POP_TOTAL_Q
	from totalsum
	where (totalsum.month, totalsum.TOTAL_QUANT) IN 
	(
		select totalsum.month, max(totalsum.TOTAL_QUANT)
		from totalsum
		group by totalsum.month
	)
)

select totalsum.month as MONTH, maxsum.MOST_POPULAR_PROD as MOST_POPULAR_PROD, maxsum.MOST_POP_TOTAL_Q, totalsum.prod as LEAST_POPULAR_PROD, totalsum.TOTAL_QUANT as LEAST_POP_TOTAL_Q
from totalsum, maxsum
where (totalsum.month, totalsum.TOTAL_QUANT) in
(
	select totalsum.month, min(totalsum.TOTAL_QUANT)
	from totalsum
	group by totalsum.month
) and totalsum.month = maxsum.month

============================================================================================================================
Question 4

with temp1 as
(
	select month, prod, sum(quant) as QUAN
	from sales
	group by month, prod
	order by month, prod
),
temp2 as
(
	select prod, max(temp1.QUAN) as MOST_FAV_MO, min(temp1.QUAN) as LEAST_FAV_MO
	from temp1
	group by prod
),
temp3 as
(
	select temp2.prod as prod, temp1.month as MOST_FAV_MO
	from temp1, temp2
	where temp1.QUAN = temp2.MOST_FAV_MO and temp1.prod = temp2.prod
)
select temp3.prod, temp3.MOST_FAV_MO, temp1.month as LEAST_FAV_MO
from temp1, temp3, temp2
where temp1.QUAN = temp2.LEAST_FAV_MO and temp2.prod = temp3.prod
order by temp3.prod

============================================================================================================================
Question 5

create view q1 as
(
	select cust, prod, avg(quant) as Q1_AVG
	from sales
	where month = 1 or month = 2 or month = 3
	group by cust,prod
)
select * from q1

create view q2 as
(
	select cust, prod, avg(quant) as Q2_AVG
	from sales
	where month = 4 or month = 5 or month = 6
	group by cust,prod
)
select * from q2

create view q3 as
(
	select cust, prod, avg(quant) as Q3_AVG
	from sales
	where month = 7 or month = 8 or month = 9
	group by cust,prod
)
select * from q3

create view q4 as
(
	select cust, prod, avg(quant) as Q4_AVG
	from sales
	where month = 10 or month = 11 or month = 12
	group by cust,prod
)
select * from q4

create view mathdata as
(
	select cust, prod, avg(quant) as AVERAGE, sum(quant) as TOTAL, count(*) as COUNT
	from sales
	group by cust, prod
)

select * 
from q1 natural full join q2 natural full join q3 natural full join q4 natural full join mathdata
