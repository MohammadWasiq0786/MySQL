create database tra;
use tra;
-- Account Table
CREATE TABLE accounts (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    balance DECIMAL(10,2)
);

-- Users Table
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

-- Orders Table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2)
);

-- Inventory Table
CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    stock INT
);

-- Wallet Table
CREATE TABLE wallet (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    balance DECIMAL(10,2)
);

-- Initial Data
INSERT INTO accounts (id, name, balance) VALUES 
(1, 'Rahul Sharma', 5000),
(2, 'Priya Mehta', 7000);

INSERT INTO users (id, name, email) VALUES 
(1, 'Rahul Sharma', 'rahul@india.com'),
(2, 'Priya Mehta', 'priya@india.com'),
(3, 'Aman Verma', 'aman@india.com');

INSERT INTO inventory (product_id, product_name, stock) VALUES 
(1, 'Smartphone', 5),
(2, 'Laptop', 3);

INSERT INTO wallet (id, name, balance) VALUES 
(10, 'Aman Verma', 1200);

SELECT @@autocommit;

SET autocommit = 0;

select * from accounts;

insert into accounts(id,name,balance) values (3,'sheha gupta',1000);

select * from accounts;
commit;

update accounts set balance = balance -100 where id =3;
commit;



update accounts set balance = balance +700 where id =3;
select * from accounts;
rollback;

select * from users where id = 1 for update;
update users set email = 'rahul.xyz@india.com' where id = 1 ;

select * from users ;
commit;

update users set email = '4sfsdffd@india.com' where id = 1 ;
savepoint abc;
rollback to abc;

select * from users ;
commit;







