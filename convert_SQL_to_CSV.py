import sqlite3 # standard python lib
import pandas
# Establish the connection to SQL DB
connection_to_DB=sqlite3.connect('database.db')
# Have access to Rows & Columns
cursor=connection_to_DB.cursor() 

data_frame=pandas.read_sql_query("SELECT*FROM 'ips' ORDER BY asn",connection_to_DB)
print(data_frame)

data_frame.to_csv('DB_of_IPs.csv',index=None)
