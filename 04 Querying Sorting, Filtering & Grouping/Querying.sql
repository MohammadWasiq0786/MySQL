create database zara;
create database zara;
use zara;
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each record
    product_id VARCHAR(50) NOT NULL, -- Product ID from source
    product_position VARCHAR(20), -- Position in store (e.g., Aisle, End-cap)
    promotion ENUM('Yes', 'No') NOT NULL, -- Promotion status
    product_category VARCHAR(50), -- Category (e.g., Clothing)
    seasonal ENUM('Yes', 'No'), -- Seasonal indicator
    sales_volume INT, -- Sales volume
    brand VARCHAR(50), -- Brand name
    url VARCHAR(255), -- Product URL
    sku VARCHAR(50), -- SKU number
    name VARCHAR(255), -- Product name
    description TEXT, -- Product description
    price DECIMAL(10,2), -- Price
    currency VARCHAR(10), -- Currency code (e.g., USD)
    scraped_at DATETIME, -- Timestamp of data scrape
    terms VARCHAR(50), -- Section or terms (e.g., jackets)
    section VARCHAR(50) -- Section (e.g., MAN)
);

select  * from products;

select product_id ,promotion,url,sku from products;

select product_id as pid ,promotion as pr ,url,sku as s  from products;

select name ,price from products order by price asc;

select name ,price from products order by price desc;

select * from products limit 5 ;

select * from products limit 5  offset 3;

select name ,price , price * .90 as discounted_price from products ;

select brand , name , concat(name ,'-',brand) as combined_name from products ; 

select * from products;

select * from products where promotion = 'yes';

select * from products where promotion = 'yes' and seasonal = 'yes';

select * from products where price between 50 and 100;

select product_category ,count(*) as total_product from products group by product_category;

select product_category ,count(*) as total_product ,avg(price) as avg_p from products group by product_category;
select product_position from products;
select product_position ,count(*) as total_product ,avg(price) as avg_p from products group by product_position;

select product_position ,count(*) as total_product ,avg(price) as avg_p ,
min(sales_volume) as min_sales ,max(sales_volume) as max_sales
from products group by product_position;

select product_position ,count(*) as total_product ,avg(price) as avg_p ,
min(sales_volume) as min_sales ,max(sales_volume) as max_sales,sum(sales_volume) as total_sales
from products group by product_position;

select promotion,count(*) as count_promotion_product from products group by promotion ;

select brand from products;

select section from products;

select section ,count(*) as product_buy from products group by section ; 

select section, sum(sales_volume) as total_sales from products group by section having total_sales > 100000;

select section, sum(sales_volume) as total_sales from products group by section where  total_sales > 100000;

select section ,count(*) as section_count from products where seasonal='yes' group by section;
