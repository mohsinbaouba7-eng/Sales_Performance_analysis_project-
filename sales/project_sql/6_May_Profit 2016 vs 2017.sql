

WITH MayComparison AS (
    SELECT 
        "Item_Type",
        -- May 2016 Total Profit
        SUM(CASE WHEN sales_year = 2016 AND sales_month = 5 THEN "Total_Profit" ELSE 0 END) AS profit_may_2016,
        -- May 2017 Total Profit
        SUM(CASE WHEN sales_year = 2017 AND sales_month = 5 THEN "Total_Profit" ELSE 0 END) AS profit_may_2017
    FROM sales_table
    GROUP BY "Item_Type"
)
SELECT 
    "Item_Type",
    TO_CHAR(profit_may_2016, '$999,999,999') AS total_profit_2016,
    TO_CHAR(profit_may_2017, '$999,999,999') AS total_profit_2017,
    -- Calculate the net increase in profit dollars
    TO_CHAR(profit_may_2017 - profit_may_2016, '$999,999,999') AS net_profit_change,
    -- Calculate percentage growth for that specific item
    ROUND(
        (NULLIF(profit_may_2017, 0) - profit_may_2016) / NULLIF(profit_may_2016, 0) * 100, 
        2
    ) || '%' AS item_growth_percentage
FROM MayComparison
WHERE profit_may_2016 > 0 OR profit_may_2017 > 0
ORDER BY (profit_may_2017 - profit_may_2016) DESC;


SELECT *
    FROM 
        sales_table;
        
