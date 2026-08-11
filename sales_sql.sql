/* =========================================================================
   RETAIL SALES PERFORMANCE DASHBOARD - SQL SCRIPTS
   Dataset: Kaggle "Superstore" / "Retail Sales" dataset
   Works in: PostgreSQL / SQL Server / MySQL (minor syntax tweaks noted)
   ========================================================================= */
 
 
/* -------------------------------------------------------------------------
   STEP 1: CREATE THE TABLE
   Match this to whatever columns your downloaded CSV actually has -
   rename/add/remove columns as needed. This matches the classic
   Superstore schema.
   ------------------------------------------------------------------------- */
 
CREATE TABLE sales_data (
    row_id          INT PRIMARY KEY,
    order_id        VARCHAR(20),
    order_date      DATE,
    ship_date       DATE,
    ship_mode       VARCHAR(30),
    customer_id     VARCHAR(20),
    customer_name   VARCHAR(100),
    segment         VARCHAR(30),
    country         VARCHAR(50),
    city            VARCHAR(50),
    state           VARCHAR(50),
    postal_code     VARCHAR(10),
    region          VARCHAR(20),
    product_id      VARCHAR(20),
    category        VARCHAR(30),
    sub_category    VARCHAR(30),
    product_name    VARCHAR(200),
    sales           DECIMAL(12,2),
    quantity        INT,
    discount        DECIMAL(4,2),
    profit          DECIMAL(12,2)
);
 
-- If using PostgreSQL, import with:
-- COPY sales_data FROM '/path/to/superstore.csv' DELIMITER ',' CSV HEADER;
 
-- If using SQL Server, use the Import Flat File wizard or BULK INSERT.
-- If using MySQL Workbench, use Table Data Import Wizard.
DESCRIBE sales_data;
SELECT * FROM cleaned_sale;

INSERT INTO sales_data
SELECT * FROM cleaned_sale;

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


/* -------------------------------------------------------------------------
   STEP 3: CORE AGGREGATION QUERIES
   These mirror what you'd build as Power BI measures/visuals, and also
   double as proof in your portfolio that you can do the analysis in raw SQL.
   ------------------------------------------------------------------------- */
-- 3a. Overall KPIs
SELECT
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM sales_data;

-- 3b. Monthly revenue trend (for a line chart)
SELECT
    DATE_FORMAT(order_date, '%Y-%m-01') AS sales_month,
    SUM(sales) AS monthly_revenue,
    SUM(profit) AS monthly_profit
FROM sales_data
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
ORDER BY sales_month;
-- SQL Server equivalent: FORMAT(order_date, 'yyyy-MM')
-- MySQL equivalent: DATE_FORMAT(order_date, '%Y-%m-01')

-- 3c. Year-over-year revenue growth
WITH yearly AS (
    SELECT EXTRACT(YEAR FROM order_date) AS yr, SUM(sales) AS revenue
    FROM sales_data
    GROUP BY EXTRACT(YEAR FROM order_date)
)
SELECT
    yr,
    revenue,
    LAG(revenue) OVER (ORDER BY yr) AS prev_year_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY yr))
        / NULLIF(LAG(revenue) OVER (ORDER BY yr), 0) * 100, 2
    ) AS yoy_growth_pct
FROM yearly
ORDER BY yr;

-- 3d. Regional performance (revenue, profit, and margin by region)
SELECT
    region,
    SUM(sales)  AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100, 2) AS margin_pct,
    COUNT(DISTINCT order_id) AS orders
FROM sales_data
GROUP BY region
ORDER BY revenue DESC;

-- 3e. Top 10 performing states/stores by revenue
SELECT
    state,
    SUM(sales)  AS revenue,
    SUM(profit) AS profit
FROM sales_data
GROUP BY state
ORDER BY revenue DESC
LIMIT 10;

-- 3f. Bottom 10 underperforming states/stores (lowest profit, incl. losses)
SELECT
    state,
    SUM(sales)  AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100, 2) AS margin_pct
FROM sales_data
GROUP BY state
ORDER BY profit ASC
LIMIT 10;

-- 3g. Top-performing products (by revenue and by profit)
SELECT
    product_name,
    category,
    sub_category,
    SUM(sales)    AS revenue,
    SUM(quantity) AS units_sold,
    SUM(profit)   AS profit
FROM sales_data
GROUP BY product_name, category, sub_category
ORDER BY revenue DESC
LIMIT 15;
 
-- 3h. Category / sub-category performance
SELECT
    category,
    sub_category,
    SUM(sales)  AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100, 2) AS margin_pct
FROM sales_data
GROUP BY category, sub_category
ORDER BY revenue DESC;
 
-- 3i. Seasonal trend - average revenue by month (across all years)
SELECT
    MONTH(order_date) AS month_num,
    MONTHNAME(order_date) AS month_name,
    SUM(sales) AS revenue,
    COUNT(DISTINCT order_id) AS orders
FROM sales_data
GROUP BY
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY month_num;
 
-- 3j. Products/categories being discounted heavily but still losing money
-- (a classic "insight" finding for this kind of dataset)
SELECT
    sub_category,
    ROUND(AVG(discount), 2) AS avg_discount,
    SUM(sales)  AS revenue,
    SUM(profit) AS profit
FROM sales_data
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY avg_discount DESC;
 
-- 3k. Customer segment performance
SELECT
    segment,
    SUM(sales)  AS revenue,
    SUM(profit) AS profit,
    COUNT(DISTINCT customer_id) AS customers
FROM sales_data
GROUP BY segment
ORDER BY revenue DESC;



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


-- SELECT @@hostname AS server_name; 