/*

Exercise_11

Tasks:

-Rank customers by total spending
-Calculate cumulative revenue over time

-Find each customer’s first order date
-Calculate revenue per order + running total per customer
-Find top 3 customers per month

*/

-- Rank customers by total spending

SELECT 
    o.customer_id,
    SUM(oi.price + oi.freight_value) AS total_spent,
    RANK() OVER (ORDER BY SUM(oi.price + oi.freight_value) DESC) AS rank
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY o.customer_id;
	
-- Calculate cumulative revenue over time

SELECT 
    DATE_TRUNC('month', o.order_purchased_timestamp) AS month,
    SUM(oi.price + oi.freight_value) AS monthly_revenue,
    SUM(SUM(oi.price + oi.freight_value)) OVER (
        ORDER BY DATE_TRUNC('month', o.order_purchased_timestamp)
    ) AS cumulative_revenue
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- Find each customer’s first order date

SELECT 
    customer_id,
    MIN(order_purchased_timestamp) AS first_order_date
FROM orders
GROUP BY customer_id;

-- Calculate revenue per order + running total per customer

SELECT 
    o.customer_id,
    o.order_id,
    SUM(oi.price + oi.freight_value) AS order_value,
    SUM(SUM(oi.price + oi.freight_value)) OVER (
        PARTITION BY o.customer_id
        ORDER BY o.order_purchased_timestamp
    ) AS running_total
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY o.customer_id, o.order_id, o.order_purchased_timestamp;

-- Find top 3 customers per month

SELECT *
FROM (
    SELECT 
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        o.customer_id,
        SUM(oi.price + oi.freight_value) AS revenue,
        RANK() OVER (
            PARTITION BY DATE_TRUNC('month', o.order_purchased_timestamp)
            ORDER BY SUM(oi.price + oi.freight_value) DESC
        ) AS rank
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    GROUP BY month, o.customer_id
) sub
WHERE rank <= 3;