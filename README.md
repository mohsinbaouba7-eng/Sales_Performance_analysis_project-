
<div align = "justify">

# 🎯 Introduction

Welcome to my Sales Performance Analysis portfolio project! This project explores a dataset of **10,000 Global Sales Records** to uncover critical insights regarding company profitability, regional trends, operational efficiency, and year-over-year financial growth. 

The goal of this analysis is to demonstrate how advanced SQL workflows can transform raw transactional records into actionable strategic business intelligence.

---
# 🗺️ Background
Driven by a desire to practice advanced SQL querying and real-world business intelligence, this portfolio project simulates the role of a Lead Data Analyst. The goal is to streamline complex sales data into actionable strategies—helping stakeholders easily pinpoint **high-growth regions**, **identify the most profitable item type**, and **optimize supply chain timelines**.

The analysis is built on a comprehensive **sales dataset featuring regions, item types, sales channels, order dates, and financial metrics (revenue, cost, and profit)**.

---

## ❓ The Questions I Wanted to Answer Through My SQL Queries:

1. *Database Setup:* How do we properly structure and import the raw sales records? 

2. *Business Health:* What is the total financial health of the business in terms of overall revenue and net profit? 

3.  Which item types stand out as the most profitable? 

4.  How does sales performance vary across different global regions? 

5. What are the top 5 countries with the highest revenue?

6. *Growth Trends:* What is our Year-over-Year (YoY) growth status? 

. *Seasonal Deep-Dive:* How do profits compare specifically between May 2016 and May 2017? 

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
* **Purpose:** Calculates high-level executive KPIs including **GLOBAL Revenue**, **Global Cost**, **Global Profit**, **Profit margins** across the entire lifetime of the dataset to evaluate global business performance.
```sql
SELECT 
    TO_CHAR(SUM("Total_Revenue"), '$99,999,999,999,99') AS GLOBAL_REVENUE,
    TO_CHAR(SUM("Total_Cost"), '$99,999,999,999,99') AS GLOBAL_COST,
    TO_CHAR(SUM("Total_Profit"), '$99,999,999,999,99') AS GLOBAL_PROFIT,
    ROUND((SUM("Total_Profit") / SUM("Total_Revenue")) * 100, 2) AS PROFIT_MARGIN

FROM 
sales_table;
```
TOTAL FINANCIAL HEALTH OF THE BUSINESS

| global_revenue | global_cost | global_profit | profit_margin |
| :--- | :--- | :--- | :--- |
| $ 133,335,513,14 | $ 93,826,578,42 | $ 39,508,934,72 | 29.63 |

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
 The most profitable Item_type is "HOUSEHOLD", It is leading by $7,187,363,61 of Profit with 4336803 units sold.

| Item_Type | total_unit_sold | total_profit |
| :--- | :--- | :--- |
| Household | 4 336 803 | $ 7,187,383.61 |
| Cosmetics | 4 103 290 | $ 7,134,390.32 |
| Office Supplies | 4 120 263 | $ 5,201,382.04 |

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

*Bar Graph of total Profit and total Margin of different regions; ChatGPT genetated this from my SQL query results*


### 5. Top 5 Countries by Highest Total Revenue
* **Purpose:** Isoloates individual national markets by aggregating total sales volume. This identifies the top 5 highest-grossing countries globally, spotlighting key geographical strongholds and high-value customer hubs driving commercial growth.

```sql
SELECT
    "Country",
    TO_CHAR(SUM("Total_Revenue"), '$99,999,999,999') AS total_revenue
FROM sales_table
GROUP BY "Country"
ORDER BY SUM("Total_Revenue") DESC
LIMIT 5;
```
Of the top 5 highest countries in terms of Total Revnue, TAIWAN leading by 113M Follwed by GRENADA 107M. These 2 countries serve as primary commercial strongholds.

| Country | total_revenue |
| :--- | :--- |
| Taiwan | $ 113,106,946 |
| Grenada | $ 107,335,743 |
| Bahrain | $ 99,297,050 |
| Kiribati | $ 99,076,325 |
| Bangladesh | $ 97,386,350 |

### 6. Historical Growth Tracking
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
| sales_year | sales_month | current_year_sales | previous_year_sales | yoy_growth_percentage |
| :---: | :---: | :--- | :--- | :---: |
| **2017** | 7 | $ 170,797,235 | 169523562.82 | 0.75% |
| **2017** | 6 | $ 124,732,019 | 142697882.08 | -12.59% |
| **2017** | 5 | $ 165,377,278 | 130253934.66 | 26.97% |
| **2017** | 4 | $ 106,894,915 | 138237629.74 | -22.67% |
| **2017** | 3 | $ 140,984,549 | 172271071.51 | -18.16% |

### 7. Deep-Dive Seasonal Analysis
* **File:** `6_May_Profit 2017 vs 2016.sql`
* **Purpose:** Performs a localized comparative analysis isolating specific calendar periods (May 2016 vs. May 2017) to study short-term variance, seasonal spikes, or anomalies in customer purchasing behavior.

```sql
SELECT 

-- 2017 Profit
    TO_CHAR(SUM(CASE WHEN sales_year = 2017 THEN "Total_Profit" END),'$99,999,999,999,99') AS profit_may_2017,
    -- 2016 Profit
   TO_CHAR(SUM(CASE WHEN sales_year = 2016 THEN "Total_Profit" END),'$99,999,999,999,99') AS profit_may_2016,
    
    -- Net Difference
    To_CHAR(
        SUM(CASE WHEN sales_year = 2017 THEN "Total_Profit" END) - 
        SUM(CASE WHEN sales_year = 2016 THEN "Total_Profit" END),
    '$99,999,999,999,99' ) AS net_diefference,

    ROUND(
    (SUM(CASE WHEN sales_year = 2017 THEN "Total_Profit" END) / 
     SUM(CASE WHEN sales_year = 2017 THEN "Total_Revenue" END)) * 100,
    2
) AS profit_margin_2017,
    

  ROUND(
    (SUM(CASE WHEN sales_year = 2016 THEN "Total_Profit" END) / 
        SUM(CASE WHEN sales_year = 2016 THEN "Total_Revenue" END)) * 100,
    2
)  AS profit_margin_2016

FROM sales_table
WHERE sales_month = 5;


SELECT*
FROM sales_table;

```
*Total profit for the month of May grew by +$89,034.27 year-over-year, showing an impressive 21.5% increase in absolute baseline returns. This indicates a successful push in sales volume or market expansion during 2017*
| profit_may_2017 | profit_may_2016 | net_profit_growth | profit_margin_2017 | profit_margin_2016 |
| :--- | :--- | :--- | :--- | :--- |
| $503,359.56 |$ 414,325.30 | $ 89,034.27 | 30.44 | 31.81 |

**Conclusion:** *This pattern suggests that the 2017 growth was driven by high-volume sales of slightly lower-margin items, or potentially due to rising operational/unit costs. The business successfully traded a tiny bit of operational efficiency (margin) to capture a significantly larger pool of actual cash (total profit).*



### 8. Logistics & Supply Chain Efficiency
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
| Item_Type | avg_delivery_time | max_delivery_time |
| :--- | :---: | :---: |
| Vegetables | 23.93 | 50 |
| Household | 24.39 | 50 |
| Personal Care | 24.44 | 50 |
| Fruits | 24.66 | 50 |
| Office Supplies | 25.00 | 50 |
| Cosmetics | 25.27 | 50 |
| Beverages | 25.34 | 50 |
| Baby Food | 25.36 | 50 |
| Clothes | 25.38 | 50 |
| Meat | 25.41 | 50 |
| Cereal | 25.52 | 50 |
| Snacks | 26.08 | 50 |
---

## 💡 Key Technical Skills Demonstrated
* **Time-Series Analysis:** Querying dates, extracting years/months, and comparing historical performance periods.
* **Window Functions:** Employing statistical ranking and offset fields to build financial trend models without altering raw tables.
* **Aggregations & Filters:** Mastering structural clauses (`GROUP BY`, `HAVING`, mathematical operators) to compress 10,000 distinct data rows into clear executive summaries.

# Conclusion











</div>