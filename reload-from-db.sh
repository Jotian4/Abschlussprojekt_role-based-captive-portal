#!/bin/bash

DB="/home/joris/portal/clients.db"
SET_SCRIPT="/home/joris/portal/set-role.sh"

if [ ! -f "$DB" ]; then
  echo "[!] Datenbank nicht gefunden: $DB"
  exit 1
fi

if [ ! -x "$SET_SCRIPT" ]; then
  echo "[!] set-role.sh ist nicht ausführbar oder fehlt"
  exit 1
fi

echo "[+] Lade Einträge aus der Datenbank..."

sqlite3 "$DB" "SELECT ip, rolle FROM clients;" | while IFS='|' read -r IP ROLLE; do
  echo "[→] Setze Rolle $ROLLE für $IP"
  bash "$SET_SCRIPT" "$IP" "$ROLLE"
done

echo "[✔] Alle Rollenregelungen wurden neu gesetzt."
