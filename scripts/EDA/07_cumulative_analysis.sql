-- Calculate total sales per month and runnig total of sales over time
SELECT
	order_month,
	total_sales,
	SUM(total_sales) OVER(PARTITION BY YEAR(order_month) ORDER BY order_month) AS running_total

FROM
(
	SELECT
		DATETRUNC(month, order_date) AS order_month,
		SUM(sales) AS total_sales
	FROM fact_orders
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month, order_date)
)t