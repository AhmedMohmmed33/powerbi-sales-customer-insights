-- ====================================================================
-- Checking 'Customers Table'
-- ====================================================================

SELECT * FROM dim_customers;

-- Check For Nulls or Duplicates in Primary key
-- Expectation : No Result
SELECT
	customer_id,
	COUNT(*) duplicate_count
FROM dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL;

-- Check Unwanted Spaces
-- Expectation : No Result
SELECT
	customer_name
FROM dim_customers
WHERE customer_name != TRIM(customer_name);


-- ====================================================================
-- Checking 'Products Table'
-- ====================================================================
SELECT * FROM dim_products;

-- Check For Nulls or Duplicates in Primary key
-- Expectation : No Result
SELECT
	product_key,
	COUNT(*) duplicate_count
FROM dim_products
GROUP BY product_key
HAVING COUNT(*) > 1 OR product_key IS NULL;

SELECT *
FROM dim_products
WHERE product_id = 'FUR-FU-10004270';

-- Check Unwanted Spaces
-- Expectation : No Result
SELECT
	category,
	sub_category,
	product_name
FROM Products
WHERE category != TRIM(category) OR sub_category != TRIM(sub_category) OR product_name != TRIM(product_name);


-- ====================================================================
-- Checking 'Location Table'
-- ====================================================================
SELECT * FROM dim_location;

-- Check For Nulls or Duplicates in Primary key
-- Expectation : No Result
select
	location_key,
	COUNT(*) AS duplicate_count
from dim_location
GROUP BY location_key
HAVING COUNT(*) > 1 OR location_key IS NULL;

SELECT * FROM Location
WHERE postal_code IS NULL OR postal_code = '92024'

SELECT * FROM dim_location
WHERE postal_code IS NULL OR postal_code = '92024'

-- ====================================================================
-- Checking 'Orders Table'
-- ====================================================================
SELECT * FROM fact_orders;

--Check for invalid date orders
SELECT *
FROM fact_orders
WHERE order_date > ship_date;

-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM fact_orders f
LEFT JOIN dim_customers c
	ON c.customer_key = f.customer_key
LEFT JOIN dim_products p
	ON p.product_key = f.product_key
LEFT JOIN dim_location l
	ON l.location_key = f.location_key;