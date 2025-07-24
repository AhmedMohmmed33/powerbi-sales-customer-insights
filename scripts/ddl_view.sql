-- ============================================================================
-- Create Dimension: dim_customers            
-- ============================================================================
IF OBJECT_ID('dim_customers', 'V') IS NOT NULL
   DROP VIEW dim_customers;
GO

CREATE VIEW dim_customers AS
	SELECT
		ROW_NUMBER() OVER(ORDER BY customer_id) AS customer_key,
		customer_id,
		customer_name
	FROM Customers;
GO

-- ============================================================================
-- Create Dimension: dim_products
-- ============================================================================
IF OBJECT_ID('dim_products', 'V') IS NOT NULL
   DROP VIEW dim_products;
GO

CREATE VIEW dim_products AS
	SELECT
		ROW_NUMBER() OVER(ORDER BY product_id, category, sub_category, product_name) AS product_key,	
		product_id,
		category,
		sub_category,
		product_name
	FROM Products;
GO

-- ============================================================================
-- Create Dimension: dim_location
-- ============================================================================
IF OBJECT_ID('dim_location', 'V') IS NOT NULL
   DROP VIEW dim_location;
GO

CREATE VIEW dim_location AS
	SELECT
		ROW_NUMBER() OVER(ORDER BY postal_code, city, state, region, country) AS location_key,
		postal_code,
		city,
		state,
		region,
		country
	FROM Location
	WHERE postal_code IS NOT NULL;
GO

-- ============================================================================
-- Create Fact Table: fact_orders
-- ============================================================================
IF OBJECT_ID('fact_orders', 'V') IS NOT NULL
   DROP VIEW fact_orders;
GO

CREATE VIEW fact_orders AS
	SELECT
		row_id,
		order_id,
		order_date,
		ship_date,
		ship_mode,
		c.customer_key,
		segment,
		l.location_key,
		l.postal_code,
		p.product_key,
		sales,
		quantity,
		discount,
		profit
	FROM Orders f
	LEFT JOIN dim_customers c
		ON f.customer_id = c.customer_id
	LEFT JOIN dim_products p
		ON f.product_id = p.product_id
	LEFT JOIN dim_location l
		ON f.postal_code = l.postal_code;
GO 