use cust_sales;
drop index idx_customer_city on customers;
create index idx_customer_city  on customers(city);

select * from customers;

EXPLAIN ANALYZE
select * from customers where city = 'chicago';

CREATE INDEX idx_sales_customer_product
ON sales(customer_id, product);

EXPLAIN ANALYZE
SELECT * FROM sales WHERE customer_id = 10 AND product = 'Laptop';

CREATE TABLE sales2 (
    sale_id INT NOT NULL,
    customer_id INT,
    sale_date DATE NOT NULL,
    sale_amount DECIMAL(10, 2),
    product VARCHAR(50),
    PRIMARY KEY (sale_id, sale_date)  -- required for RANGE partitioning
)
PARTITION BY RANGE (YEAR(sale_date)) (
    PARTITION p2020 VALUES LESS THAN (2021),
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION pmax VALUES LESS THAN MAXVALUE
);

INSERT INTO sales2 (sale_id, customer_id, sale_date, sale_amount, product)
VALUES (1, 101, '2021-05-01', 599.99, 'Laptop');





SELECT
  TABLE_NAME,
  PARTITION_NAME,
  SUBPARTITION_NAME,
  PARTITION_ORDINAL_POSITION,
  PARTITION_METHOD,
  PARTITION_EXPRESSION,
  TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_NAME = 'sales2';









