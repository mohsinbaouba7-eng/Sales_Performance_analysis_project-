/* 
    IV- YEAR - TO - YEAR GROWTH :
 IS THE COMPANY GROWING OVER ITS PROFIT OVER OVER YEARS, OR DROPPING ?
    1- CREATE 2 NEW COLUMNS "Sales_year , Sales_month"
    2- EXTRACT MONTH/YEAR/
    3- Calculate YoY GROWTH

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
