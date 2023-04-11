import sqlite3 
import pandas 

# Establish the connection to SQL DB
connection_to_DB=sqlite3.connect('database.db')
# Have access to Rows & Columns
cursor=connection_to_DB.cursor() 

new_rows=[
    ('192.168.22.1','revelsystems.com',233),
    ('172.16.0.1', 'dev.ops.net',111),
    ('10.10.0.1','zero.to.one',109)
]
cursor.executemany("INSERT INTO 'ips' VALUES(?,?,?)",new_rows)
connection_to_DB.commit() # DB/instance !!!
cursor.execute("SELECT*FROM'ips'") # table

# Display more nice result
data_frame=pandas.read_sql_query("SELECT*FROM 'ips' ORDER BY asn",connection_to_DB)
print(data_frame)


