
# 📘 SQL Data Analytics Concepts – Explained for Interviews & Projects

This guide walks you through all the essential SQL scripts and analysis concepts, from initializing a database to delivering stakeholder-ready product and customer reports. Each section includes what it is, why it matters, SQL examples, and real-world value.

---

## 🔹 00. init_database.sql

✅ **What is it?**  
This script sets up the base schema, tables, and sample data you'll use throughout the analysis. Think of it as laying the foundation for your data warehouse or analytics database.

✅ **Why It’s Important**  
- Tables exist with correct types and keys  
- Initial data is inserted  
- Referential integrity is established  

✅ **Example**
```sql
-- Create a simple dimension table
CREATE TABLE dim_product (
  product_id INT PRIMARY KEY,
  product_name TEXT,
  category TEXT
);

-- Create a fact table
CREATE TABLE fact_sales (
  sale_id INT PRIMARY KEY,
  product_id INT,
  quantity INT,
  revenue NUMERIC,
  sale_date DATE,
  FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);
```

✅ **Real-World Value**  
Like prepping ingredients before cooking—ensures a solid foundation.

---

## 🔹 01. database_exploration.sql

✅ **What is it?**  
Initial review of all tables: schemas, row counts, nulls, and basic understanding of the dataset.

✅ **Why It’s Important**  
- Check table relationships  
- Spot missing or unexpected values  
- Identify duplicates or keys

✅ **Example**
```sql
-- List all tables
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

-- Check row count
SELECT 'fact_sales' AS table_name, COUNT(*) FROM fact_sales
UNION ALL
SELECT 'dim_product', COUNT(*) FROM dim_product;
```

✅ **Real-World Value**  
This is your “data audit” step. Without it, you're flying blind.

---

## 🔹 02. dimensions_exploration.sql

✅ **What is it?**  
Analyzing categorical fields like region, product category, and customer segments — these are your dimensions.

✅ **Why It’s Important**  
- Used to group and segment metrics  
- Essential for dashboards and KPIs

✅ **Example**
```sql
-- Count of unique values per dimension
SELECT category, COUNT(*) AS num_products
FROM dim_product
GROUP BY category;
```

✅ **Real-World Value**  
Defines how you filter and drill down data for insights.

---

## 🔹 03. date_range_exploration.sql

✅ **What is it?**  
Analyzing the time coverage and granularity of your dataset.

✅ **Why It’s Important**  
Time is central to almost every business analysis.

✅ **Example**
```sql
SELECT MIN(order_date) AS start_date, MAX(order_date) AS end_date
FROM fact_sales;

SELECT order_date, COUNT(*)
FROM fact_sales
GROUP BY order_date
ORDER BY order_date;
```

✅ **Real-World Value**  
Answers: “Do we have complete data for Q1?” “Is the trend reliable?”

---

## 🔹 04. measures_exploration.sql

✅ **What is it?**  
Exploring numeric columns like revenue, cost, profit, quantity.

✅ **Why It’s Important**  
- Spot outliers  
- Understand distributions  
- Prepare for KPIs

✅ **Example**
```sql
SELECT
  MIN(sales_amount),
  MAX(sales_amount),
  AVG(sales_amount),
  STDDEV(sales_amount)
FROM fact_sales;
```

✅ **Real-World Value**  
Builds trust in the metrics used across dashboards.

---

## 🔹 05. magnitude_analysis.sql

✅ **What is it?**  
Finding biggest contributors—top products, customers, or regions.

✅ **Why It’s Important**  
Business prioritization and strategic targeting.

✅ **Example**
```sql
SELECT product_id, SUM(revenue) AS total_revenue
FROM fact_sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 5;
```

✅ **Real-World Value**  
Answer: “What should we double down on?”

---

## 🔹 06. ranking_analysis.sql

✅ **What is it?**  
Ranking entities by performance.

✅ **Why It’s Important**  
- See who’s winning  
- Allocate resources better  
- Benchmark results

✅ **Example**
```sql
SELECT
  product_id,
  RANK() OVER(ORDER BY SUM(revenue) DESC) AS product_rank
FROM fact_sales
GROUP BY product_id;
```

✅ **Real-World Value**  
Drives dashboards, leaderboards, and sales contests.

---

## 🔹 07. change_over_time_analysis.sql

✅ **What is it?**  
Track how values change across time periods.

✅ **Why It’s Important**  
Detect trends, growth, and seasonality.

✅ **Example**
```sql
WITH monthly_sales AS (
  SELECT DATE_TRUNC('month', sale_date) AS month, SUM(revenue) AS total_revenue
  FROM fact_sales
  GROUP BY month
)
SELECT
  month,
  total_revenue,
  LAG(total_revenue) OVER(ORDER BY month) AS prev_month,
  total_revenue - LAG(total_revenue) OVER(ORDER BY month) AS change
FROM monthly_sales;
```

✅ **Real-World Value**  
Shows business momentum and areas of concern.

---

## 🔹 08. cumulative_analysis.sql

✅ **What is it?**  
Calculating running totals.

✅ **Why It’s Important**  
Helpful for campaign tracking and monthly targets.

✅ **Example**
```sql
SELECT
  sale_date,
  SUM(revenue) OVER(ORDER BY sale_date) AS cumulative_revenue
FROM fact_sales;
```

✅ **Real-World Value**  
Track growth visually and compare progress.

---

## 🔹 09. performance_analysis.sql

✅ **What is it?**  
Compare actual performance to targets.

✅ **Why It’s Important**  
- Goal tracking  
- Variance detection  
- Accountability

✅ **Example**
```sql
SELECT
  region,
  SUM(revenue) AS actual_revenue,
  SUM(target_revenue) AS goal,
  SUM(revenue) - SUM(target_revenue) AS variance
FROM sales_targets
GROUP BY region;
```

✅ **Real-World Value**  
Answers: “Are we hitting our goals?”

---

## 🔹 10. data_segmentation.sql

✅ **What is it?**  
Divide data into subgroups (segments) like tier, region, category.

✅ **Why It’s Important**  
Tailored strategies, personalization, and group insights.

✅ **Example**
```sql
SELECT
  customer_segment,
  COUNT(DISTINCT customer_id) AS num_customers,
  SUM(revenue) AS total_revenue
FROM fact_sales
GROUP BY customer_segment;
```

✅ **Real-World Value**  
Supports targeting, retention, and LTV calculation.

---

## 🔹 11. part_to_whole_analysis.sql

✅ **What is it?**  
See each component’s share of the whole.

✅ **Why It’s Important**  
Find dominating categories or underperformers.

✅ **Example**
```sql
WITH total AS (
  SELECT SUM(revenue) AS total_revenue FROM fact_sales
)
SELECT
  category,
  SUM(revenue) AS category_revenue,
  ROUND(SUM(revenue) * 100.0 / (SELECT total_revenue FROM total), 2) AS pct_of_total
FROM fact_sales
JOIN dim_product USING (product_id)
GROUP BY category;
```

✅ **Real-World Value**  
Powerful for dashboards, pie charts, and executive slides.

---

## 🔹 12. report_customers.sql

✅ **What is it?**  
Customer-centric KPIs like spend, frequency, LTV.

✅ **Why It’s Important**  
Understand and retain your best customers.

✅ **Example**
```sql
SELECT
  customer_id,
  COUNT(order_id) AS num_orders,
  SUM(revenue) AS total_spent,
  AVG(revenue) AS avg_order_value
FROM fact_sales
GROUP BY customer_id;
```

✅ **Real-World Value**  
Builds CRM, loyalty, and high-ROI segments.

---

## 🔹 13. report_products.sql

✅ **What is it?**  
Metrics for product performance and lifecycle.

✅ **Why It’s Important**  
Informs pricing, inventory, and development.

✅ **Example**
```sql
SELECT
  product_id,
  SUM(quantity) AS units_sold,
  SUM(revenue) AS total_sales,
  AVG(revenue) AS avg_price
FROM fact_sales
GROUP BY product_id;
```

✅ **Real-World Value**  
Drives merchandising, campaigns, and stocking decisions.

---

📌 Your role as an analyst isn’t just to summarize data — it's to help the business make better, faster, smarter decisions.

