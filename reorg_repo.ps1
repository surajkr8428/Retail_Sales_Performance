# ============================================================================
# Repo reorg script for Retail_Sales_Performance (PowerShell / Windows)
# Run from the repo root:
#   cd "D:\Python\Virtual\Projects\Data_Analytics\Retail_Sales_Performance_Dashboard"
#   .\reorg_repo.ps1
#
# Review each move before running — some filenames are guessed based on
# what's visible in the GitHub file listing; adjust paths if names differ.
# Requires Git installed and this folder to be a git repo (git init already done).
# ============================================================================

$ErrorActionPreference = "Stop"  # stop on first error so you can fix and re-run safely

Write-Host "Creating target folders..."
New-Item -ItemType Directory -Force -Path data\raw, data\processed, notebooks, sql, scripts, docs | Out-Null

# ---- Data files -----------------------------------------------------------
# Keep ONE raw file and ONE processed/cleaned file. Pick whichever of the
# cleaned_* files is actually your final version and rename it.
Write-Host "Moving data files..."
git mv Superstore.csv data\raw\Superstore.csv

# >>> Decide which cleaned file is the real one, then uncomment ONE line:
# git mv cleaned_data.csv data\processed\cleaned_data.csv

git mv cleaned_sale.csv data\processed\cleaned_data.csv

# git mv cleaned_data1.xlsx data\processed\cleaned_data.xlsx

# >>> Then DELETE the redundant duplicates (do this manually after picking
#     the winner above — don't blind-delete before you've checked which
#     one is actually current):
# git rm sales_data.csv cleaned_data.csv cleaned_data.xlsx cleaned_data1.xlsx cleaned_sale.csv

# ---- Notebook ---------------------------------------------------------
Write-Host "Moving notebook..."
git mv Data_Cleaning.ipynb notebooks\Data_Cleaning.ipynb

# ---- SQL ---------------------------------------------------------------
# Rename step_1..step_4 and the other loose SQL files into an ordered,
# self-explanatory set. Adjust the mapping below to match what's actually
# in each file (open them first to confirm content matches the new name).
Write-Host "Moving + renaming SQL files..."
git mv step_1.sql sql\01_schema.sql
git mv step_2.sql sql\02_data_quality.sql
git mv step_3.sql sql\03_analysis.sql
git mv step_4.sql sql\04_views.sql

# retail_sales_queries.sql and sales_sql.sql look like earlier/duplicate
# drafts of the same work now split into sql\01-04. Compare their contents
# against the new files; if they're superseded, remove them:
# git rm retail_sales_queries.sql sales_sql.sql
# If either has a query NOT covered in 01-04, merge that query into
# sql\03_analysis.sql before deleting.

# ---- Scripts -------------------------------------------------------------
Write-Host "Moving scripts..."
git mv kaggleHub.py scripts\kaggleHub.py

# ---- Docs ------------------------------------------------------------
Write-Host "Moving docs..."
git mv PROJECT_GUIDE.md docs\PROJECT_GUIDE.md
# TECHNICAL_REPORT.md - add this file to docs\ if not already present

Write-Host ""
Write-Host "Done with the mechanical moves. Remaining manual steps:"
Write-Host "1. Open README.md and replace it with README_CLEAN.md content"
Write-Host "   (fixes the duplicated/conflicting sections)."
Write-Host "2. Confirm which cleaned_* file is authoritative, uncomment its"
Write-Host "   git mv line above, then delete the rest (git rm ...)."
Write-Host "3. Diff retail_sales_queries.sql / sales_sql.sql against the new"
Write-Host "   sql\01-04 files; delete once confirmed redundant."
Write-Host "4. Add a one-line repo description + topics on GitHub"
Write-Host "   (power-bi, sql, data-analytics, dax, python)."
Write-Host "5. Commit: git add -A; git commit -m 'Reorganize repo structure'"
