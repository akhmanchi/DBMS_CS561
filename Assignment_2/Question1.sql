select s1.cust,s1.prod,s1.state,avg(s1.quant) as CUST_AVG,avg(s2.quant) as OTHER_STATE_AVG,avg(s3.quant) as OTHER_PROD_AVG
from sales s1,sales s2, sales s3
where s1.cust=s2.cust and s1.prod = s2.prod and s1.state<>s2.state and s1.cust=s3.cust and s1.state=s3.state and s1.prod<>s3.prod
group by s1.cust,s1.prod,s1.state