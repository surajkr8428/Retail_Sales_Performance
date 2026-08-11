/* -------------------------------------------------------------------------
   STEP 2: DATA QUALITY / CLEANING CHECKS
   ------------------------------------------------------------------------- */
-- Check for nulls in key fields
SELECT
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END)      AS null_sales,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END)     AS null_region
FROM sales_data;

-- Check for duplicate orders/rows
SELECT row_id, COUNT(*)
FROM sales_data
GROUP BY row_id
HAVING COUNT(*) > 1;

-- Sanity check on date range
SELECT MIN(order_date) AS first_order, MAX(order_date) AS last_order
FROM sales_data;


