# Retail Sales Performance Dashboard — Full Build Guide

## 1. Get the dataset
Kaggle: **Superstore / Retail Sales Dataset**
https://www.kaggle.com/datasets/mohammadtalib786/retail-sales-dataset

Download the CSV. It should have columns like: `Row ID, Order ID, Order Date, Ship Date,
Ship Mode, Customer ID, Customer Name, Segment, Country, City, State, Postal Code, Region,
Product ID, Category, Sub-Category, Product Name, Sales, Quantity, Discount, Profit`.

If your download has different column names, just rename them in the `CREATE TABLE`
statement in `retail_sales_queries.sql` — the rest of the queries will still work.

## 2. Load it into SQL
1. Install PostgreSQL (or use SQL Server / MySQL — whatever you're more comfortable
   putting on your resume).
2. Run the `CREATE TABLE sales_data (...)` statement from `retail_sales_queries.sql`.
3. Import the CSV (pgAdmin's Import/Export tool, or `COPY sales_data FROM '...' CSV HEADER;`).
4. Run the data-quality checks (Step 2 in the SQL file) to confirm no nulls/duplicates.
5. Run through Step 3's queries in a SQL client — these are your "insights," and you
   should keep 3-4 of the resulting numbers to quote directly on your resume/portfolio
   (e.g. "identified that the Furniture > Tables sub-category lost money despite a 25%+
   average discount").

## 3. Bring it into Power BI
1. **Get Data → SQL Server / PostgreSQL database** and connect directly to your
   `vw_sales_summary` view (this is more impressive than importing a CSV — it shows you
   can connect BI tools to a live database).
   - If you'd rather keep it simple, `Get Data → Text/CSV` on the raw file works too.
2. **Build a Date table** (Modeling → New Table):
   ```
   DateTable = CALENDAR(MIN(sales_data[order_date]), MAX(sales_data[order_date]))
   Year = YEAR(DateTable[Date])
   Month = FORMAT(DateTable[Date], "MMM")
   MonthNum = MONTH(DateTable[Date])
   Quarter = "Q" & QUARTER(DateTable[Date])
   ```
   Mark it as a **Date Table** and relate it to `order_date` (one-to-many).
3. **Data model**: keep it a single fact table (`sales_data`) with the Date table related
   to it. If you want to demonstrate star-schema modeling skills, split out `dim_products`
   (Product ID, Product Name, Category, Sub-Category) and `dim_stores`/`dim_region`
   (Region, State, City) as separate tables using Power Query, then relate them back —
   this is worth doing since "consolidating from multiple source systems" in your resume
   bullet implies more than one flat table.

## 4. DAX measures to create
```DAX
Total Revenue = SUM(sales_data[sales])

Total Profit = SUM(sales_data[profit])

Profit Margin % = DIVIDE([Total Profit], [Total Revenue], 0)

Total Orders = DISTINCTCOUNT(sales_data[order_id])

Avg Order Value = DIVIDE([Total Revenue], [Total Orders], 0)

Prior Year Revenue = CALCULATE([Total Revenue], SAMEPERIODLASTYEAR(DateTable[Date]))

YoY Growth % = DIVIDE([Total Revenue] - [Prior Year Revenue], [Prior Year Revenue], 0)

Revenue Rank by Region =
RANKX(ALL(sales_data[region]), [Total Revenue], , DESC)

Underperforming Flag =
IF([Profit Margin %] < 0, "Underperforming", "Healthy")

MTD Revenue = TOTALMTD([Total Revenue], DateTable[Date])

Top Product Revenue =
CALCULATE([Total Revenue], TOPN(1, ALL(sales_data[product_name]), [Total Revenue]))
```

## 5. Pages / visuals to build (this maps directly to your resume bullets)
**Page 1 — Executive Overview**
- KPI cards: Total Revenue, Total Profit, Profit Margin %, YoY Growth %
- Line chart: Monthly revenue trend (with prior-year comparison line)
- Map or filled map: Revenue by Region/State
- Slicers: Year, Region, Category

**Page 2 — Regional / Store Performance**
- Bar chart: Revenue & profit by region, sorted descending
- Table with conditional formatting (red/green) on `Profit Margin %` to flag
  underperforming stores/states
- Scatter plot: Discount % vs. Profit, to visually surface money-losing categories

**Page 3 — Product Performance**
- Treemap or bar chart: Revenue by Category > Sub-Category
- Top 10 / Bottom 10 products table
- Card: best and worst performing sub-category by margin

**Page 4 — Seasonal Trends**
- Column chart: Revenue by month (all years overlaid) to show seasonality
- Decomposition tree or drill-through from Page 1 into any month

Add a **drill-through page** from any region/store to product-level detail — this is a
detail worth mentioning in interviews since it shows UX thinking, not just charts.

## 6. Turn it into resume bullets (fill in your real numbers once built)
- Designed and built an interactive Power BI dashboard tracking retail sales performance
  across **[X] regions and Y states**, consolidating data from a SQL database built from
  raw POS-style transaction data.
- Wrote SQL queries (aggregations, window functions, views) to extract and transform
  sales data, enabling analysis of revenue trends, top/bottom-performing products, and
  regional profitability.
- Identified that **[specific finding, e.g., the Tables sub-category lost $X despite
  averaging a 25%+ discount]**, and flagged **[N] underperforming states** with negative
  profit margins — insights that map directly to inventory/pricing decisions.
- Tech stack: Power BI, SQL (PostgreSQL), DAX, Power Query, Excel.

## 7. Publishing / sharing it
- Power BI Desktop → **Publish** to Power BI Service (free account) so you have a live
  link to share.
- Push the `.sql` file and a short README to a public GitHub repo — recruiters checking
  your resume bullet will often click through to see actual code.
- Export 2-3 dashboard screenshots for your portfolio/LinkedIn.
