
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

### 2. General Business Health
* **File:** `2_Total_financial_health_of_the_business.sql`
* **Purpose:** Calculates high-level executive KPIs including **Total Revenue**, **Total Cost**, and **Total Net Profit** across the entire lifetime of the dataset to evaluate global business performance.

### 3. Product & Inventory Optimization
* **File:** `3_Most_Profitable_Item_Type.sql`
* **Purpose:** Aggregates total profit grouped by item types (e.g., Cosmetics, Clothes, Office Supplies) to pinpoint which product categories drive the highest profit margins and should receive more marketing focus.

### 4. Geographic & Regional Trends
* **File:** `4_Performance_by_Region.sql`
* **Purpose:** Breaks down sales volume and total margins by global regions (such as Sub-Saharan Africa, Europe, Asia). This identifies our strongest geographic strongholds and maps out underperforming regional markets.

### 5. Historical Growth Tracking
* **File:** `5_YoY_Growth.sql`
* **Purpose:** Utilizes advanced window functions (`LAG()`, `LEAD()`) to calculate **Year-over-Year (YoY) Growth Rates**. This determines whether the company's financial trajectories are accelerating or slowing down over time.

### 6. Deep-Dive Seasonal Analysis
* **File:** `6_May_Profit 2016 vs 2017.sql`
* **Purpose:** Performs a localized comparative analysis isolating specific calendar periods (May 2016 vs. May 2017) to study short-term variance, seasonal spikes, or anomalies in customer purchasing behavior.

### 7. Logistics & Supply Chain Efficiency
* **File:** `7_Avr_delivery time vs Max_delivery_time.sql`
* **Purpose:** Shifts focus to operations by computing metrics based on order dates and ship dates. It compares average delivery times against maximum delays to flag supply chain bottlenecks.

---

## 💡 Key Technical Skills Demonstrated
* **Time-Series Analysis:** Querying dates, extracting years/months, and comparing historical performance periods.
* **Window Functions:** Employing statistical ranking and offset fields to build financial trend models without altering raw tables.
* **Aggregations & Filters:** Mastering structural clauses (`GROUP BY`, `HAVING`, mathematical operators) to compress 10,000 distinct data rows into clear executive summaries.

# Conclusion