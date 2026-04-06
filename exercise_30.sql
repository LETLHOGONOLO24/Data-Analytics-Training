/*

Exercise_30

Tasks:

-Check which products are the top earners within every single category
(Health & Beauty, Watches, etc)
-Rank the dates in the orders table by how many orders were placed

*/

SELECT 
    p.product_category_name,
    oi.product_id,
    SUM(oi.price + oi.freight_value) AS total_revenue,
    DENSE_RANK() OVER (
        PARTITION BY p.product_category_name 
        ORDER BY SUM(oi.price + oi.freight_value) DESC
    ) AS category_rank
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name, oi.product_id;

-- Rank the dates in the orders table by how many orders were placed

SELECT 
    CAST(order_purchased_timestamp AS DATE) AS purchase_date,
    COUNT(order_id) AS total_orders,
    DENSE_RANK() OVER (ORDER BY COUNT(order_id) DESC) AS busy_day_rank
FROM orders
GROUP BY CAST(order_purchased_timestamp AS DATE);
