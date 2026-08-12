
/* -------------------------------------------------------------------------
   STEP 4: VIEW FOR POWER BI IMPORT
   Instead of importing the raw table, build a clean view with the fields
   Power BI actually needs - this shows intentional ETL/data-modeling skill.
   ------------------------------------------------------------------------- */
 
CREATE VIEW vw_sales_summary AS
SELECT
    order_id,
    order_date,
    ship_date,
    DATEDIFF(day, order_date, ship_date) AS days_to_ship, -- SQL Server syntax
    -- PostgreSQL equivalent: (ship_date - order_date) AS days_to_ship
    region,
    state,
    city,
    segment,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit,
    ROUND(profit / NULLIF(sales,0) * 100, 2) AS profit_margin_pct
FROM sales_data;