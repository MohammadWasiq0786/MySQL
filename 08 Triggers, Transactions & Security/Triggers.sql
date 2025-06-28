create database triggers;
use triggers;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100),
    salary DECIMAL(10,2),
    doj DATE,
    dept VARCHAR(50)
);

CREATE TABLE audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    action_time DATETIME,
    action_type VARCHAR(20),
    details TEXT
);

create trigger log_after_insert
after insert on employees
for each row
insert into audit_log(action_time,action_type,details)
values(now(),'insert',concat('new employee',new.emp_name));

select * from employees;
select * from audit_log;

insert into employees(emp_name,salary,doj,dept)
values('sudh',3245345,'2025-03-03','IT');

create trigger log_after_delete
after delete on employees
for each row
insert into audit_log(action_time,action_type,details)
values(now(),'delete',concat('new employee',old.emp_name));

delete from employees where emp_name='sudh';
SET SQL_SAFE_UPDATES = 0;

CREATE TRIGGER cap_dept_before_insert
BEFORE INSERT ON employees
FOR EACH ROW
SET NEW.dept = UPPER(NEW.dept);

INSERT INTO employees(emp_name, salary, doj, dept)
VALUES ('Charlie', 55000, '2023-03-20', 'finance');

select * from employees;

DELIMITER $$
CREATE TRIGGER prevent_salary_drop
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < OLD.salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary reduction is not allowed!';
    END IF;
END$$
DELIMITER ;

UPDATE employees SET salary = 55000 WHERE emp_name = 'Charlie';

select * from audit_log;

DELIMITER $$
CREATE TRIGGER log_dept_change
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.dept <> NEW.dept THEN
        INSERT INTO audit_log(action_time, action_type, details)
        VALUES (NOW(), 'UPDATE', CONCAT('Department changed for ', NEW.emp_name, ': ', OLD.dept, ' → ', NEW.dept));
    END IF;
END$$
DELIMITER ;


UPDATE employees SET dept = 'ADMIN' WHERE emp_name = 'Charlie';

select * from employees;

create table employees_archive like employees;

select *  from employees_archive ;
CREATE TRIGGER archive_on_delete
AFTER DELETE ON employees
FOR EACH ROW
INSERT INTO employees_archive
VALUES (OLD.emp_id, OLD.emp_name, OLD.salary, OLD.doj, OLD.dept);

delete from employees where emp_name = 'charlie';

select * from employees;
select * from employees_archive;










