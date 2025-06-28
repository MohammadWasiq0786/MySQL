create database inventory;
use inventory;
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
) ENGINE=InnoDB;

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT
) ENGINE=InnoDB;




CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category_id INT,
    supplier_id INT,
    unit_price DECIMAL(10,2) NOT NULL,
    units_in_stock INT DEFAULT 0,
    units_on_order INT DEFAULT 0,
    reorder_level INT DEFAULT 0,
    discontinued BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
) ENGINE=InnoDB;

CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    quantity INT NOT NULL,
    sale_date DATE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB;

CREATE TABLE purchases (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    supplier_id INT,
    quantity INT NOT NULL,
    purchase_date DATE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
) ENGINE=InnoDB;


DELIMITER $$
CREATE TRIGGER after_sale_insert
AFTER INSERT ON sales
FOR EACH ROW
BEGIN
    UPDATE products
    SET units_in_stock = units_in_stock - NEW.quantity
    WHERE product_id = NEW.product_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER after_purchase_insert
AFTER INSERT ON purchases
FOR EACH ROW
BEGIN
    UPDATE products
    SET units_in_stock = units_in_stock + NEW.quantity
    WHERE product_id = NEW.product_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER before_sale_insert
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
    IF (SELECT units_in_stock FROM products WHERE product_id = NEW.product_id) < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough stock for this sale';
    END IF;
END $$
DELIMITER ;





CREATE VIEW monthly_sales_report AS
SELECT
    DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
    p.product_id,
    p.name AS product_name,
    SUM(s.quantity) AS total_quantity_sold,
    SUM(s.quantity * p.unit_price) AS total_sales_amount
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY sale_month, p.product_id, p.name
ORDER BY sale_month DESC, total_sales_amount DESC;



INSERT INTO categories (name, description) VALUES
('Electronics', 'Electronic items'),
('Furniture', 'Home and office furniture');

INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES
('ABC Electronics', 'John Doe', '1234567890', 'abc@electronics.com', '123 Main St'),
('XYZ Furniture', 'Jane Smith', '0987654321', 'xyz@furniture.com', '456 Oak Ave');

INSERT INTO products (name, category_id, supplier_id, unit_price, units_in_stock, reorder_level) VALUES
('Laptop', 1, 1, 800.00, 50, 10),
('Desk', 2, 2, 150.00, 20, 5);

INSERT INTO purchases (product_id, supplier_id, quantity, purchase_date) VALUES
(1, 1, 30, '2024-06-01'),
(2, 2, 10, '2024-06-02');

INSERT INTO sales (product_id, quantity, sale_date) VALUES
(1, 5, '2024-06-10'),
(2, 2, '2024-06-11'); 

select * from monthly_sales_report;


select * from categories;

















