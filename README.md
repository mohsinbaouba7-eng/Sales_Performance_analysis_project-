
# 🎯 Introduction

Welcome to my Sales Performance Analysis portfolio project! This project explores a dataset of **10,000 Global Sales Records** to uncover critical insights regarding company profitability, regional trends, operational efficiency, and year-over-year financial growth. 

The goal of this analysis is to demonstrate how advanced SQL workflows can transform raw transactional records into actionable strategic business intelligence.

---
# 🗺️ Background
Driven by a desire to practice advanced SQL querying and real-world business intelligence, this portfolio project simulates the role of a Lead Data Analyst. The goal is to streamline complex sales data into actionable strategies—helping stakeholders easily pinpoint **high-growth regions**, **identify top-performing products**, and **optimize supply chain timelines**.

The analysis is built on a comprehensive **sales dataset featuring regions, item types, sales channels, order dates, and financial metrics (revenue, cost, and profit)**.

---

## ❓ The Questions I Wanted to Answer Through My SQL Queries:

1. *Database Setup:* How do we properly structure and import the raw sales records? 

2. *Business Health:* What is the total financial health of the business in terms of overall revenue and net profit? 

3.  Which item types stand out as the most profitable? 

4.  How does sales performance vary across different global regions? 

5. *Growth Trends:* What is our Year-over-Year (YoY) growth status? 

6. *Seasonal Deep-Dive:* How do profits compare specifically between May 2016 and May 2017? 

7. *Logistics Efficiency:* What does the gap look like between our average delivery times and maximum delivery times? 

---
# 🛠️ Tools & Technologies Used
* **SQL (PostgreSQL):** Core engine used for complex data cleaning, aggregation, time-series calculations, and business analytics.
* **VS Code:** Development environment for writing scripts, managing version control, and organizing the project codebase.
* **Git & GitHub:** For project tracking, commit history, and public portfolio presentation.

---

# 🗂️ The Analysis

All data processing scripts are organized inside the [sale_sql_queries folder](/Sales_Perfomance_Project/sales_sql_queries/) folder. Below is an overview of what each script accomplishes:

### 1. Data Ingestion & Table Initialization
* **File:** `1_Creating_sales_table.sql`
* **Purpose:** Sets up the database schema, defines accurate data types (e.g., handling numeric fields for precision), and manages the initial import structure for the `10000 Sales Records.csv` dataset.

```sql
- 1- CREATING sales_table 

CREATE TABLE sales_table (
    "Region" VARCHAR(100),
    "Country" VARCHAR(100),
    "Item_Type" VARCHAR(100),
    "Sales_Channel" VARCHAR(50),
    "Order_Priority" VARCHAR(10),
    "Order_Date" DATE,               -- Safe to use DATE now (MDY format)
    "Order_ID" BIGINT,               -- IDs can be large, BIGINT prevents overflow
    "Ship_Date" DATE,                -- Safe to use DATE now
    "Units_Sold" INT,
    "Unit_Price" NUMERIC(10,2),
    "Unit_Cost" NUMERIC(10,2),
    "Total_Revenue" NUMERIC(15,2),
    "Total_Cost" NUMERIC(15,2),
    "Total_Profit" NUMERIC(15,2)
);

-- 2- LOADING DATA into sales_table 

SET DATESTYLE = 'ISO, MDY';

COPY sales_table
FROM 'C:\cv portfolio\10000 Sales Records.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');


SELECT *
  FROM sales_table;


  -- 3- CREATING DELIVERY TIME COLUMN

ALTER TABLE sales_table
ADD COLUMN delivery_time INT;

-- 4. Populate the column with a calculated value 
UPDATE sales_table
SET delivery_time = "Ship_Date" - "Order_Date";

SELECT *
  FROM sales_table;

SELECT 
      column_name, data_type, character_maximum_length
   FROM information_schema.columns
   WHERE table_name = 'sales_table';
   ```


### 2. General Business Health
* **File:** `2_Total_financial_health_of_the_business.sql`
* **Purpose:** Calculates high-level executive KPIs including **Total Revenue**, **Total Cost**, and **Total Net Profit** across the entire lifetime of the dataset to evaluate global business performance.
```sql
SELECT 
    TO_CHAR(SUM("Total_Revenue"), '$99,999,999,999,99') AS GLOBAL_REVENUE,
    TO_CHAR(SUM("Total_Cost"), '$99,999,999,999,99') AS GLOBAL_COST,
    TO_CHAR(SUM("Total_Profit"), '$99,999,999,999,99') AS GLOBAL_PROFIT,
    ROUND((SUM("Total_Profit") / SUM("Total_Revenue")) * 100, 2) AS PROFIT_MARGIN

FROM 
sales_table;
```


### 3. Product & Inventory Optimization
* **File:** `3_Most_Profitable_Item_Type.sql`
* **Purpose:** Aggregates total profit grouped by item types (e.g., Cosmetics, Clothes, Office Supplies) to pinpoint which product categories drive the highest profit margins and should receive more marketing focus.

```sql
SELECT
    sales_table."Item_Type",
TO_CHAR(SUM(sales_table."Units_Sold"), 'FM99G999G999') As total_unit_sold,
TO_CHAR(SUM(sales_table."Total_Profit"),'$99,999,999,999,99') AS Total_Profit

FROM  sales_table
GROUP BY
    sales_table."Item_Type"
ORDER BY Total_Profit DESC;
```
 The most profitable Item_type is
"HOUSEHOLD", It is leading by $7,187,363,61 of Profit with 4336803 units sold.
<img src= "Sales_Performance_Project/assets/Most profitable item.jpeg" width="85%">

*Bar Graph of the Most profitable Item sold; ChatGPT genetated this from my SQL query results*

### 4. Geographic & Regional Trends
* **File:** `4_Performance_by_Region.sql`
* **Purpose:** Breaks down sales volume and total margins by global regions (such as Sub-Saharan Africa, Europe, Asia). This identifies our strongest geographic strongholds and maps out underperforming regional markets.

```sql
SELECT 
    sales_table."Region",
    TO_CHAR(SUM("Total_Profit"), '$99,999,999,999,99') AS Total_Profit,
    ROUND((SUM("Total_Profit") / SUM("Total_Revenue")) * 100, 2) AS PROFIT_MARGIN
FROM sales_table
GROUP BY sales_table."Region"
ORDER BY PROFIT_MARGIN DESC;
```
<img src= "Sales_Performance_Project/assets/total profit total margin by region .jpeg" width="85%">

### 5. Historical Growth Tracking
* **File:** `5_YoY_Growth.sql`
* **Purpose:** Utilizes advanced window functions (`LAG()`, `LEAD()`) to calculate **Year-over-Year (YoY) Growth Rates**. This determines whether the company's financial trajectories are accelerating or slowing down over time.

 ```sql
    /*IV- YEAR - TO - YEAR GROWTH :
 IS THE COMPANY GROWING OVER ITS PROFIT OVER OVER YEARS, OR DROPPING ?
    1- CREATE 2 NEW COLUMNS "Sales_year , Sales_month"
    2- EXTRACT MONTH/YEAR/
    3- Calculate YoY GROWTH*/

*/
-- add cloumn sales_year and sales_month
ALTER TABLE sales_table
    ADD COLUMN sales_year INT,
    ADD COLUMN sales_Month INT;

-- load the columns with data 
UPDATE sales_table
SET 
        sales_year =  EXTRACT(YEAR FROM "Order_Date"),
        sales_month = EXTRACT(MONTH FROM "Order_Date");

-- Calculate YOY Sales 

WITH MonthlySales AS (
    SELECT 
        sales_year,
        sales_month,
        SUM("Total_Revenue") AS current_sales
    FROM sales_table
    GROUP BY sales_year, sales_month
)
SELECT 
    sales_year,
    sales_month,
    -- 1. Format current sales nicely for presentation
    TO_CHAR(current_sales, '$999,999,999,999') AS current_year_sales,
    
    -- 2. Grab the sales from exactly 12 months ago
    LAG(current_sales, 12) OVER(ORDER BY sales_year, sales_month) AS previous_year_sales,
    
    -- 3. Calculate YoY Growth Percentage
    ROUND(
        ((current_sales - LAG(current_sales, 12) OVER(ORDER BY sales_year, sales_month)) 
        / LAG(current_sales, 12) OVER(ORDER BY sales_year, sales_month)) * 100, 
        2
    ) || '%' AS yoy_growth_percentage

FROM MonthlySales
ORDER BY sales_year DESC, sales_month DESC;
```


### 6. Deep-Dive Seasonal Analysis
* **File:** `6_May_Profit 2016 vs 2017.sql`
* **Purpose:** Performs a localized comparative analysis isolating specific calendar periods (May 2016 vs. May 2017) to study short-term variance, seasonal spikes, or anomalies in customer purchasing behavior.








### 7. Logistics & Supply Chain Efficiency
* **File:** `7_Avr_delivery time vs Max_delivery_time.sql`
* **Purpose:** Shifts focus to operations by computing metrics based on order dates and ship dates. It compares average delivery times against maximum delays to flag supply chain bottlenecks.
```sql
SELECT
   "Item_Type",
   ROUND(AVG(delivery_time), 2) AS Avg_delivery_time,
   MAX(delivery_time) AS MaX_delivery_time
    FROM sales_table
    GROUP BY "Item_Type"
    ORDER BY Avg_delivery_time ASC,
    MaX_delivery_time ;


SELECT *
FROM sales_table;
```

---

## 💡 Key Technical Skills Demonstrated
* **Time-Series Analysis:** Querying dates, extracting years/months, and comparing historical performance periods.
* **Window Functions:** Employing statistical ranking and offset fields to build financial trend models without altering raw tables.
* **Aggregations & Filters:** Mastering structural clauses (`GROUP BY`, `HAVING`, mathematical operators) to compress 10,000 distinct data rows into clear executive summaries.

# Conclusion
