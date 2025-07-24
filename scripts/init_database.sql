USE master;
GO

-- Drop and recreate the 'DWAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DWAnalytics')
BEGIN
	ALTER DATABASE DWAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DWAnalytics;
END;
GO

-- Create the 'DWAnalytics' database
CREATE DATABASE DWAnalytics;
GO

USE DWAnalytics;
GO


CREATE TABLE Customers(
	customer_id VARCHAR(50),
	customer_name VARCHAR(50) 
);
GO

CREATE TABLE Products(
	product_id VARCHAR(50),
	category VARCHAR(50),
	sub_category VARCHAR(50),
	product_name VARCHAR(200)
);
GO

CREATE TABLE Location(
	postal_code VARCHAR(50),
	city VARCHAR(50),
	state VARCHAR(50),
	region VARCHAR(50),
	country VARCHAR(50)
);
GO

CREATE TABLE Orders(
	row_id INT,
	order_id VARCHAR(50),
	order_date DATE,
	ship_date DATE,
	ship_mode VARCHAR(50),
	customer_id VARCHAR(50),
	segment VARCHAR(50),
	postal_code VARCHAR(50),
	product_id VARCHAR(50),
	sales DECIMAL(10,2),
	quantity INT,
	discount DECIMAL(5,2),
	profit DECIMAL(10,2)
);
GO

TRUNCATE TABLE Customers;
GO

BULK INSERT Customers
FROM 'D:\sql_projects\SQL_Analytics\dataset\Customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	TABLOCK
);
GO

TRUNCATE TABLE Products;
GO

BULK INSERT Products
FROM 'D:\sql_projects\SQL_Analytics\dataset\Products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	TABLOCK
);
GO

TRUNCATE TABLE Location;
GO

BULK INSERT Location
FROM 'D:\sql_projects\SQL_Analytics\dataset\Location.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	TABLOCK
);
GO

-- Create staging table
CREATE TABLE stg_orders(
    row_id VARCHAR(50),
    order_id VARCHAR(50),
    order_date VARCHAR(50),
    ship_date VARCHAR(50),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    segment VARCHAR(50),
    postal_code VARCHAR(50),
    product_id VARCHAR(50),
    sales VARCHAR(50),
    quantity VARCHAR(50),
    discount VARCHAR(50),
    profit VARCHAR(50)
);

TRUNCATE TABLE stg_orders;
GO

BULK INSERT stg_orders
FROM 'D:\sql_projects\SQL_Analytics\dataset\Orders.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	TABLOCK
);
GO

-- Transform and load into fact table
INSERT INTO Orders
SELECT 
    CAST(row_id AS INT),
    order_id,
    CONVERT(DATE, order_date, 103), -- 103 = DD/MM/YYYY format
    CONVERT(DATE, ship_date, 103),
    ship_mode,
    customer_id,
    segment,
    postal_code,
    product_id,
    CAST(sales AS DECIMAL(10,2)),
    CAST(quantity AS INT),
    CAST(discount AS DECIMAL(5,2)),
    CAST(profit AS DECIMAL(10,2))
FROM stg_orders;

-- Clean up
DROP TABLE stg_orders;