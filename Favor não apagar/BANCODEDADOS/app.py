from flask import Flask, render_template
import mysql.connector

app = Flask(__name__)

# Configuração da conexão com MySQL
db_config = {
    'host': 'localhost',
    'user': 'root',        # coloque seu usuário MySQL
    'password': 'playgrand40X',  # coloque sua senha MySQL
    'database': 'EcommerceDB'
}

def get_db_connection():
    return mysql.connector.connect(**db_config)

# Rota para mostrar clientes
@app.route("/clientes")
def clientes():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Clientes")
    clientes = cursor.fetchall()
    conn.close()
    return render_template("clientes.html", clientes=clientes)

# Rota para mostrar produtos
@app.route("/produtos")
def produtos():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Produtos")
    produtos = cursor.fetchall()
    conn.close()
    return render_template("produtos.html", produtos=produtos)

# Rota para mostrar pedidos
@app.route("/pedidos")
def pedidos():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Pedidos")
    pedidos = cursor.fetchall()
    conn.close()
    return render_template("pedidos.html", pedidos=pedidos)

# Rota para mostrar itens de pedidos (JOIN completo)
@app.route("/itens_pedido")
def itens_pedido():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT 
            p.ID_Pedido,
            c.Nome AS Cliente,
            pr.Nome_Produto,
            ip.Quantidade,
            ip.Preco_Unitario
        FROM Itens_Pedido ip
        JOIN Pedidos p ON ip.ID_Pedido_FK = p.ID_Pedido
        JOIN Produtos pr ON ip.ID_Produto_FK = pr.ID_Produto
        JOIN Clientes c ON p.ID_Cliente_FK = c.ID_Cliente
    """)
    itens = cursor.fetchall()
    conn.close()
    return render_template("itens_pedido.html", itens=itens)

if __name__ == "__main__":
    app.run(debug=True)
