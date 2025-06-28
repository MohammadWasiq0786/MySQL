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

select * from products ;

INSERT INTO products (
    product_id,
    product_position,
    promotion,
    product_category,
    seasonal,
    sales_volume,
    brand,
    url,
    sku,
    name,
    description,
    price,
    currency,
    scraped_at,
    terms,
    section
) VALUES (
    '185102',                -- product_id
    'Aisle',                -- product_position
    'No',                   -- promotion
    'Clothing',             -- product_category
    'No',                   -- seasonal
    2823,                   -- sales_volume
    'Zara',                 -- brand
    'https://www.zara.com/us/en/basic-puffer-jacket-p06985450.html', -- url
    '272145190-250-2',       -- sku
    'BASIC PUFFER JACKET',  -- name
    'Puffer jacket made of tear-resistant ripstop fabric. High collar and adjustable long sleeves with adhesive straps. Welt pockets at hip. Adjustable hem with side elastics. Front zip closure.', -- description
    19.99,                  -- price
    'USD',                  -- currency
    '2024-02-19 08:50:05', -- scraped_at (formatted as DATETIME)
    'jackets',              -- terms
    'MAN'                   -- section
);
INSERT INTO products (
    product_id,
    product_position,
    promotion,
    product_category,
    seasonal,
    sales_volume,
    brand,
    url,
    sku,
    name,
    description,
    price,
    currency,
    scraped_at,
    terms,
    section
) VALUES
-- Record 1
('185102', 'Aisle', 'No', 'Clothing', 'No', 2823, 'Zara', 'https://www.zara.com/us/en/basic-puffer-jacket-p06985450.html', '272145190-250-2', 'BASIC PUFFER JACKET', 'Puffer jacket made of tear-resistant ripstop fabric. High collar and adjustable long sleeves with adhesive straps. Welt pockets at hip. Adjustable hem with side elastics. Front zip closure.', 19.99, 'USD', '2024-02-19 08:50:05', 'jackets', 'MAN'),

-- Record 2
('188771', 'Aisle', 'No', 'Clothing', 'No', 654, 'Zara', 'https://www.zara.com/us/en/tuxedo-jacket-p08896675.html', '324052738-800-46', 'TUXEDO JACKET', 'Straight fit blazer. Pointed lapel collar and long sleeves with buttoned cuffs. Welt pockets at hip and interior pocket. Central back vent at hem. Front button closure.', 169, 'USD', '2024-02-19 08:50:06', 'jackets', 'MAN'),

-- Record 3
('180176', 'End-cap', 'Yes', 'Clothing', 'Yes', 2220, 'Zara', 'https://www.zara.com/us/en/slim-fit-suit-jacket-p01564520.html', '335342680-800-44', 'SLIM FIT SUIT JACKET', 'Slim fit jacket. Notched lapel collar. Long sleeves with buttoned cuffs. Welt pocket at chest and flap pockets at hip. Interior pocket. Back vents. Front button closure.', 129, 'USD', '2024-02-19 08:50:07', 'jackets', 'MAN'),

-- Record 4
('112917', 'Aisle', 'Yes', 'Clothing', 'Yes', 1568, 'Zara', 'https://www.zara.com/us/en/stretch-suit-jacket-p01564300.html', '328303236-420-44', 'STRETCH SUIT JACKET', 'Slim fit jacket made of viscose blend fabric. Notched lapel collar. Long sleeves with buttoned cuffs. Welt pocket at chest and flap pockets at hip. Interior pocket. Back vents. Front button closure.', 129, 'USD', '2024-02-19 08:50:07', 'jackets', 'MAN'),

-- Record 5
('192936', 'End-cap', 'No', 'Clothing', 'Yes', 2942, 'Zara', 'https://www.zara.com/us/en/double-faced-jacket-p08281477.html', '312368260-800-2', 'DOUBLE FACED JACKET', 'Jacket made of faux leather faux shearling with fleece interior. Tabbed lapel collar. Long sleeves. Zip pockets at hip. Front zip closure.', 139, 'USD', '2024-02-19 08:50:08', 'jackets', 'MAN');



select * from products ;

