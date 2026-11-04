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

countries = df[["country_code", "country_name"]].drop_duplicates()

sql = "INSERT INTO countries (country_code, country_name) VALUES (%s, %s)"
cursor.executemany(sql, countries.values.tolist())
conn.commit()

print("Countries inserted:", cursor.rowcount)

cursor.close()
conn.close()