create database test2;
use test2;
CREATE TABLE employees (
  id INT PRIMARY KEY,
  name VARCHAR(50),
  department VARCHAR(50),
  salary DECIMAL(10,2)
);

INSERT INTO employees VALUES
(1, 'Alice', 'HR', 50000),
(2, 'Bob', 'HR', 60000),
(3, 'Charlie', 'Sales', 55000),
(4, 'David', 'Sales', 70000),
(5, 'Eve', 'HR', 60000),
(6, 'Frank', 'Sales', 55000),
(7, 'Grace', 'Sales', 70000);

select id,name,department,salary ,rank() over (
partition by department
order by salary desc ) as salary_rank 
from employees;


select * from employees;

select id,name,department,salary ,dense_rank() over (
partition by department
order by salary desc ) as salary_rank 
from employees;




select id,name,department,salary ,row_number() over (
partition by department
order by salary desc ) as row_numb 
from employees;


