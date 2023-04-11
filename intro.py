import sqlite3 # standard python lib

# Establish the connection to SQL DB
connection_to_DB=sqlite3.connect('database.db')
# Have access to Rows & Columns
cursor=connection_to_DB.cursor() 

# Run SQL query - get ALL rows and order by asn value from smaller to bigger
query=cursor.execute("SELECT * FROM 'ips' ORDER BY asn")
query.fetchall() # fetchall() - method - like a button to click an run a query :)

# Get a specific columns rather than all of them (*) / IP and ASN
query=cursor.execute("SELECT address,asn FROM 'ips' ORDER BY asn")

# Get rows&columns where ASP is less than 250
query=cursor.execute("SELECT*FROM 'ips' WHERE asn<250")
result=query.fetchall()

# Get rows&columns where ASP less than 250 and DOMAIN contains 'sa' 
query=cursor.execute("SELECT*FROM 'ips' WHERE asn<250 AND domain LIKE '%sa'")
outcome=query.fetchall()

for row in outcome:
    print(row)