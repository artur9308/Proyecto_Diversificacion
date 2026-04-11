from flask import Flask, render_template, jsonify, send_from_directory
import mysql.connector

app = Flask(__name__, static_folder='static')
app.config['JSON_AS_ASCII']=False

@app.route('/static/<path:filename>')
def static_files(filename):
    return send_from_directory('static', filename)

# 🔌 conexión MySQL (Docker)
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        port=3307,  # 👈 por tu docker-compose
        user="root",
        password="root123",  # 👈 de tu .env
        database="milpa_alta_agricola",
        charset="utf8mb4",
        collation="utf8mb4_general_ci",
        use_unicode=True
    )

# 🏠 home
@app.route("/")
def home():
    return render_template("index.html")

# 🌱 API con datos completos
@app.route("/api/cultivos")
def cultivos():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SET NAMES utf8mb4;")

    cursor.execute("""
        SELECT 
            c.nombre_comun AS nombre,
            c.tipo_cultivo,
            r.rendimiento_ton_ha,
            r.precio_productor,
            r.ingreso_bruto,
            r.costo_total,
            r.utilidad_neta as rentabilidad
        FROM cultivos c
        JOIN resumen_economico r 
            ON c.id_cultivo = r.id_cultivo
    """)

    data = cursor.fetchall()
    conn.close()
    return jsonify(data)

if __name__ == "__main__":
    app.run(debug=True)