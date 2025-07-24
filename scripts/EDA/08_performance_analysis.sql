/*
Analyse the yearly performance of categories by comparing each product's sales
to both its average sales performance and the previous year's sales
*/

WITH yearly_category_sales AS
(
	SELECT
		YEAR(o.order_date) AS order_year,
		p.category,
		SUM(o.sales) AS cy_sales
	FROM fact_orders AS o
	LEFT JOIN dim_products AS p
		ON p.product_key = o.product_key
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(order_date), p.category
)
SELECT
	order_year,
	category,
	cy_sales,
	LAG(cy_sales) OVER(PARTITION BY category ORDER BY order_year) AS py_sales,
	cy_sales - LAG(cy_sales) OVER(PARTITION BY category ORDER BY order_year) AS diff_py,
	CASE WHEN cy_sales - LAG(cy_sales) OVER(PARTITION BY category ORDER BY order_year) > 0 THEN 'Increase'
		 WHEN cy_sales - LAG(cy_sales) OVER(PARTITION BY category ORDER BY order_year) < 0 THEN 'Decrease'
		 ELSE 'No Change'
	END AS py_change,
	ROUND(CAST(AVG(cy_sales) OVER(PARTITION BY category) AS FLOAT), 2) AS avg_sales,
	cy_sales - AVG(cy_sales) OVER(PARTITION BY category) AS diff_avg,
	CASE WHEN cy_sales - AVG(cy_sales) OVER(PARTITION BY category) > 0 THEN 'Above AVG'
		 WHEN cy_sales - AVG(cy_sales) OVER(PARTITION BY category) < 0 THEN 'Below AVG'
		 ELSE 'AVG'
	END AS avg_change
FROM yearly_category_sales
ORDER BY category, order_year;