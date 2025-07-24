-- =============================================================================
-- Create Report: report_customers
-- =============================================================================
IF OBJECT_ID('report_customers', 'V') IS NOT NULL
    DROP VIEW report_customers;
GO

CREATE VIEW report_customers AS
	WITH base_query AS
	(
		/*---------------------------------------------------------
		(1) Base Query: Retrive core columns from tables
		---------------------------------------------------------*/

		SELECT
			o.order_id,
			o.product_key,
			c.customer_key,
			c.customer_id,
			c.customer_name,
			ROUND( CAST(o.sales / COALESCE(NULLIF(o.quantity, 0), 1) AS FLOAT), 2) AS price,
			o.quantity,
			o.sales,
			o.order_date
		FROM fact_orders AS o
		LEFT JOIN dim_customers AS c
			ON c.customer_key = o.customer_key
		WHERE o.order_date IS NOT NULL
	)
	, customer_aggregation AS
	(	
		/*---------------------------------------------------------------------------
		2) Customer Aggregations: Summarizes key metrics at the customer level
		---------------------------------------------------------------------------*/

		SELECT
			customer_key,
			customer_id,
			customer_name,
			COUNT(DISTINCT order_id) AS total_orders,
			COUNT(DISTINCT product_key) AS total_products,
			SUM(sales) AS total_sales,
			SUM(quantity) AS total_quantity,
			MAX(order_date) AS last_order,
			DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
		FROM base_query
		GROUP BY
			customer_key,
			customer_id,
			customer_name
	)
	/*---------------------------------------------------------------------------
    3) Final Query: Combines all customer results into one output
    ---------------------------------------------------------------------------*/
	SELECT
		customer_key,
		customer_id,
		customer_name,
		CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
			 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
			 ELSE 'New'
		END AS customer_segment,
		last_order,
		DATEDIFF(month, last_order, GETDATE()) AS recency,
		total_orders,
		total_products,
		total_sales,
		total_quantity,
		lifespan,
		-- Compute average order value (AVO)
		CASE WHEN total_orders IS NULL OR total_orders = 0 THEN 0
			 ELSE ROUND(CAST(total_sales / total_orders AS FLOAT), 2)
		END AS avg_order_value,
		-- Compute average monthly spend
		CASE WHEN lifespan IS NULL OR lifespan = 0 THEN 0
			 ELSE ROUND(CAST(total_sales / lifespan AS FLOAT), 2)
		END AS avg_monthly_spending
	FROM customer_aggregation;