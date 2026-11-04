import pandas as pd
import mysql.connector

df = pd.read_csv("cleaned_debt_data_v2.csv")

year_cols = [str(y) for y in range(2000, 2025)]

long_df = df.melt(
    id_vars=["country_code", "series_code"],
    value_vars=year_cols,
    var_name="data_year",
    value_name="debt_value"
)
long_df["data_year"] = long_df["data_year"].astype(int)
long_df = long_df.dropna(subset=["debt_value"])
long_df = long_df[["country_code", "series_code", "data_year", "debt_value"]]

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="YOUR_PASSWORD",
    database="debt_analysis"
)
cursor = conn.cursor()

sql = "INSERT INTO debt_data (country_code, series_code, data_year, debt_value) VALUES (%s, %s, %s, %s)"

rows = long_df.values.tolist()
chunk = 50000

for start in range(0, len(rows), chunk):
    cursor.executemany(sql, rows[start:start + chunk])
    conn.commit()
    print("Inserted so far:", min(start + chunk, len(rows)))

cursor.close()
conn.close()