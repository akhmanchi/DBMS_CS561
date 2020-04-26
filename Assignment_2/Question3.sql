create view runcount as 
(
	select s.prod, s.quant, (select count(*) from sales where quant<=s.quant and prod = s.prod) as medcount
	from sales s
	order by s.prod, medcount
)
select * from runcount
drop view runcount

create view midcount as
(
	select runcount.prod, (max(medcount)/2 + 1) as mid
	from runcount
	group by prod
)
select * from midcount
drop view midcount

create view overmed as
(
	select runcount.prod, runcount.quant
	from runcount, midcount
	where runcount.prod = midcount.prod and runcount.medcount >= midcount.mid
	order by runcount.prod, runcount.quant
)
select * from overmed
drop view overmed

select overmed.prod as "PRODUCT", min(overmed.quant) as "MEDIAN QUANT" 
from overmed
group by prod