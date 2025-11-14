import sqlite3

# Cria/abre um arquivo de banco local
conn = sqlite3.connect("EcommerceDB.db")
cursor = conn.cursor()

# Lê o arquivo SQL e executa
with open("ecommerce.sql", "r", encoding="utf-8") as f:
    sql_script = f.read()

cursor.executescript(sql_script)
conn.commit()
conn.close()

print("Banco EcommerceDB.db criado com sucesso a partir do arquivo SQL!")
