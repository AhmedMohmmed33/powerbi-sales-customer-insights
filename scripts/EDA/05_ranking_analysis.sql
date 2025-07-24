-- Which 5 products generate the highest revenue?
-- Simple Ranking
SELECT TOP 5
	p.product_name,
	SUM(sales) AS total_revenue
FROM fact_orders AS o
LEFT JOIN dim_products AS p
	ON p.product_key = o.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Complex but Flexibly Ranking Using Window Functions
SELECT *
FROM (
	SELECT
		p.product_name,
		SUM(sales) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(sales) DESC) AS ranking
	FROM fact_orders AS o
	LEFT JOIN dim_products AS p
		ON p.product_key = o.product_key
	GROUP BY p.product_name
)t WHERE ranking <= 5;

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
	p.product_name,
	SUM(sales) AS total_revenue
FROM fact_orders AS o
LEFT JOIN dim_products AS p
	ON p.product_key = o.product_key
GROUP BY p.product_name
ORDER BY total_revenue;

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
	c.customer_name,
	SUM(sales) AS total_revenue
FROM fact_orders AS o
LEFT JOIN dim_customers AS c
	ON c.customer_key = o.customer_key
GROUP BY c.customer_name
ORDER BY total_revenue DESC;

-- The 3 customers with the highest orders placed
SELECT *
FROM (
	SELECT
		c.customer_name,
		COUNT(DISTINCT o.order_id) AS total_orders,
		DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT o.order_id) DESC) AS ranking
	FROM fact_orders AS o
	LEFT JOIN dim_customers AS c
		ON c.customer_key = o.customer_key
	GROUP BY c.customer_name
)t WHERE ranking <= 3
ORDER BY ranking;

-- The 3 customers with the fewest orders placed
SELECT TOP 3
	c.customer_name,
	COUNT(DISTINCT o.order_id) AS total_orders
FROM fact_orders AS o
LEFT JOIN dim_customers AS c
	ON c.customer_key = o.customer_key
GROUP BY c.customer_name
ORDER BY total_orders;