-- Q1: Retrieve all distinct country names
SELECT DISTINCT country_name FROM countries;

-- Q2: Count the total number of countries
SELECT COUNT(*) AS total_countries FROM countries;

-- Q3: Find the total number of indicators
SELECT COUNT(*) AS total_indicators FROM indicators;

-- Q4: Display the first 10 records
SELECT * FROM debt_data LIMIT 10;

-- Q5: Calculate the total global debt (total external debt, 2024)
SELECT SUM(debt_value) AS total_global_debt
FROM debt_data
WHERE series_code = 'DT.DOD.DECT.CD' AND data_year = 2024;

-- Q6: List all unique indicator names
SELECT DISTINCT series_name FROM indicators;

-- Q7: Find the number of records for each country
SELECT c.country_name, COUNT(*) AS total_records
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
GROUP BY c.country_name
ORDER BY total_records DESC;

-- Q8: Display records where debt is greater than 1 billion USD (first 20)
SELECT * FROM debt_data
WHERE series_code = 'DT.DOD.DECT.CD'
  AND data_year = 2024
  AND debt_value > 1000000000
ORDER BY debt_value DESC
LIMIT 20;

-- Q9: Minimum, maximum and average debt (total external debt, 2024)
SELECT MIN(debt_value) AS min_debt,
       MAX(debt_value) AS max_debt,
       AVG(debt_value) AS avg_debt
FROM debt_data
WHERE series_code = 'DT.DOD.DECT.CD' AND data_year = 2024;

-- Q10: Count the total number of records
SELECT COUNT(*) AS total_records FROM debt_data;

-- Q11: Total debt for each country (total external debt, 2024)
SELECT c.country_name, SUM(d.debt_value) AS total_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE d.series_code = 'DT.DOD.DECT.CD' AND d.data_year = 2024
GROUP BY c.country_name
ORDER BY total_debt DESC;

-- Q12: Top 10 countries with the highest total debt
SELECT c.country_name, SUM(d.debt_value) AS total_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE d.series_code = 'DT.DOD.DECT.CD' AND d.data_year = 2024
GROUP BY c.country_name
ORDER BY total_debt DESC
LIMIT 10;

-- Q13: Average debt per country (average over 2000-2024)
SELECT c.country_name, AVG(d.debt_value) AS avg_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE d.series_code = 'DT.DOD.DECT.CD'
GROUP BY c.country_name
ORDER BY avg_debt DESC;

-- Q14: Total debt for each indicator (debt stock indicators, 2024)
SELECT i.series_name, SUM(d.debt_value) AS total_debt
FROM debt_data d
JOIN indicators i ON d.series_code = i.series_code
WHERE d.data_year = 2024
  AND i.series_name LIKE '%(DOD, current US$)'
GROUP BY i.series_name
ORDER BY total_debt DESC;

-- Q15: Indicator contributing the highest total debt
SELECT i.series_name, SUM(d.debt_value) AS total_debt
FROM debt_data d
JOIN indicators i ON d.series_code = i.series_code
WHERE d.data_year = 2024
  AND i.series_name LIKE '%(DOD, current US$)'
GROUP BY i.series_name
ORDER BY total_debt DESC
LIMIT 1;
-- Q16: Country with the lowest total debt (total external debt, 2024)
SELECT c.country_name, d.debt_value AS total_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE d.series_code = 'DT.DOD.DECT.CD' AND d.data_year = 2024
ORDER BY total_debt ASC
LIMIT 1;

-- Q17: Total debt for each country and indicator combination (debt stocks, 2024, first 50 rows)
SELECT c.country_name, i.series_name, SUM(d.debt_value) AS total_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
JOIN indicators i ON d.series_code = i.series_code
WHERE d.data_year = 2024
  AND i.series_name LIKE '%(DOD, current US$)'
GROUP BY c.country_name, i.series_name
ORDER BY c.country_name, total_debt DESC
LIMIT 50;

-- Q18: Count how many indicators each country has
SELECT c.country_name, COUNT(DISTINCT d.series_code) AS indicator_count
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
GROUP BY c.country_name
ORDER BY indicator_count DESC;

-- Q19: Countries whose total debt is above the global average (2024)
SELECT c.country_name, d.debt_value AS total_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE d.series_code = 'DT.DOD.DECT.CD'
  AND d.data_year = 2024
  AND d.debt_value > (
      SELECT AVG(debt_value)
      FROM debt_data
      WHERE series_code = 'DT.DOD.DECT.CD' AND data_year = 2024
  )
ORDER BY total_debt DESC;

-- Q20: Rank countries by total debt, highest to lowest (2024)
SELECT RANK() OVER (ORDER BY d.debt_value DESC) AS debt_rank,
       c.country_name,
       d.debt_value AS total_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE d.series_code = 'DT.DOD.DECT.CD' AND d.data_year = 2024
ORDER BY debt_rank;

-- Q21: Top 5 indicators contributing most to global debt (debt stock indicators, 2024)
SELECT i.series_name, SUM(d.debt_value) AS total_debt
FROM debt_data d
JOIN indicators i ON d.series_code = i.series_code
WHERE d.data_year = 2024
  AND i.series_name LIKE '%(DOD, current US$)'
GROUP BY i.series_name
ORDER BY total_debt DESC
LIMIT 5;

-- Q22: Percentage contribution of each country to total global debt (total external debt, 2024)
SELECT c.country_name,
       d.debt_value AS total_debt,
       ROUND(d.debt_value * 100 / (
           SELECT SUM(debt_value)
           FROM debt_data
           WHERE series_code = 'DT.DOD.DECT.CD' AND data_year = 2024
       ), 2) AS percent_share
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE d.series_code = 'DT.DOD.DECT.CD' AND d.data_year = 2024
ORDER BY total_debt DESC;

-- Q23: Top 3 countries for each indicator (debt stock indicators, 2024)
WITH ranked AS (
    SELECT i.series_name,
           c.country_name,
           d.debt_value,
           RANK() OVER (PARTITION BY d.series_code ORDER BY d.debt_value DESC) AS rnk
    FROM debt_data d
    JOIN countries c ON d.country_code = c.country_code
    JOIN indicators i ON d.series_code = i.series_code
    WHERE d.data_year = 2024
      AND i.series_name LIKE '%(DOD, current US$)'
)
SELECT series_name, country_name, debt_value, rnk
FROM ranked
WHERE rnk <= 3
ORDER BY series_name, rnk;

-- Q24: Difference between maximum and minimum debt for each country (total external debt, 2000-2024)
SELECT c.country_name,
       MAX(d.debt_value) AS max_debt,
       MIN(d.debt_value) AS min_debt,
       MAX(d.debt_value) - MIN(d.debt_value) AS debt_difference
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE d.series_code = 'DT.DOD.DECT.CD'
GROUP BY c.country_name
ORDER BY debt_difference DESC;

-- Q25: Create a view for the top 10 countries with highest debt (total external debt, 2024)
CREATE OR REPLACE VIEW top10_countries AS
SELECT c.country_name, d.debt_value AS total_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE d.series_code = 'DT.DOD.DECT.CD' AND d.data_year = 2024
ORDER BY total_debt DESC
LIMIT 10;

SELECT * FROM top10_countries;

-- Q26: Categorize countries into High, Medium and Low Debt (total external debt, 2024)
-- High: 100 billion or more, Medium: 10 billion to 100 billion, Low: below 10 billion
SELECT c.country_name,
       d.debt_value AS total_debt,
       CASE
           WHEN d.debt_value >= 100000000000 THEN 'High Debt'
           WHEN d.debt_value >= 10000000000 THEN 'Medium Debt'
           ELSE 'Low Debt'
       END AS debt_category
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE d.series_code = 'DT.DOD.DECT.CD' AND d.data_year = 2024
ORDER BY total_debt DESC;

-- Q27: Cumulative debt per country using a window function (total external debt, first 50 rows)
SELECT c.country_name,
       d.data_year,
       d.debt_value,
       SUM(d.debt_value) OVER (PARTITION BY c.country_name ORDER BY d.data_year) AS cumulative_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE d.series_code = 'DT.DOD.DECT.CD'
ORDER BY c.country_name, d.data_year
LIMIT 50;

-- Q28: Indicators whose average debt is higher than the overall average (debt stock indicators, 2000-2024)
SELECT i.series_name, AVG(d.debt_value) AS avg_debt
FROM debt_data d
JOIN indicators i ON d.series_code = i.series_code
WHERE i.series_name LIKE '%(DOD, current US$)'
GROUP BY i.series_name
HAVING AVG(d.debt_value) > (
    SELECT AVG(d2.debt_value)
    FROM debt_data d2
    JOIN indicators i2 ON d2.series_code = i2.series_code
    WHERE i2.series_name LIKE '%(DOD, current US$)'
)
ORDER BY avg_debt DESC;

-- Q29: Countries contributing more than 5% of global debt (total external debt, 2024)
SELECT c.country_name,
       d.debt_value AS total_debt,
       ROUND(d.debt_value * 100 / (
           SELECT SUM(debt_value)
           FROM debt_data
           WHERE series_code = 'DT.DOD.DECT.CD' AND data_year = 2024
       ), 2) AS percent_share
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE d.series_code = 'DT.DOD.DECT.CD'
  AND d.data_year = 2024
  AND d.debt_value * 100 / (
      SELECT SUM(debt_value)
      FROM debt_data
      WHERE series_code = 'DT.DOD.DECT.CD' AND data_year = 2024
  ) > 5
ORDER BY total_debt DESC;

-- Q30: Most dominant indicator for each country (debt stock indicators, 2024, excluding the total itself)
WITH ranked AS (
    SELECT c.country_name,
           i.series_name,
           d.debt_value,
           ROW_NUMBER() OVER (PARTITION BY c.country_name ORDER BY d.debt_value DESC) AS rn
    FROM debt_data d
    JOIN countries c ON d.country_code = c.country_code
    JOIN indicators i ON d.series_code = i.series_code
    WHERE d.data_year = 2024
      AND i.series_name LIKE '%(DOD, current US$)'
      AND d.series_code <> 'DT.DOD.DECT.CD'
)
SELECT country_name, series_name, debt_value
FROM ranked
WHERE rn = 1
ORDER BY country_name;