-- Retrive a list of unique countries from which customers originate
SELECT DISTINCT
	country,
	region,
	state
FROM dim_location
ORDER BY country, region, state;

-- Retrive a list of unique categories, subcategories, and product name
SELECT DISTINCT
	category,
	sub_category,
	product_name
FROM dim_products
ORDER BY category, sub_category, product_name;
