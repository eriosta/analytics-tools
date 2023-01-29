import sqlite3
import pandas as pd

connection = sqlite3.connect('week2\salary.db')

df = pd.read_sql_query("SELECT * FROM salary_range_by_job_classification", connection)

df['Biweekly_High_Rate']

df['Biweekly_High_Rate'] = df['Biweekly_High_Rate'].str.replace(',', '')
df['Biweekly_High_Rate'] = df['Biweekly_High_Rate'].str.replace('$', '')

df['Biweekly_High_Rate'] = df['Biweekly_High_Rate'].astype('float')

df['Biweekly_High_Rate']