
-- II - MOST PROFITABLE ITEM_TYPES

SELECT
    sales_table."Item_Type",
TO_CHAR(SUM(sales_table."Units_Sold"), 'FM99G999G999') As total_unit_sold,
TO_CHAR(SUM(sales_table."Total_Profit"),'$99,999,999,999,99') AS Total_Profit

FROM  sales_table
GROUP BY
    sales_table."Item_Type"
ORDER BY Total_Profit DESC;