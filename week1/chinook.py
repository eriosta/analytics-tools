import sqlite3
import pandas as pd

connection = sqlite3.connect('week1\chinook.db')

df = pd.read_sql_query("SELECT TrackId, Name, AlbumId FROM tracks", connection)

print(df.head())