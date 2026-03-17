/*

Exercise_1

Tasks:

Count the total number of orders.
Find the top 10 customers with the most orders.
Calculate total revenue per product category.
Find average order value.
Find the month with the highest revenue.

*/

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR(100),
    customer_state VARCHAR(2)
);

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) REFERENCES customers(customer_id),
    order_status VARCHAR(20),
    order_purchased_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);

CREATE TABLE order_items (
    order_id VARCHAR(50) REFERENCES orders(order_id),
    order_item_id INTEGER,
    product_id VARCHAR(50) REFERENCES products(product_id),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

SELECT * FROM customers

SELECT * FROM orders

SELECT * FROM products

SELECT * FROM order_items

-- Count the total number of orders.

SELECT COUNT(*) AS total_orders
FROM orders;

-- Find the top 10 customers with the most orders.

SELECT
	o.customer_id,
	COUNT(o.order_id) AS total_orders
FROM orders o
GROUP BY o.customer_id
ORDER BY total_orders DESC
LIMIT 10;

-- Total Revenue per Product Category

SELECT
	p.product_category_name,
	SUM(oi.price + oi.freight_value) AS total_revenue
FROM order_items oi
JOIN products p
	ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;

-- Find average order value

SELECT
	AVG(order_total) AS avg_order_value
FROM (
	SELECT
		order_id,
		SUM(price + freight_value) AS order_total
	FROM order_items
	GROUP BY order_id
) sub;

/*

sub is an alias for the subquery and the subquery code runs first
PostgreSQL tells the computerm take that temporary list we just made and treat it like a table named sub.

The outer query looks at that virtual table named sub and calculates the average of the order_total column.

*/

-- Find the month with the highest revenue

SELECT
	DATE_TRUNC('month', o.order_purchased_timestamp) AS month,
	SUM(oi.price + oi.freight_value) AS total_revenue
FROM orders o
JOIN order_items oi
	ON o.order_id = oi.order_id
GROUP BY month
ORDER BY total_revenue DESC
LIMIT 1;






