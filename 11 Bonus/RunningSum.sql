use test123;
CREATE TABLE sales (
  id INT PRIMARY KEY,
  sale_date DATE,
  region VARCHAR(50),
  amount DECIMAL(10,2)
);
INSERT INTO sales VALUES
(1, '2024-01-01', 'North', 100),
(2, '2024-01-02', 'North', 200),
(3, '2024-01-03', 'North', 150),
(4, '2024-01-01', 'South', 300),
(5, '2024-01-02', 'South', 400),
(6, '2024-01-03', 'South', 100);


select * from sales ;
select sale_date ,region,amount,
sum(amount) over(order by sale_date
rows between unbounded preceding and current row) as running_total from 
sales order by sale_date;


select sale_date ,region,amount,
sum(amount) over(partition by region
order by sale_date
rows between unbounded preceding and current row) as running_total_partation from 
sales order by region,sale_date;




select sale_date ,region,amount,
sum(amount) over(partition by region
order by sale_date
rows between 1 preceding and current row) as running_total_partation from 
sales order by region,sale_date;

select sale_date ,region,amount,
sum(amount) over(partition by region
) as running_total_partation from 
sales order by region,sale_date;
