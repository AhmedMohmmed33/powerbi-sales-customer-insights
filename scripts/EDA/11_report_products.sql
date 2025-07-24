-- =============================================================================
-- Create Report: report_products
-- =============================================================================
IF OBJECT_ID('report_products', 'V') IS NOT NULL
   DROP VIEW report_products 
GO

CREATE VIEW report_products AS
	WITH base_query AS
	(
		/*---------------------------------------------------------------------------
		1) Base Query: Retrieves core columns from fact_sales and dim_products
		---------------------------------------------------------------------------*/
		SELECT
			O.order_id,
			O.customer_key,
			P.product_key,
			P.product_id,
			P.product_name,
			P.category,
			P.sub_category,
			O.sales,
			O.quantity,
			o.order_date
		FROM fact_orders AS o
		LEFT JOIN dim_products AS p
			ON p.product_key = o.product_key
		WHERE o.order_date IS NOT NULL
	)
	, product_aggregation AS
	(
		/*---------------------------------------------------------------------------
		2) Product Aggregations: Summarizes key metrics at the product level
		---------------------------------------------------------------------------*/
		SELECT
			product_key,
			product_id,
			product_name,
			category,
			sub_category,
			COUNT(customer_key) AS total_customers,
			COUNT(order_id) AS total_orders,
			MAX(order_date) AS last_order,
			DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
			SUM(sales) AS total_sales,
			SUM(quantity) AS total_quantity,
			ROUND(AVG(CAST(sales AS FLOAT) / NULLIF(quantity, 0)), 2) AS avg_selling_price
		FROM base_query
		GROUP BY
			product_key,
			product_id,
			product_name,
			category,
			sub_category
	)
	/*---------------------------------------------------------------------------
	3) Final Query: Combines all product results into one output
	---------------------------------------------------------------------------*/
	SELECT
		product_key,
		product_id,
		product_name,
		category,
		sub_category,
		CASE WHEN total_sales > 5000 THEN 'High_Performer'
			 WHEN total_sales >= 1000 THEN 'Mid_Range'
			 ELSE 'Low_Performer'
		END AS product_segment,
		last_order,
		DATEDIFF(month, last_order, GETDATE()) AS recency,
		lifespan,
		total_customers,
		total_orders,
		total_quantity,
		total_sales,
		avg_selling_price,
		-- Compute average order revenue
		CASE WHEN total_orders IS NULL OR total_orders = 0 THEN 0
			 ELSE ROUND(CAST(total_sales / total_orders AS FLOAT), 2)
		END AS avg_order_revenue,
		-- Compute average monthly revenue
		CASE WHEN lifespan IS NULL OR lifespan = 0 THEN 0
			 ELSE ROUND(CAST(total_sales / lifespan AS FLOAT), 2)
		END AS avg_monthly_revenue
	FROM product_aggregation;