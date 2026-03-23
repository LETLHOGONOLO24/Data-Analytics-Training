/*

Exercise_2

Tasks:

-Find customers who made MORE than the average number of orders
-Find orders with value ABOVE average order value

-Find top 5 customers by total spending
-Find customers who have NEVER made a purchase
-Find the most expensive product in each category

*/

-- Find customers who made MORE than the average number of orders

SELECT
	customer_id,
	COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > (
	SELECT AVG(order_count)
	FROM (
		SELECT COUNT(order_id) AS order_count
		FROM orders
		GROUP BY customer_id
	) sub
);

-- Find orders with value ABOVE average order value

SELECT
	order_id,
	SUM(price + freight_value) AS order_total
FROM order_items
GROUP BY order_id
HAVING SUM(price + freight_value) > (
	SELECT AVG(order_total)
	FROM (
		SELECT
			order_id,
			SUM(price + freight_value) AS order_total
		FROM order_items
		GROUP BY order_id
	) sub
)
ORDER BY order_total DESC;

-- Find top 5 customers by total spending

SELECT
	o.customer_id,
	SUM(oi.price + oi.freight_value) AS total_spent
FROM orders o
JOIN order_items oi
	ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- Find customers who have NEVER made a purchase

SELECT
	c.customer_id
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Find the most expensive product in each category

SELECT
	p.product_category_name,
	MAX(oi.price) AS max_price
FROM order_items oi
JOIN products p
	ON oi.product_id = p.product_id
GROUP BY p.product_category_name;

SELECT 
    p.product_category_name,
    p.product_id,
    oi.price
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
WHERE oi.price = (
    SELECT MAX(oi2.price)
    FROM order_items oi2
    JOIN products p2 
        ON oi2.product_id = p2.product_id
    WHERE p2.product_category_name = p.product_category_name
);


