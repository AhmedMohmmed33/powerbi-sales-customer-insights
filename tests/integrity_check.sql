USE DWAnalytics;
GO

-- Location referential integrity check
select postal_code from Location
where postal_code in (select postal_code from Orders)

-- Customer referential integrity check
select customer_id from Customers
where customer_id in (select customer_id from Orders)

-- Product referential integrity check
select product_id from Products
where product_id in (select product_id from Orders)
