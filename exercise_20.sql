/*

Exercise_16

Tasks:

-Assign each customer a cohort month (first purchase)
-Calculate monthly revenue per cohort

-Count customers per cohort
-Calculate retention (customers returning each month)

*/

-- Assign each customer a cohort month (first purchase)

WITH first_order AS (
    SELECT 
        customer_id,
        MIN(order_purchase_timestamp) AS first_order_date
    FROM orders
    GROUP BY customer_id
)
SELECT 
    customer_id,
    DATE_TRUNC('month', first_order_date) AS cohort_month
FROM first_order;

-- Calculate monthly revenue per cohort

WITH first_order AS (
    SELECT customer_id, MIN(order_purchase_timestamp) AS first_date
    FROM orders
    GROUP BY customer_id
)
SELECT 
    DATE_TRUNC('month', f.first_date) AS cohort,
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
    SUM(oi.price + oi.freight_value) AS revenue
FROM orders o
JOIN first_order f ON o.customer_id = f.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY cohort, order_month;




