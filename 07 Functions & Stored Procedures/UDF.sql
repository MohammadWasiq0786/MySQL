create database emp;
use emp;
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    salary DECIMAL(10,2),
    doj DATE,
    dept VARCHAR(50)
);
INSERT INTO employees (emp_id, emp_name, salary, doj, dept) VALUES
(1, 'Amit Kumar', 55000, '2019-04-15', 'Engineering'),
(2, 'Neha Singh', 72000, '2020-01-10', 'Marketing'),
(3, 'Rajeev Ranjan', 48000, '2018-07-22', 'Finance'),
(4, 'Pooja Yadav', 63000, '2021-06-18', 'Engineering'),
(5, 'Ankit Verma', 58000, '2022-02-28', 'HR');

select * from employees;

delimiter $$
create function annual_salary(salary decimal(10,2))
returns decimal(10,2)
deterministic
begin 
	return salary*12;
end $$
delimiter ;

select emp_name,annual_salary(salary) as annual_income from employees;

DELIMITER $$
CREATE FUNCTION years_of_experience(doj DATE)
RETURNS INT
DETERMINISTIC
BEGIN
   RETURN YEAR(CURDATE()) - YEAR(doj);
END $$
DELIMITER ;

select emp_name , years_of_experience(doj) as experience from employees;



DELIMITER $$
CREATE FUNCTION tax_bracket(salary DECIMAL(10,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
   IF salary > 70000 THEN
      RETURN 'High';
   ELSEIF salary >= 60000 THEN
      RETURN 'Medium';
   ELSE
      RETURN 'Low';
   END IF;
END $$

DELIMITER ;

SELECT emp_name, tax_bracket(salary) AS tax_category FROM employees;

DELIMITER $$

CREATE FUNCTION dept_initials(dept VARCHAR(50))
RETURNS VARCHAR(5)
DETERMINISTIC
BEGIN
   RETURN UPPER(LEFT(dept, 2));
END $$

DELIMITER ;

SELECT emp_name, dept_initials(dept) AS dept_code FROM employees;

DELIMITER $$

CREATE FUNCTION days_in_company(doj DATE)
RETURNS INT
DETERMINISTIC
BEGIN
   RETURN DATEDIFF(CURDATE(), doj);
END $$

DELIMITER ;
SELECT emp_name, days_in_company(doj) AS total_days FROM employees;
DELIMITER $$

CREATE FUNCTION calculate_bonus(salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
   RETURN salary * 0.10;
END $$

DELIMITER ;

SELECT emp_name, calculate_bonus(salary) AS bonus FROM employees;










