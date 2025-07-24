-- ====================================================================
-- Checking 'Customers Table'
-- ====================================================================
-- Check For Nulls or Duplicates in Primary key
-- Expectation : No Result
SELECT
	customer_id,
	COUNT(*) duplicate_count
FROM Customers
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL;

-- Check Unwanted Spaces
-- Expectation : No Result
SELECT
	customer_name
FROM Customers
WHERE customer_name != TRIM(customer_name);

-- ====================================================================
-- Checking 'Products Table'
-- ====================================================================
-- Check For Nulls or Duplicates in Primary key
-- Expectation : No Result
SELECT
	product_id,
	COUNT(*) duplicate_count
FROM Products
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;

SELECT *
FROM Products
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
-- Check For Nulls or Duplicates in Primary key
-- Expectation : No Result
select
	postal_code,
	COUNT(*) AS duplicate_count
from Location
GROUP BY postal_code
HAVING COUNT(*) > 1 OR postal_code IS NULL;

SELECT * FROM Location
WHERE postal_code IS NULL OR postal_code = '92024'

SELECT * FROM Orders
WHERE postal_code IS NULL OR postal_code = '92024'

SELECT postal_code FROM Orders
WHERE  postal_code NOT IN (SELECT postal_code FROM Location)

-- ====================================================================
-- Checking 'Orders Table'
-- ====================================================================
--Check for invalid date orders
SELECT *
FROM Orders
WHERE order_date > ship_date;