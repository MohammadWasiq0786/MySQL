create database cust_sales;
use cust_sales;

create view customer_summary as
select customer_id,customer_name,city from customers;

select * from customer_summary;

create view customer_total_sales as 
select customer_id , sum(sale_amount) as total_sales 
from sales
group by customer_id;

select * from  customer_total_sales ;


create view customer_purchases as 
select c.customer_name , s.product,s.sale_amount,s.sale_date
from customers c join sales s on c.customer_id = s.customer_id;

drop view if exists customer_purchases;

