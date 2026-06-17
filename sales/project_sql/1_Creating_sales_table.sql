
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










    -- 
