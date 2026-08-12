# Retail Sales Performance Dashboard

Interactive Power BI dashboard and SQL analysis pipeline for retail sales performance —
turning raw transaction data into revenue, regional, and product-level insights.

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue)](#)

## Overview

- **Purpose:** turn historical retail transactions into actionable insights — revenue
  trends, regional/store performance, product profitability, and seasonality.
- **Intended users:** data analysts, BI engineers, hiring managers reviewing this as a
  portfolio project.
- **Status:** [Complete]

## What's in this project

| Layer | Tool | What it does |
|---|---|---|
| Data cleaning | Python (pandas, Jupyter) | Standardizes raw Superstore export into an analysis-ready table |
| Analysis | SQL (PostgreSQL) | Schema, data-quality checks, aggregation queries (revenue, regional, product, seasonal) |
| Visualization | Power BI + DAX | Interactive 4-page dashboard with drill-through and time-intelligence measures |
| App (optional) | Streamlit | Lightweight web view of the same KPIs, for a browser-based demo without Power BI installed |

## Repository structure

```
├── data/
│   ├── raw/                  # original Superstore.csv (gitignored if large)
│   └── processed/            # cleaned_data.csv — the single source of truth after cleaning
├── notebooks/
│   └── Data_Cleaning.ipynb   # cleaning/EDA walkthrough
├── sql/
│   ├── 01_schema.sql         # table creation
│   ├── 02_data_quality.sql   # null/duplicate/date-range checks
│   ├── 03_analysis.sql       # revenue, regional, product, seasonal queries
│   └── 04_views.sql          # vw_sales_summary for Power BI import
├── scripts/
│   ├── kaggleHub.py          # pulls the dataset from Kaggle
│   └── preprocess.py         # CLI wrapper around the cleaning notebook logic
├── src/retail_dashboard/     # shared Python package code (used by app/ and scripts/)
├── app/
│   └── dashboard.py          # Streamlit entrypoint
├── Retail_Store.pbix         # Power BI dashboard file
├── tests/                    # pytest tests for scripts/src
├── docs/
│   ├── PROJECT_GUIDE.md      # build guide: SQL → Power BI → DAX step by step
│   └── TECHNICAL_REPORT.md   # methodology write-up
├── .github/workflows/        # CI (lint/test on push)
├── requirements.txt
├── pyproject.toml
└── README.md
```

## Dataset

[Superstore Sales Dataset](https://www.kaggle.com/datasets/mohammadtalib786/retail-sales-dataset), Kaggle —
order-line-level retail transactions across multiple US regions/states, with revenue,
quantity, discount, and profit fields.

## Quickstart

**macOS / Linux:**
```bash
git clone https://github.com/surajkr8428/Retail_Sales_Performance.git
cd Retail_Sales_Performance
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

**Windows (PowerShell):**
```powershell
git clone https://github.com/surajkr8428/Retail_Sales_Performance.git
cd Retail_Sales_Performance
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```
> If script execution is disabled, run PowerShell as admin once:
> `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`

Then, on either OS:

2. Get the data:
   ```
   python scripts/kaggleHub.py          # downloads Superstore.csv into data/raw/
   python scripts/preprocess.py --input data/raw --output data/processed
   ```
3. Run the SQL layer: load `sql/01_schema.sql` into PostgreSQL, then run
   `sql/02_data_quality.sql` through `sql/04_views.sql` in order.
4. Open `Retail_Store.pbix` in Power BI Desktop and refresh the data source, **or** run
   the lightweight web version:
   ```
   streamlit run app/dashboard.py
   ```

### Repo reorg script
Two versions of the folder-reorg helper are included for whichever shell you use:
`reorg_repo.sh` (Git Bash / WSL / macOS / Linux) or `reorg_repo.ps1` (native
PowerShell). Both do the same `git mv` operations — pick one, don't run both.

## Key findings

*(fill in with your real numbers)*
- Total revenue analyzed: $[X], blended profit margin [X]%
- Top-performing region: [Region] — $[X]
- [N] states flagged as underperforming (negative profit margin)
- [Sub-Category] identified as unprofitable despite [X]%+ average discount

## Documentation

- [`docs/PROJECT_GUIDE.md`](docs/PROJECT_GUIDE.md) — step-by-step build guide
- [`docs/TECHNICAL_REPORT.md`](docs/TECHNICAL_REPORT.md) — methodology and design decisions

## Testing / CI

Tests live in `tests/` and run via `pytest`. GitHub Actions (`.github/workflows/`) runs
lint + tests on every push.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see [LICENSE](LICENSE).
