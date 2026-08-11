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