
-- 1- CREATING sales_table 

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

/*SINCE THE DATA IS COMPLETLY CLEAN AND STANDARDIZED 
WE CAN NOW EXCTRACT SOME INSIGHTS 
*/
-- I - TOTAL FINANCIAL HEALTH TO SEE HOW LUCRATIVE THE BUSINESS IS GLOBALLY 

SELECT 
    SUM("Total_Revenue") AS GLOBAL_REVENUE,
    SUM("Total_Cost") AS GLOBAL_COST,
    SUM("Total_Profit") AS GLOBAL_PROFIT,
    ROUND((SUM("Total_Profit") / SUM("Total_Revenue")) * 100, 2) AS PROFIT_MARGIN

FROM 
sales_table;

/* II- AFRER RUNNED THE PREVIOUS QUERY YOY CAN NOTICE THAT 
THE NUMBERS APPEARING AS A RESULT ARE NOT PROPERLY READ
SO WE ARE GOING TO IMPROVE A BIT READABILITY BY ADDING
1- DOLLARS SIGN
2- COMMAS 
USE TO_CHAR (SUM(" COLUMN "), '$99,999,999,999,99'AS ..... FR
FORMATING
*/

SELECT 
    TO_CHAR(SUM("Total_Revenue"), '$99,999,999,999,99') AS GLOBAL_REVENUE,
    TO_CHAR(SUM("Total_Cost"), '$99,999,999,999,99') AS GLOBAL_COST,
    TO_CHAR(SUM("Total_Profit"), '$99,999,999,999,99') AS GLOBAL_PROFIT,
    ROUND((SUM("Total_Profit") / SUM("Total_Revenue")) * 100, 2) AS PROFIT_MARGIN

FROM 
sales_table;

-- III - MOST PROFITABLE ITEM_TYPES

SELECT
    sales_table."Item_Type",
TO_CHAR(SUM(sales_table."Units_Sold"), 'FM99G999G999') As total_unit_sold,
TO_CHAR(SUM(sales_table."Total_Profit"),'$99,999,999,999,99') AS Total_Profit

FROM  sales_table
GROUP BY
    sales_table."Item_Type"
ORDER BY Total_Profit DESC;

/* IV -  CHECKING PERFORMANCE BY REGION TO SEE WHERE OUR
TARGET MARKETS ARE 
*/

SELECT 
    sales_table."Region",
    TO_CHAR(SUM("Total_Profit"), '$99,999,999,999,99') AS Total_Profit,
    ROUND((SUM("Total_Profit") / SUM("Total_Revenue")) * 100, 2) AS PROFIT_MARGIN
FROM sales_table
GROUP BY sales_table."Region"
ORDER BY PROFIT_MARGIN DESC;
        