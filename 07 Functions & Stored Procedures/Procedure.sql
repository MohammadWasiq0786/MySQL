use emp;
select * from employees;
INSERT INTO employees(emp_name, salary, doj, dept)
    VALUES (name, sal, join_date, department);
delimiter $$
create procedure add_employee1(
in emp_id int,
in name varchar(100),
in sal decimal(10,2),
in join_date DATE,
in department varchar(50)
)
begin
	INSERT INTO employees(emp_id,emp_name, salary, doj, dept)
    VALUES (emp_id,name, sal, join_date, department);
end $$
delimiter ;

select * from employees;

call add_employee1(34,'sudhanshu kumar',34345,'2025-06-11','Fin');

DELIMITER $$
CREATE PROCEDURE update_salary(
    IN id INT,
    IN new_salary DECIMAL(10,2)
)
BEGIN
    UPDATE employees SET salary = new_salary WHERE emp_id = id;
END $$
DELIMITER ;

call update_salary(2,100000);

DELIMITER $$
CREATE PROCEDURE get_by_dept(IN department VARCHAR(50))
BEGIN
    SELECT * FROM employees WHERE dept = department;
END $$
DELIMITER ;

call get_by_dept('fin');


DELIMITER $$
CREATE PROCEDURE get_employee_count(OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total FROM employees;
END $$
DELIMITER ;

call get_employee_count(@count);
select  @count;


DELIMITER $$
CREATE PROCEDURE delete_employee(IN id INT)
BEGIN
    DELETE FROM employees WHERE emp_id = id;
END $$
DELIMITER ;

call delete_employee(2);

select * from employees;

DELIMITER $$
CREATE PROCEDURE increase_salary(
    IN percentage DECIMAL(5,2)
)
BEGIN
    UPDATE employees
    SET salary = salary + (salary * (percentage / 100));
END $$
DELIMITER ;

SET SQL_SAFE_UPDATES = 0;
call increase_salary(10);

select * from employees;

DELIMITER $$
CREATE PROCEDURE salary_band(IN in_emp_id INT, OUT band VARCHAR(20))
BEGIN
    DECLARE sal DECIMAL(10,2);
    SELECT salary INTO sal FROM employees WHERE emp_id = in_emp_id;
    IF sal >= 70000 THEN
        SET band = 'High';
    ELSEIF sal >= 50000 THEN
        SET band = 'Medium';
    ELSE
        SET band = 'Low';
    END IF;
END $$
DELIMITER ;

drop procedure salary_band;
call salary_band(1,@result);
select @result;



    
    
    
    