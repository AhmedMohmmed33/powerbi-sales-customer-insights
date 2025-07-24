-- Which categories contribute the most to overall sales?
SELECT
	category,
	total_sales,
	SUM(total_sales) OVER() AS overall_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER()) * 100 , 2), ' %') AS percentage_of_total 
FROM(
	SELECT
		p.category,
		SUM(o.sales) AS total_sales
	FROM fact_orders AS o
	LEFT JOIN dim_products AS p
		ON p.product_key = o.product_key
	GROUP BY p.category
)t
ORDER BY total_sales DESC;


-- Which categories and subcategories contribute the most to total number of orders?
WITH category_orders AS
(
	SELECT
		p.category,
		p.sub_category,
		COUNT(o.order_id) AS total_orders
	FROM fact_orders AS o
	LEFT JOIN dim_products AS p
		ON p.product_key = o.product_key
	GROUP BY p.category, p.sub_category
)
SELECT
	category,
	sub_category,
	total_orders,
	SUM(total_orders) OVER() AS overall_orders,
	CONCAT(ROUND(CAST(total_orders AS FLOAT) / SUM(total_orders) OVER() * 100, 2), ' %') AS percentage_of_total
FROM category_orders
ORDER BY total_orders DESC;