create database marketing_sales;
use marketing_sales;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    launch_date DATE
);

CREATE TABLE campaigns (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10,2),
    channel VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20),
    campaign_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


CREATE TABLE leads (
    lead_id INT PRIMARY KEY,
    lead_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    campaign_id INT,
    lead_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);
CREATE TABLE sales_reps (
    rep_id INT PRIMARY KEY,
    rep_name VARCHAR(100),
    email VARCHAR(100),
    hire_date DATE,
    territory VARCHAR(50)
);

CREATE TABLE customer_assignments (
    assignment_id INT PRIMARY KEY,
    customer_id INT,
    rep_id INT,
    assign_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (rep_id) REFERENCES sales_reps(rep_id)
);

INSERT INTO customers VALUES 
(1, 'Acme Corp', 'contact@acme.com', '555-1234', '2023-01-15'),
(2, 'Beta Industries', 'info@beta.com', '555-2345', '2023-02-20'),
(3, 'Gamma Solutions', 'hello@gamma.com', '555-3456', '2023-03-10'),
(4, 'Delta Services', 'support@delta.com', '555-4567', '2023-04-05'),
(5, 'Epsilon Tech', 'sales@epsilon.com', '555-5678', '2023-05-12');


INSERT INTO products VALUES 
(101, 'Premium CRM', 'Software', 1999.99, '2023-01-01'),
(102, 'Basic CRM', 'Software', 999.99, '2023-01-01'),
(103, 'Marketing Analytics Suite', 'Software', 1499.99, '2023-02-15'),
(104, 'Sales Training Package', 'Service', 2999.99, '2023-03-01'),
(105, 'Customer Support Module', 'Software', 799.99, '2023-04-10');

INSERT INTO campaigns VALUES 
(201, 'Spring Promotion', '2023-03-01', '2023-05-31', 50000.00, 'Email'),
(202, 'Summer Sale', '2023-06-01', '2023-08-31', 75000.00, 'Social Media'),
(203, 'Product Launch', '2023-04-15', '2023-06-15', 100000.00, 'Multiple'),
(204, 'End of Year Special', '2023-11-01', '2023-12-31', 60000.00, 'Email'),
(205, 'Webinar Series', '2023-02-01', '2023-04-30', 25000.00, 'Webinar');

INSERT INTO orders VALUES 
(301, 1, '2023-04-10', 5999.97, 'Completed', 201),
(302, 2, '2023-05-15', 1999.99, 'Completed', 201),
(303, 3, '2023-06-20', 4499.97, 'Processing', 202),
(304, 1, '2023-07-05', 2999.99, 'Completed', 202),
(305, 4, '2023-08-12', 1499.99, 'Completed', 203),
(306, 5, '2023-09-18', 3999.98, 'Processing', 203),
(307, 2, '2023-10-25', 999.99, 'Pending', 204);

INSERT INTO order_details VALUES 
(401, 301, 101, 3, 1999.99),
(402, 302, 101, 1, 1999.99),
(403, 303, 102, 3, 999.99),
(404, 303, 105, 1, 799.99),
(405, 304, 104, 1, 2999.99),
(406, 305, 103, 1, 1499.99),
(407, 306, 101, 1, 1999.99),
(408, 306, 102, 2, 999.99),
(409, 307, 102, 1, 999.99);

INSERT INTO leads VALUES 
(501, 'Zeta Corp', 'info@zeta.com', '555-6789', 201, '2023-03-15', 'Qualified'),
(502, 'Eta Enterprises', 'contact@eta.com', '555-7890', 201, '2023-04-02', 'Contacted'),
(503, 'Theta Systems', 'info@theta.com', '555-8901', 202, '2023-06-10', 'Qualified'),
(504, 'Iota Solutions', 'sales@iota.com', '555-9012', 203, '2023-05-05', 'Converted'),
(505, 'Kappa Tech', 'info@kappa.com', '555-0123', 204, '2023-11-15', 'New'),
(506, 'Lambda Services', 'hello@lambda.com', '555-1234', 205, '2023-02-20', 'Contacted'),
(507, 'Omega Industries', 'info@omega.com', '555-2345', NULL, '2023-10-10', 'New');

INSERT INTO sales_reps VALUES 
(601, 'John Smith', 'john@company.com', '2022-01-15', 'North'),
(602, 'Jane Doe', 'jane@company.com', '2022-03-20', 'South'),
(603, 'Robert Johnson', 'robert@company.com', '2022-05-10', 'East'),
(604, 'Lisa Brown', 'lisa@company.com', '2022-07-05', 'West'),
(605, 'Michael Davis', 'michael@company.com', '2022-09-12', 'Central');


INSERT INTO customer_assignments VALUES 
(701, 1, 601, '2023-01-20'),
(702, 2, 602, '2023-02-25'),
(703, 3, 603, '2023-03-15'),
(704, 4, 604, '2023-04-10'),
(705, 5, 605, '2023-05-18');

select * from orders ;
select * from customers;

select * from orders o inner join customers c on 
o.customer_id = c.customer_id;

select * from products p inner join order_details od 
on p.product_id = od.product_id;

select * from products;

select * from campaigns c inner join orders o 
on c.campaign_id = o.campaign_id;

select * from customers c left join orders o 
on c.customer_id = o.customer_id;

select * from customers;

select * from products p left join order_details od 
on p.product_id = od.product_id;

select * from campaigns c left join leads l on 
c.campaign_id = l.campaign_id;

select * from campaigns c right join leads l on 
c.campaign_id = l.campaign_id;

select * from  leads l right join campaigns c on 
c.campaign_id = l.campaign_id;


select * from campaigns c left join leads l on c.campaign_id = l.campaign_id
union
select * from campaigns c right join leads l on c.campaign_id = l.campaign_id;

select * from products cross join campaigns;

select * from sales_reps cross join products;

select c.customer_name,o.order_id,o.order_date ,od.quantity ,od.unit_price,
p.product_name
from customers c inner join orders o on c.customer_id=o.customer_id
inner join order_details od  on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id;

SELECT c.campaign_name, l.lead_name, l.status,
       o.order_id, o.order_date, o.total_amount
FROM campaigns c
LEFT JOIN leads l ON c.campaign_id = l.campaign_id
LEFT JOIN orders o ON c.campaign_id = o.campaign_id;






