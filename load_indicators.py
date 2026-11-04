import pandas as pd
import mysql.connector

df = pd.read_csv("cleaned_debt_data_v2.csv")

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="YOUR_PASSWORD",
    database="debt_analysis"
)
cursor = conn.cursor()

indicators = df[["series_code", "series_name"]].drop_duplicates(subset="series_code")

sql = "INSERT INTO indicators (series_code, series_name) VALUES (%s, %s)"
cursor.executemany(sql, indicators.values.tolist())
conn.commit()

print("Indicators inserted:", cursor.rowcount)

cursor.close()
conn.close()