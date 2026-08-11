# Retail Sales Performance Dashboard

Professionalized project layout with package code, preprocessing scripts, a Streamlit dashboard, tests, and CI.

## Layout

- `src/` — package source
- `scripts/` — data processing scripts
- `app/` — Streamlit app entrypoint
- `notebooks/` — analysis notebooks
- `data/` — (gitignored) raw and processed datasets
- `tests/` — pytest tests
- `docs/` — documentation and architecture

## Quickstart

1. Create a virtual env: `python -m venv .venv`
2. Activate it and install: `pip install -r requirements.txt`
3. Preprocess data: `python scripts/preprocess.py --input data/raw --output data/processed`
4. Run the app: `streamlit run app/dashboard.py`

## Contributing

See CONTRIBUTING.md for guidelines.

# Retail Sales Performance Dashboard

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE) [![Python](https://img.shields.io/badge/Python-3.8%2B-blue)](#)

Professional analytics toolkit and interactive dashboard for retail sales performance. The repository contains data ingestion scripts, EDA notebooks, preprocessing pipelines, and a lightweight dashboard to visualize KPIs and time-series trends.

## Overview

- Purpose: Turn historical retail transactions into actionable insights (sales, units, AOV, top products, store comparisons).
- Intended users: Data analysts, BI engineers, product managers.
- Status: Prototype — polishing and documentation in progress.

## Key Features

- Clean and documented preprocessing pipeline to standardize raw retail data
- Exploratory notebooks for trend analysis, seasonality, and product performance
- KPI calculations and exportable summary reports (CSV)
- Interactive dashboard (Streamlit or Jupyter widgets) for stakeholder review

## Technology Stack

- Language: Python 3.8+
- Notebooks: Jupyter / JupyterLab
- Dashboard: Streamlit (optional)
- Data: CSV files stored under `data/` (see Data section)

## Getting Started

1. Clone the repository and create a virtual environment:

```powershell
cd "D:\Python\Virtual\Projects\Data_Analytics\Retail_Sales_Performance_Dashboard"
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

2. Prepare data:

- Put source CSV files in `data/raw/`.
- Process them with the provided script (if present):

```powershell
python scripts/preprocess.py --input data/raw --output data/processed
```

If `scripts/preprocess.py` does not exist yet, open `notebooks/` for example preprocessing flows.

3. Run analysis or dashboard:

