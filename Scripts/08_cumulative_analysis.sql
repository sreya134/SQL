/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month 
-- and the running total of sales over time 
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM
(
    SELECT 
        DATETRUNC(year, order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) t




Calculate:

Total yearly sales (total_sales)

Running total of sales over years (running_total_sales)

Moving average of product price across years (moving_average_price)

Why Cumulative / Running Totals Matter
➤ Definition:
A running total (also called cumulative total) is the progressive sum of a measure over time.

➤ Use Cases in Business:
Use Case				Business Value
Tracking sales toward annual targets	Shows how far you've come vs goal
Visualizing revenue accumulation	Useful in charts: “Year to Date” progress
Comparing performance over time		See acceleration, flattening, or declines

🔍 How to Interpret This Output
Year (order_date)	total_sales	running_total_sales	moving_average_price
2010	43,419		43,419		3101
2011	7,057,088	7,118,507	3146
2012	5,042,321	12,160,828	2670
2013	16,344,889	28,505,717	2080
2014	45642		29,351,258	1668

Insights You Can Draw:
Sales are increasing year-over-year, especially in 2013 (huge jump).

Running total keeps climbing — expected in cumulative views.

Average price is decreasing each year — maybe due to discounts, new cheaper products, or market competition.
