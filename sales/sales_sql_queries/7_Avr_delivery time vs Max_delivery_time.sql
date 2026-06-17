SELECT
   "Item_Type",
   ROUND(AVG(delivery_time), 2) AS Avg_delivery_time,
   MAX(delivery_time) AS MaX_delivery_time
    FROM sales_table
    GROUP BY "Item_Type"
    ORDER BY Avg_delivery_time ASC,
    MaX_delivery_time ;


SELECT *
FROM sales_table