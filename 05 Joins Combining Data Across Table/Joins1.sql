Create database Customer;
use customer;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50),
    age INT,
    total_spent DECIMAL(10, 2)
);

INSERT INTO customers (customer_id, name, city, country, age, total_spent) VALUES
(1, 'Alice', 'Delhi', 'India', 28, 1200.50),
(2, 'Bob', 'Mumbai', 'India', 35, 2200.00),
(3, 'Charlie', 'Bangalore', 'India', 30, 1800.75),
(4, 'David', 'New York', 'USA', 40, 3000.00),
(5, 'Eva', 'Los Angeles', 'USA', 45, 4500.20),
(6, 'Frank', 'Berlin', 'Germany', 38, 2100.90),
(7, 'Grace', 'Munich', 'Germany', 25, 800.00),
(8, 'Helen', 'London', 'UK', 32, 1900.00),
(9, 'Ivy', 'London', 'UK', 29, 1000.50),
(10, 'John', 'Delhi', 'India', 41, 2400.00);

select * from customers;

with avg_age_cte as (
select avg(age) as avg_age from customers)
select name ,age from customers join avg_age_cte on customers.age >avg_age_cte.avg_age;

with top_five_cte as (
select * from customers order by total_spent Desc limit 5)
select * from top_five_cte;

with country_count as (
select country ,count(*) as total_customers from customers group by country)
select  * from country_count;
















