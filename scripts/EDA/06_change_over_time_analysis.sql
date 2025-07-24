-- Analyzing sales performance over time
-- Quik date function
SELECT
	YEAR(order_date) AS year,
	MONTH(order_date) AS month,
	SUM(sales) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT customer_key) AS total_customer,
	COUNT(DISTINCT product_key) AS total_product
FROM fact_orders
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- Datetrunc()
SELECT
	DATETRUNC(month, order_date) AS order_date,
	SUM(sales) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT customer_key) AS total_customer,
	COUNT(DISTINCT product_key) AS total_product
FROM fact_orders
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);

-- Format()
SELECT
	YEAR(order_date) AS year,
	MONTH(order_date) AS month,
	FORMAT(order_date, 'yy-MMM') AS order_date,
	SUM(sales) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT customer_key) AS total_customer,
	COUNT(DISTINCT product_key) AS total_product
FROM fact_orders
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yy-MMM'), YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);
