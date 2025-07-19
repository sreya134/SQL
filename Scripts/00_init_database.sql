/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

1. Database Creation and Reset
USE master;
GO

-- Drop database if it exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Create fresh database
CREATE DATABASE DataWarehouseAnalytics;
GO

2. Step 2: Switch to the New Database

USE DataWarehouseAnalytics;
GO

3. Step 3: Create Schema gold

CREATE SCHEMA gold;
GO
  
4. Create Tables
  
--Dimension: Customers

CREATE TABLE gold.dim_customers(
    customer_key INT,
    customer_id INT,
    customer_number NVARCHAR(50),
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    country NVARCHAR(50),
    marital_status NVARCHAR(50),
    gender NVARCHAR(50),
    birthdate DATE,
    create_date DATE
);
GO
  
--Dimension: Products

CREATE TABLE gold.dim_products(
    product_key INT,
    product_id INT,
    product_number NVARCHAR(50),
    product_name NVARCHAR(50),
    category_id NVARCHAR(50),
    category NVARCHAR(50),
    subcategory NVARCHAR(50),
    maintenance NVARCHAR(50),
    cost INT,
    product_line NVARCHAR(50),
    start_date DATE
);
GO
  
--Fact Table: Sales

CREATE TABLE gold.fact_sales(
    order_number NVARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity TINYINT,
    price INT
);
GO
  
5. Load Data into Tables Using BULK INSERT
  
--Load: Customers

-- Clear table first
TRUNCATE TABLE gold.dim_customers;
GO

-- Load from CSV
BULK INSERT gold.dim_customers
FROM 'C:\sql\sql-data-analytics-project\datasets\csv-files\gold.dim_customers.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO
  
--Load: Products

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'C:\sql\sql-data-analytics-project\datasets\csv-files\gold.dim_products.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO
  
--Load: Sales

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'C:\sql\sql-data-analytics-project\datasets\csv-files\gold.fact_sales.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO

  
📌 Summary
Table	Type	Description
gold.dim_customers	Dimension	Customer details
gold.dim_products	  Dimension	Product metadata
gold.fact_sales	    Fact	    Transactional sales data
