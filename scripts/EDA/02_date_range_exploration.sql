-- Determine the first and last order date and the total duration in months
SELECT
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH ,MIN(order_date), MAX(order_date)) AS order_range_months
FROM fact_orders;