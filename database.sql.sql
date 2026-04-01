CREATE DATABASE TOMMY;
USE TOMMY;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    city VARCHAR(20)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category varchar(50) not null,
    unit_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    sale_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 
create view Sales_Summary AS
select s. *, p.unit_price *s.quantity AS Total
from Sales s 
join products p 
on s.product_id= p.product_id;



select * from customers;
select* from products;
select *from sales;
select* from sales_summary;

       SELECT c.Customer_name, SUM(p.unit_price * s.quantity) as Total
        FROM sales s
        JOIN customers c
        ON s.customer_id=c.Customer_id
        join products p 
        on p.product_id = s.product_id
        GROUP BY c.Customer_name;
 


drop table customers;
drop table products;
drop table sales;

select sum(total) as total 
from sales_summary;
drop table sales_summary;

select * from customers;
select* from products;
select *from sales;
show tables;

select c.Customer_name,c.customer_id,s.product_id,s.quantity
from customers as c
join sales as s
on s.customer_id=c.customer_id;





-- top 10 product
select p.Product_name, SUM(s.quantity ) as Product_total
from sales as s 
join products as p
on s.product_id= p.product_id
group by Product_name
order by Product_total desc

limit 10;


-- Adding total to sales table




select *from sales_summary;
select * from customers;
select* from products;
select *from sales;




-- 1. CLEAR TABLES
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE sales;
TRUNCATE TABLE products;
TRUNCATE TABLE customers;
SET FOREIGN_KEY_CHECKS = 1;

-- 2. GENERATE 40 REALISTIC PRODUCTS (Electronics, Furniture, Stationery, Hardware)
INSERT INTO products (product_name, category, unit_price)
SELECT 
    CONCAT(p_name, ' ', p_model) as product_name, 
    p_cat, 
    p_price
FROM (
    SELECT 'HP' as p_name, 'Laptop' as p_model, 'Electronics' as p_cat, 4500.00 as p_price UNION SELECT 'Dell', 'XPS 13', 'Electronics', 6200.00 UNION
    SELECT 'Logitech', 'Mouse', 'Accessories', 150.00 UNION SELECT 'Samsung', 'Monitor', 'Electronics', 1800.00 UNION
    SELECT 'Canon', 'Printer', 'Office', 2500.00 UNION SELECT 'IKEA', 'Desk', 'Furniture', 3200.00 UNION
    SELECT 'Steelcase', 'Chair', 'Furniture', 1400.00 UNION SELECT 'Western Digital', 'HDD 2TB', 'Storage', 650.00 UNION
    SELECT 'Sandisk', 'USB 64GB', 'Storage', 85.00 UNION SELECT 'Cisco', 'Router', 'IT', 4200.00
) as base_p, (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) as multiplier; 
-- (This creates 10 products x 4 variations = 40 Products)

-- 3. GENERATE 200 REALISTIC CUSTOMERS
INSERT INTO customers (customer_name, email, city)
SELECT 
    CONCAT(f_name, ' ', l_name) as customer_name,
    LOWER(CONCAT(f_name, '.', l_name, '@email.com')) as email,
    city_name
FROM (
    SELECT 'Joseph' as f_name UNION SELECT 'Eunice' UNION SELECT 'Fredrick' UNION SELECT 'Abena' UNION SELECT 'David Raymand' UNION 
    SELECT 'Benidicta' UNION SELECT 'Jerome' UNION SELECT 'Olivia' UNION SELECT 'Micheal' UNION SELECT 'Richeal'
) as firsts, (
    SELECT 'Ardey Thompson' as l_name UNION SELECT 'Abeka' UNION SELECT 'Kessi Ansah' UNION SELECT 'Osei' UNION SELECT 'Ansamah Anuson' UNION 
    SELECT 'Ananor' UNION SELECT 'NII Tetteh' UNION SELECT 'Nuima' UNION SELECT 'Afrifa' UNION SELECT 'Richral'
) as lasts, (
    SELECT 'Accra' as city_name UNION SELECT 'Kumasi'
) as cities;
-- (This creates 10 first names x 10 last names x 2 cities = 200 Customers)

-- 4. POPULATE 1,500 SALES RECORDS ACROSS 10 YEARS (2017-2026)
INSERT INTO sales (customer_id, product_id, quantity, sale_date)
SELECT 
    (FLOOR(1 + RAND() * 200)) AS customer_id, 
    (FLOOR(1 + RAND() * 40)) AS product_id, 
    (FLOOR(1 + RAND() * 10)) AS quantity,
    DATE_ADD('2017-01-01', INTERVAL FLOOR(RAND() * 3350) DAY) AS sale_date
FROM 
    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) AS a,
    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) AS b,
    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) AS c,
    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) AS d,
    (SELECT 1 UNION SELECT 2) AS e;
    
    
    
    
    
    -- 1. Enable the scheduler
SET GLOBAL event_scheduler = ON;
SET GLOBAL event_scheduler = OFF;

-- 2. Drop the old one if it exists
-- DROP EVENT IF EXISTS daily_sales_generator;

-- 3. Create the 30-second high-frequency generator
DELIMITER //
CREATE EVENT fast_test_generator
ON SCHEDULE EVERY 30 MINUTE
DO
BEGIN
    -- Inserts a high-value random sale every 30 seconds
    INSERT INTO sales (customer_id, product_id, quantity, sale_date)
    SELECT 
        customer_id, 
        product_id, 
        FLOOR(1 + RAND() * 10), -- Quantity 1-10
        CURDATE()               -- Today's date
    FROM (
        SELECT c.customer_id, p.product_id
        FROM customers c
        CROSS JOIN products p
        ORDER BY RAND()
        LIMIT 5 -- Just 1 sale every 30m to keep it clean
    ) AS random_pairs;
END //

DELIMITER ;

SET sql_safe_updates=0;

-- Stop the generator
DROP EVENT IF EXISTS fast_test_generator;

-- Optional: Delete all sales created today to reset your stats
DELETE FROM sales WHERE sale_date = CURDATE();


CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100)
);

-- Add a default executive user
INSERT INTO users (username, password, full_name) 
VALUES ('THOMPSON', 'TOMMY@2856', 'ANALYTICS MANAGER');
