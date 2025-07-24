-- Find the total sales
SELECT SUM(sales) AS total_sales FROM fact_orders;

-- How many items are sold
SELECT SUM(quantity) AS total_quantity FROM fact_orders;

-- Find the average selling price
SELECT 
	ROUND(AVG(price), 2) AS average_price
FROM
(
	SELECT
	ROUND(CAST(sales/COALESCE(quantity, 0) AS FLOAT), 2) AS price
	FROM fact_orders
)t;

-- Find the total number of orders
SELECT COUNT(order_id) AS total_orders FROM fact_orders;

-- Find the total number of products
SELECT COUNT(product_key) AS total_product FROM dim_products;


-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) FROM fact_orders;

-- Generate a report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales) AS measure_value FROM fact_orders
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM fact_orders
UNION ALL
SELECT 
	'Average Price', ROUND(AVG(price), 2)
FROM
(
	SELECT
	ROUND(CAST(sales/COALESCE(quantity, 0) AS FLOAT), 2) AS price
	FROM fact_orders
)t
UNION ALL
SELECT 'Total Orders', COUNT(order_id) FROM fact_orders
UNION ALL
SELECT 'Total Products', COUNT(product_key) FROM dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM dim_customers;