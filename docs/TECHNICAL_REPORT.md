# Technical Report: Retail Sales Performance Dashboard

**Author:** [Your Name]
**Date:** [Date]
**Repository:** [link to your GitHub repo]

---

## 1. Objective

Build an end-to-end analytics project that ingests raw retail transaction data, models
and analyzes it in SQL, and delivers an interactive Power BI dashboard surfacing
revenue trends, regional/store performance, product profitability, and seasonality —
insights that map to real pricing, inventory, and store-performance decisions.

## 2. Data Source

- **Dataset:** Superstore Sales Dataset, Kaggle
  (https://www.kaggle.com/datasets/mohammadtalib786/retail-sales-dataset)
- **Grain:** one row per line item within an order (order-line level, not order level)
- **Volume:** [~N,000] rows, [Y] years of transaction history ([start date]–[end date])
- **Key fields:** Order ID, Order Date, Ship Date, Region, State, City, Segment,
  Category, Sub-Category, Product Name, Sales, Quantity, Discount, Profit

This dataset was chosen because it mimics a realistic POS/sales-database export —
multiple regions and stores, product hierarchy, and margin data (Sales *and* Profit,
not just revenue) — which makes it suitable for the kind of profitability and
underperformance analysis a retail stakeholder would actually ask for.

## 3. Methodology

### 3.1 Schema design and data quality
The raw CSV was loaded into a PostgreSQL table (`sales_data`) with explicit typing
(`DECIMAL` for currency fields, `DATE` for order/ship dates) rather than importing as
all-text, so downstream aggregation didn't require repeated casting. Before analysis,
three checks were run:
- **Null checks** on the fields the entire analysis depends on (`order_date`, `sales`,
  `region`) — see `retail_sales_queries.sql`, Step 2
- **Duplicate row check** on `row_id` to confirm one-row-per-line-item integrity
- **Date range sanity check** to confirm the import captured the full expected period

### 3.2 SQL analysis layer
Rather than doing all aggregation inside Power BI, core business questions were
answered directly in SQL first — this served two purposes: it validated the numbers
independently of any DAX logic (so a modeling bug wouldn't silently produce wrong
"insights"), and it let the same aggregation logic run rank/window functions
(`LAG`, `RANK`) that are more natural in SQL than DAX.

Queries built (full text in `retail_sales_queries.sql`):
| Query | Purpose |
|---|---|
| Overall KPIs | Revenue, profit, margin %, order count, AOV baseline |
| Monthly revenue trend | Feeds the Page 1 line chart; also independently validates the DAX time-intelligence measures |
| YoY growth (`LAG` window function) | Cross-checked against the DAX `SAMEPERIODLASTYEAR` measure |
| Regional performance | Revenue/profit/margin grouped by region |
| Top/bottom 10 states | Surfaces both star and underperforming locations |
| Top products | Revenue and units sold, by product |
| Category/sub-category performance | Feeds the treemap and category drill-down |
| Seasonal (monthly, all years combined) | Detects month-over-month seasonality independent of year-over-year noise |
| Discount vs. profit (sub-category level) | Surfaces sub-categories that are unprofitable *because* of discounting |

A view, `vw_sales_summary`, was created on top of the raw table to expose only the
cleaned/derived fields Power BI needed (including a computed `profit_margin_pct` and
`days_to_ship`), rather than pointing Power BI directly at the raw table. This keeps
transformation logic in SQL where it's version-controlled and testable, instead of
buried in Power Query steps.

### 3.3 Data modeling in Power BI
- Data was imported (not DirectQuery) for portfolio/demo purposes.
- A dedicated `DateTable` was created via `CALENDAR()` and marked as an official Date
  Table, related to `sales_data[order_date]` on a one-to-many, single-direction
  relationship. This was necessary for time-intelligence DAX functions
  (`SAMEPERIODLASTYEAR`, `TOTALMTD`) to behave correctly.
- [If you split out dimension tables: describe the star schema here — e.g. "Product
  and Region attributes were split into `dim_product` and `dim_region` tables via
  Power Query to move from a single flat table toward a star schema, reducing column
  redundancy and making relationships explicit."]

### 3.4 DAX measures
Measures were written rather than relying on implicit aggregation so that percentage
and ratio calculations (margin, growth) correctly recalculate under any filter context
(region slicer, date slicer, etc.), which a static SQL aggregation cannot do inside an
interactive report. Key measures:

```DAX
Profit Margin % = DIVIDE([Total Profit], [Total Revenue], 0)
YoY Growth % = DIVIDE([Total Revenue] - [Prior Year Revenue], [Prior Year Revenue], 0)
```

`DIVIDE()` was used instead of the `/` operator throughout to avoid divide-by-zero
errors when a filtered context (e.g. a region with zero orders in a given month)
returns a blank denominator.

Full measure list is in `PROJECT_GUIDE.md`.

### 3.5 Dashboard design decisions
- **Four pages**, each scoped to a single question a stakeholder would ask (overview →
  where → what → when), rather than one dense page, to keep each visual legible and
  support drill-through navigation.
- **Conditional formatting** on the store/state table (red/green by profit margin) was
  used instead of a separate "underperforming stores" chart, so a stakeholder can see
  both the ranking and the flag in one visual.
- **Drill-through** from month/region on Page 1 into product detail on Page 3 was added
  so a viewer can go from "revenue dipped in March" to "which products drove that" in
  two clicks, rather than requiring a separate ad hoc query.
- Slicers (Year, Region, Category) are synced across all pages so filtering is
  consistent regardless of which page a viewer starts on.

## 4. Key Findings

*(Replace with your actual numbers once queries are run against the real data)*

| Finding | Metric |
|---|---|
| Total revenue analyzed | $[X] |
| Blended profit margin | [X]% |
| Top-performing region | [Region] — $[X] revenue |
| Underperforming states (negative margin) | [N] states, e.g. [State names] |
| Least profitable sub-category | [Sub-Category] — [X]% avg discount, $[X] net loss |
| Seasonality | Revenue peaks in [month(s)], consistent across [Y] years |

## 5. Validation

Each DAX measure's output was spot-checked against the equivalent SQL query for at
least one filter slice (e.g. a single region/year) to catch relationship or filter
context errors before treating the dashboard numbers as reliable. [Describe specifics
here once you do this — e.g. "Total Revenue for the West region in 2016 matched between
the SQL GROUP BY query ($X) and the Power BI card visual filtered to the same slice."]

## 6. Limitations and future work

- The dataset is a single historical export with no live refresh; a production version
  would connect to an actual POS system via scheduled refresh or DirectQuery.
- No customer-level lifetime value or cohort analysis is included — a natural next
  layer given the dataset has `Customer ID`.
- Forecasting (e.g. a simple linear or seasonal-naive revenue forecast) was out of
  scope but would be a reasonable extension using Power BI's built-in forecasting or a
  Python/R visual.

## 7. Repository structure

```
├── retail_sales_queries.sql   # schema, data-quality checks, all SQL analysis
├── Retail_Sales_Dashboard.pbix
├── README.md
├── TECHNICAL_REPORT.md        # this file
└── screenshots/
```
