USE JB_HIFI;

######################## TABLES ###########################
CREATE TABLE customers (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    second_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
	mobile VARCHAR(20),
    PRIMARY KEY (id)
);

CREATE TABLE loyalty_card (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_id INT UNSIGNED NOT NULL,
    loyalty_points INT,
    PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE address (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_id INT UNSIGNED,
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    country VARCHAR(255),
    post_code VARCHAR(10),
    PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE stores (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255),
	address VARCHAR(255),
	city VARCHAR(255),
     PRIMARY KEY (id)
);

CREATE TABLE categories (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255),
     PRIMARY KEY (id)
);

CREATE TABLE products (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    store_id INT UNSIGNED,
    category_id INT UNSIGNED,
    `name` VARCHAR(255),
    unit_price INT,
    `description` VARCHAR(255),
    quantity INT,
	PRIMARY KEY (id),
    FOREIGN KEY (store_id) REFERENCES stores(id),
	FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE orders (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_id INT UNSIGNED,
    order_date DATE,
    total_amount INT,
	PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- incorrect cart (do not use - updated later)
CREATE TABLE cart (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id INT UNSIGNED,
	PRIMARY KEY (id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

CREATE TABLE cart_item (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    cart_id INT UNSIGNED,
    product_id INT UNSIGNED,
    quanity INT,
	PRIMARY KEY (id),
    FOREIGN KEY (cart_id) REFERENCES cart(id),
	FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE payments (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_id INT UNSIGNED,
    order_id INT UNSIGNED,
	total_amount INT,
	PRIMARY KEY (id),
	FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

CREATE TABLE shipments (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id INT UNSIGNED,
    shipment_date DATE,
    `status` VARCHAR(255),
	PRIMARY KEY (id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

CREATE TABLE store_products (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    store_id INT UNSIGNED,
    product_id INT UNSIGNED,
    quantity INT,
	PRIMARY KEY (id),
    FOREIGN KEY (store_id) REFERENCES stores(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE order_item (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id INT UNSIGNED,
    product_id INT UNSIGNED,
    quantity INT,
    unit_price_at_purchase INT,
	PRIMARY KEY (id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

SHOW TABLES;

-- Dropping and re-adding cart
-- find the FK constraint_name
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
    REFERENCED_TABLE_NAME = 'cart';
    
-- drop the FK
ALTER TABLE cart_item
DROP FOREIGN KEY cart_item_ibfk_1;

-- drop cart 
DROP TABLE cart;

-- create a new cart table
CREATE TABLE cart (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_id INT UNSIGNED,
	PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

SHOW TABLES;

######################## INSERT ###########################
-- customers
INSERT INTO customers (first_name, second_name, email, mobile) VALUES 
('Stacey', 'F', 'stacey@gmail.com', '0481456123'),
('Andrew', 'F', 'andrew@gmail.com', '0481456123');

-- loyalty_card
INSERT INTO loyalty_card (customer_id, loyalty_points) VALUES 
(1, 0),
(2, 200);

-- addresses
INSERT INTO address (customer_id, street, city, state, country, post_code) VALUES 
(1, '123 Main St', 'Sydney', 'NSW', 'Australia', '2000'),
(2, '456 Main St', 'Sydney', 'NSW', 'Australia', '2000');

-- stores
INSERT INTO stores (`name`, address, city) VALUES 
('JB Hi-Fi Sydney City', '420 George St', 'Sydney'),
('JB Hi-Fi Broadway', '1 Bay St', 'Sydney');
SELECT id FROM stores;

-- categories
INSERT INTO categories (`name`) VALUES 
('Phones'),
('Computers & Tablets'),
('TVs'),
('Headphones & Speakers'),
('Gaming'),
('Music & Movies'),
('Home Appliances');

-- products
INSERT INTO products (store_id, category_id, `name`, unit_price, `description`, quantity) VALUES 
(1, 1, 'iPhone 13', 1199, 'Apple iPhone 13 128GB - Midnight', 500),
(1, 2, 'Samsung Galaxy Tab S7', 799, 'Samsung Galaxy Tab S7 Wi-Fi 128GB - Mystic Black', 300),
(2, 3, 'LG C1 OLED TV', 2495, 'LG C1 55" Self-Lit OLED Smart 4K TV with AI ThinQ', 200),
(2, 4, 'Sony WH-1000XM4', 349, 'Sony WH-1000XM4 Wireless Noise Cancelling Over-Ear Headphones - Black', 400),
(1, 5, 'PS5 Console', 749, 'PlayStation 5 Console', 150),
(2, 6, 'The Beatles: Get Back', 29, 'The Beatles: Get Back - DVD', 1000),
(1, 7, 'Dyson V11 Outsize', 1249, 'Dyson V11 Outsize Cordless Vacuum', 100);

-- orders
INSERT INTO orders (customer_id, order_date, total_amount) VALUES 
(1, STR_TO_DATE('01/01/2022', '%d/%m/%Y'), 119900), -- iPhone 13
(1, STR_TO_DATE('02/01/2022', '%d/%m/%Y'), 79900),  -- Samsung Galaxy Tab S7
(2, STR_TO_DATE('03/01/2022', '%d/%m/%Y'), 249500), -- LG C1 OLED TV
(2, STR_TO_DATE('04/01/2022', '%d/%m/%Y'), 34900),  -- Sony WH-1000XM4
(1, STR_TO_DATE('05/01/2022', '%d/%m/%Y'), 74900),  -- PS5 Console
(2, STR_TO_DATE('06/01/2022', '%d/%m/%Y'), 2900),   -- The Beatles: Get Back
(1, STR_TO_DATE('07/01/2022', '%d/%m/%Y'), 124900); -- Dyson V11 Outsize

-- cart
INSERT INTO cart (customer_id) VALUES 
(1), -- Cart for customer 1
(2); -- Cart for customer 2

-- cart_item 
INSERT INTO cart_item (cart_id, product_id, quanity) VALUES 
(1, 22, 1), -- iPhone 13 for customer 1
(2, 23, 1); -- Samsung Galaxy Tab S7 for customer 2

-- payments
INSERT INTO payments (customer_id, order_id, total_amount) VALUES 
(1, 1, 119900), -- Payment for iPhone 13 by customer 1
(2, 2, 79900);  -- Payment for Samsung Galaxy Tab S7 by customer 2

--  store_products
INSERT INTO store_products (store_id, product_id, quantity) VALUES 
(1, 22, 10), -- iPhone 13 at store 1
(2, 23, 20); -- Samsung Galaxy Tab S7 at store 2

--  shipments
INSERT INTO shipments (order_id, shipment_date, `status`) VALUES 
(1, STR_TO_DATE('05/01/2022', '%d/%m/%Y'), 'dispatched'), -- order 1
(2, STR_TO_DATE('10/01/2022', '%d/%m/%Y'), 'delivered');  -- order 2

-- order_item
INSERT INTO order_item (order_id, product_id, quantity, unit_price_at_purchase) VALUES 
(1, 22, 1, 119900), -- iPhone 13 for order 1
(2, 23, 1, 79900),  -- Samsung Galaxy Tab S7 for order 2
(3, 24, 1, 249500), -- LG C1 OLED TV for order 3
(4, 25, 1, 34900),  -- Sony WH-1000XM4 for order 4
(5, 26, 1, 74900),  -- PS5 Console for order 5
(6, 27, 1, 2900),   -- The Beatles: Get Back for order 6
(7, 28, 1, 124900); -- Dyson V11 Outsize for order 7

-- view of data by table
SHOW TABLES;
SELECT * FROM address;
SELECT * FROM cart;
SELECT * FROM customers;
SELECT * FROM categories;
SELECT * FROM loyalty_card;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM stores;
SELECT * FROM payments;
SELECT * FROM cart_item;
SELECT * FROM store_products;
SELECT * FROM shipments;
SELECT * FROM order_item;

-- fixing 
DESCRIBE products;

SHOW COLUMNS FROM order_item;

-- running some queries
-- Return the names and delivery dates of products that have been delivered 
SELECT 
    products.name AS product_name,
    shipments.shipment_date AS delivery_date
FROM 
    products
JOIN order_item ON products.id = order_item.product_id
JOIN orders ON order_item.order_id = orders.id
JOIN shipments ON orders.id = shipments.order_id
WHERE shipments.status = 'delivered';