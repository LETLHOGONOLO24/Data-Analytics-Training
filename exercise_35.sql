/*

Exercise_35

Tasks:

Create a simple funnel:
	Total Orders
	Orders delivered

	Orders canceled
	Calculate conversion rates between stages

*/

-- Count orders by status

SELECT 
    order_status,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_status;

-- Funnel counts

SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) AS delivered,
    SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) AS canceled
FROM orders;

-- Conversion rates

SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS delivery_rate,
    SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS cancel_rate
FROM orders;



