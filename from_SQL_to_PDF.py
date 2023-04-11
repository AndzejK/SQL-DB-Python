import sqlite3 # standard python lib
from fpdf import FPDF
# Establish the connection to SQL DB
connection_to_DB=sqlite3.connect('database.db')
# Have access to Rows & Columns
cursor=connection_to_DB.cursor() 

cursor.execute('PRAGMA table_info(ips)') 
columns=cursor.fetchall()
print(columns)

pdf=FPDF(orientation='P',unit='pt',format='A4' )
pdf.add_page()
# getting a header 
for column in columns:
    pdf.set_font(family='Times',style='B',size=14)
    pdf.cell(w=100,h=25, txt=column[1],border=1)

# new line/break after header
pdf.ln()

cursor.execute("SELECT * FROM 'ips' ")  
rows=cursor.fetchall()

# getting the actual data
for row in rows:
    for element in row:
        pdf.set_font(family='Times',size=12)
        pdf.cell(w=100,h=25, txt=str(element),border=1)
        print(element)
    pdf.ln()
pdf.output('outcome.pdf')
