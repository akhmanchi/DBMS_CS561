create view quant23 as
(
	select cust, prod, sum(quant)*0.66 as totalSum
	from sales
	group by cust, prod
	order by cust, prod
)
select * from quant23
drop view quant23

create view month23 as
(
	select cust, prod, month
	from (
	    select cust, prod, month, sum(quant) over (partition by cust,prod order by cust, prod, month) as running_total
	    from sales
		) as tem
	where running_total >= (select quant23.totalSum from quant23 where tem.cust = quant23.cust and tem.prod = quant23.prod)
)
select * from month23
drop view month23

select cust as CUSTOMER, prod as PRODUCT, min(month) as "2/3 PURCHASED BY MONTH"
from month23
group by cust, prod
order by cust, prod