create view custprod as
(
	select distinct cust, prod
	from sales
	order by cust,prod
)
select * from custprod
drop view custprod

create view quarter1 as
(
	select cust, prod, 1 as q, avg(quant) as avg_quant
	from sales
	where month in (1,2,3)
	group by cust,prod
)
select * from quarter1
drop view quarter1

create view quarter1full as
(
	select custprod.cust, custprod.prod, 1 as q, quarter1.avg_quant
	from custprod left outer join quarter1
	on custprod.cust = quarter1.cust and custprod.prod = quarter1.prod
	order by cust, prod
)
select * from quarter1full
drop view quarter1full

create view quarter2 as
(
	select cust, prod, 2 as q, avg(quant) as avg_quant
	from sales
	where month in (4,5,6)
	group by cust,prod
)
select * from quarter2
drop view quarter2

create view quarter2full as
(
	select custprod.cust, custprod.prod, 2 as q, quarter2.avg_quant
	from custprod left outer join quarter2
	on custprod.cust = quarter2.cust and custprod.prod = quarter2.prod
	order by cust, prod
)
select * from quarter2full
drop view quarter2full

create view quarter3 as
(
	select cust, prod, 3 as q, avg(quant) as avg_quant
	from sales
	where month in (7,8,9)
	group by cust,prod
	order by cust,prod
)
select * from quarter3
drop view quarter3

create view quarter3full as
(
	select custprod.cust, custprod.prod, 3 as q, quarter3.avg_quant
	from custprod left outer join quarter3
	on custprod.cust = quarter3.cust and custprod.prod = quarter3.prod
	order by cust, prod
)
select * from quarter3full
drop view quarter3full

create view quarter4 as
(
	select cust, prod, 4 as q, avg(quant) as avg_quant
	from sales
	where month in (10,11,12)
	group by cust,prod
)
select * from quarter4
drop view quarter4

create view quarter4full as
(
	select custprod.cust, custprod.prod, 4 as q, quarter4.avg_quant
	from custprod left outer join quarter4
	on custprod.cust = quarter4.cust and custprod.prod = quarter4.prod
	order by cust, prod
)
select * from quarter4full
drop view quarter4full

select quarter1full.cust, quarter1full.prod, quarter1full.q, null as Before_Avg, quarter2full.avg_quant as After_Avg
from quarter1full, quarter2full
where quarter1full.cust=quarter2full.cust and quarter1full.prod=quarter2full.prod
union
select quarter2full.cust, quarter2full.prod, quarter2full.q, quarter1full.avg_quant as Before_Avg, quarter3full.avg_quant as After_Avg
from quarter1full, quarter2full, quarter3full
where quarter1full.cust=quarter2full.cust and quarter2full.cust=quarter3full.cust and quarter1full.prod=quarter2full.prod and quarter2full.prod=quarter3full.prod
union
select quarter3full.cust, quarter3full.prod, quarter3full.q, quarter2full.avg_quant as Before_Avg, quarter4full.avg_quant as After_Avg
from quarter2full, quarter3full, quarter4full
where quarter2full.cust=quarter3full.cust and quarter3full.cust=quarter4full.cust and quarter2full.prod=quarter3full.prod and quarter3full.prod=quarter4full.prod
union
select quarter4full.cust, quarter4full.prod, quarter4full.q, quarter3full.avg_quant as Before_Avg, null as After_Avg
from quarter3full, quarter4full
where quarter3full.cust=quarter4full.cust and quarter3full.prod=quarter4full.prod
order by cust, prod, q