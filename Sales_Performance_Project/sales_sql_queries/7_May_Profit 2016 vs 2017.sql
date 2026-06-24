SELECT 

-- 2017 Profit
    TO_CHAR(SUM(CASE WHEN sales_year = 2017 THEN "Total_Profit" END),'$99,999,999,999,99') AS profit_may_2017,
    -- 2016 Profit
   TO_CHAR(SUM(CASE WHEN sales_year = 2016 THEN "Total_Profit" END),'$99,999,999,999,99') AS profit_may_2016,
    
    -- Net Difference
    To_CHAR(
        SUM(CASE WHEN sales_year = 2017 THEN "Total_Profit" END) - 
        SUM(CASE WHEN sales_year = 2016 THEN "Total_Profit" END),
    '$99,999,999,999,99' ) AS net_profit_growth,

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



