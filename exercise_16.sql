/*

Exercise_16

Tasks:

-Rank customers within each state by revenue
-Calculate moving average revenue (3 months)

-Find each customer’s previous order value
-Calculate % contribution of each customer to total revenue
-Identify top 20% customers (by revenue)

*/

-- Rank customers within each state by revenue

SELECT 
    c.customer_state,
    o.customer_id,
    SUM(oi.price + oi.freight_value) AS revenue,
    RANK() OVER (
        PARTITION BY c.customer_state
        ORDER BY SUM(oi.price + oi.freight_value) DESC
    ) AS rank
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_state, o.customer_id;

-- Calculate moving average revenue (3 months)

SELECT 
    month,
    monthly_revenue,
    AVG(monthly_revenue) OVER (
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3
FROM (
    SELECT 
        DATE_TRUNC('month', o.order_purchased_timestamp) AS month,
        SUM(oi.price + oi.freight_value) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY month
) sub;

-- Find each customer’s previous order value

SELECT 
    o.customer_id,
    o.order_id,
    SUM(oi.price + oi.freight_value) AS order_value,
    LAG(SUM(oi.price + oi.freight_value)) OVER (
        PARTITION BY o.customer_id
        ORDER BY o.order_purchased_timestamp
    ) AS previous_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id, o.order_id, o.order_purchased_timestamp;

-- Calculate % contribution of each customer to total revenue

SELECT 
    o.customer_id,
    SUM(oi.price + oi.freight_value) AS revenue,
    SUM(oi.price + oi.freight_value) * 100.0 /
    SUM(SUM(oi.price + oi.freight_value)) OVER () AS percentage
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id;

-- Identify top 20% customers (by revenue)

SELECT *
FROM (
    SELECT 
        o.customer_id,
        SUM(oi.price + oi.freight_value) AS revenue,
        NTILE(5) OVER (ORDER BY SUM(oi.price + oi.freight_value) DESC) AS bucket
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) sub
WHERE bucket = 1;



