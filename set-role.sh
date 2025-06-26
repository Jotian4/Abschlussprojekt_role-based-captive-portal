#!/bin/bash
# Default-Regel: Alles blocken außer DNS & Umleitung auf Loginseite (Port 80)
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j DNAT --to-destination 192.168.4.1:80
iptables -t nat -A PREROUTING -i wlan0 -p udp --dport 53 -j DNAT --to-destination 192.168.4.1:53

IP="$1"
ROLE="$2"
MAC="$3"

if [ -z "$MAC" ]; then
  echo "[!] Keine MAC-Adresse gefunden für IP $IP"
  exit 1
fi

echo "[+] Setze Regeln für $MAC (Rolle: $ROLE)"

# 🔧 Weiterleitung auf Loginseite entfernen (HTTP/HTTPS)
iptables -t nat -D PREROUTING -s 192.168.4.0/24 -m mac --mac-source "$MAC" -p tcp --dport 80 -j DNAT --to-destination 192.168.4.1:80 2>/dev/null
iptables -t nat -D PREROUTING -s 192.168.4.0/24 -m mac --mac-source "$MAC" -p tcp --dport 443 -j REDIRECT --to-ports 80 2>/dev/null

# Vorherige Regeln löschen (alle für diese MAC)
iptables -D FORWARD -m mac --mac-source "$MAC" -j ACCEPT 2>/dev/null
iptables -D FORWARD -m mac --mac-source "$MAC" -j DROP 2>/dev/null
iptables -D FORWARD -m mac --mac-source "$MAC" -d 142.250.0.0/16 -j REJECT 2>/dev/null
iptables -D FORWARD -m mac --mac-source "$MAC" -d 104.18.21.213 -j ACCEPT 2>/dev/null
iptables -D FORWARD -m mac --mac-source "$MAC" -j REJECT 2>/dev/null

# Neue Regeln setzen
case "$ROLE" in
  Erwachsen|adult)
    iptables -I FORWARD -m mac --mac-source "$MAC" -j ACCEPT
    ;;
  Teenager|teen)
    iptables -A FORWARD -m mac --mac-source "$MAC" -d 142.250.0.0/16 -j REJECT
    iptables -A FORWARD -m mac --mac-source "$MAC" -j ACCEPT
    ;;
  Kind|child|kid)
    iptables -A FORWARD -m mac --mac-source "$MAC" -d 104.18.21.213 -j ACCEPT
    iptables -A FORWARD -m mac --mac-source "$MAC" -j REJECT
    ;;
  *)
    echo "Unbekannte Rolle: $ROLE"
    exit 1
    ;;
esac


echo "[✔] Regeln gesetzt für MAC $MAC ($ROLE)"
exit 0

# NAT aktivieren (nur einmal nötig)
iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || \
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Weiterleitung aktivieren (auch nur einmal)
sysctl -w net.ipv4.ip_forward=1
