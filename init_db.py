import sqlite3
import os

DB_PATH = "/home/joris/portal/clients.db"

# Alte DB löschen (falls vorhanden)
if os.path.exists(DB_PATH):
    os.remove(DB_PATH)
    print("⚠️ Alte DB gelöscht.")

# Neue DB anlegen
conn = sqlite3.connect(DB_PATH)
c = conn.cursor()

c.execute("""
CREATE TABLE clients (
    mac TEXT PRIMARY KEY,
    name TEXT,
    rolle TEXT,
    ip TEXT,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
""")

# Testeintrag hinzufügen
c.execute("""
INSERT INTO clients (mac, name, rolle, ip)
VALUES (?, ?, ?, ?)
""", ('F0-20-FF-5C-8A-87', 'joris', 'Erwachsen', '192.168.4.117'))

conn.commit()
conn.close()
print("✅ Neue clients.db erfolgreich erstellt mit Testeintrag.")

