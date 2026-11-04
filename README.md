# International Debt Analysis System

Analysis of the World Bank International Debt Statistics (IDS) data using Python, MySQL and Power BI.

## What this project does
1. Cleans the raw World Bank CSV with Python (pandas) and runs EDA with 6 charts.
2. Stores the data in MySQL (3 tables with primary and foreign keys).
3. Answers 30 business questions with SQL.
4. Shows the results in a Power BI dashboard.

## Tools
Python, pandas, Matplotlib, Google Colab, MySQL, mysql-connector-python, Power BI Desktop

## Folder contents
| File | Purpose |
|---|---|
| debt_analysis_clean.ipynb | Cleaning, EDA and charts |
| cleaned_debt_data_v2.csv | Cleaned data (51,620 rows, 31 columns) |
| load_to_mysql.py | Loads the countries table (120 rows) |
| load_indicators.py | Loads the indicators table (576 rows) |
| load_debt_data.py | Loads the debt_data table (1,060,074 rows) |
| queries.sql | 30 SQL queries (Q1 to Q30) |
| debt_dashboard.pbix | Power BI dashboard |
| debt_dashboard.pdf | Dashboard export |
| charts/ | 6 EDA chart images |

## Database design
- countries(country_code PK, country_name)
- indicators(series_code PK, series_name)
- debt_data(debt_id PK, country_code FK, series_code FK, data_year, debt_value)
- Index: idx_series_year on (series_code, data_year)

## How to run
1. Create a MySQL database named `debt_analysis` and the three tables.
2. In each load script, replace `YOUR_PASSWORD` with your own MySQL password.
3. Run `load_to_mysql.py`, then `load_indicators.py`, then `load_debt_data.py` (once each).
4. Run the queries in `queries.sql`.
5. Open `debt_dashboard.pbix` in Power BI Desktop and click Refresh.

## Key results
- Total external debt in 2024: about 8.94 trillion US$
- Largest debtors: China (about 27% of the total), India (about 8%), Brazil, Mexico, Turkiye
- Debt categories (my own limits): 18 High, 51 Medium, 51 Low countries

## Notes
- Only series DT.DOD.DECT.CD (total external debt, US$) is used for rankings, because other indicators overlap with it.
- Blank values mean "not reported", so they were not filled with zero.
- High / Medium / Low limits (100B and 10B US$) are my own choice.

## Author
Sruthika
