/*

Exercise_25

Tasks:

Find each customer’s first purchase month
Calculate number of customers returning each month
Calculate retention rate per cohort

*/

-- Find each customer’s first purchase month

WITH first_order AS (
    SELECT 
        customer_id,
        MIN(order_purchase_timestamp) AS first_date
    FROM orders
    GROUP BY customer_id
)
SELECT 
    customer_id,
    DATE_TRUNC('month', first_date) AS cohort_month
FROM first_order;

-- Calculate number of customers returning each month

WITH first_order AS (
    SELECT customer_id, MIN(order_purchase_timestamp) AS first_date
    FROM orders
    GROUP BY customer_id
)
SELECT 
    DATE_TRUNC('month', f.first_date) AS cohort,
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
    COUNT(DISTINCT o.customer_id) AS customers
FROM orders o
JOIN first_order f ON o.customer_id = f.customer_id
GROUP BY cohort, order_month
ORDER BY cohort, order_month;

-- Calculate retention rate per cohort

WITH cohort_size AS (
    SELECT 
        DATE_TRUNC('month', MIN(order_purchase_timestamp)) AS cohort,
        COUNT(DISTINCT customer_id) AS size
    FROM orders
    GROUP BY customer_id
),
retention AS (
    SELECT 
        DATE_TRUNC('month', f.first_date) AS cohort,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        COUNT(DISTINCT o.customer_id) AS returning
    FROM orders o
    JOIN (
        SELECT customer_id, MIN(order_purchase_timestamp) AS first_date
        FROM orders
        GROUP BY customer_id
    ) f ON o.customer_id = f.customer_id
    GROUP BY cohort, order_month
)
SELECT 
    r.cohort,
    r.order_month,
    r.returning,
    c.size,
    r.returning * 1.0 / c.size AS retention_rate
FROM retention r
JOIN cohort_size c ON r.cohort = c.cohort;


