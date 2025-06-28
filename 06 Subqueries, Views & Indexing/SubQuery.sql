create database cust_sales;
use cust_sales;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    join_date DATE
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    sale_amount DECIMAL(10, 2),
    sale_date DATE,
    product VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
select * from customers;
select * from sales ;

select * from customers where join_date >
(select avg(join_date) from customers);

select customer_name from customers where customer_id in
(select distinct customer_id from sales);

select * from customers where customer_id = 
(select customer_id from sales group by customer_id order by sum(sale_amount) desc limit 1 );


select * from customers where customer_id in 
(select distinct customer_id from sales where product='Laptop');

select * from customers c where exists(
select 1 from sales s where s.customer_id =c.customer_id );

select * from customers where customer_id in
(select distinct customer_id from sales where sale_amount> any
(select sale_amount from sales where customer_id = 10 ));

select * from customers where customer_id in 
(select customer_id from sales group by customer_id having min(sale_amount)>200);

select customer_id,sale_amount from sales s1 where sale_amount >(
select avg(sale_amount) from sales s2 
where s1.customer_id = s2.customer_id);

select customer_id , customer_name from customers where customer_id in
(select customer_id from sales group by customer_id order by sum(sale_amount)
desc limit 5);


select * from customers where customer_id in (
  SELECT customer_id
  FROM sales
  GROUP BY customer_id
  ORDER BY SUM(sale_amount) DESC
  LIMIT 5
);

select * from customers where customer_id in 
(select customer_id from sales group by customer_id having count(distinct product)=
(select count(distinct product) from sales)) ;


select customer_id from sales group by customer_id having sum(sale_amount) >
(select avg(total_sales) from (
(select sum(sale_amount) as total_sales from sales group by customer_id) ) as avg_sales);




