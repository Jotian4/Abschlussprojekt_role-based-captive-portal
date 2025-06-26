#!/bin/bash

echo "[+] Stoppe lighttpd (falls aktiv)..."
sudo systemctl stop lighttpd 2>/dev/null
sudo systemctl disable lighttpd 2>/dev/null

echo "[+] Lösche alle iptables-Regeln..."
sudo iptables -F
sudo iptables -t nat -F

echo "[+] Setze Captive-Portal Umleitungen..."
sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j DNAT --to-destination 192.168.4.1:80
sudo iptables -t nat -A PREROUTING -i wlan0 -p udp --dport 53 -j DNAT --to-destination 192.168.4.1

echo "[+] Blockiere Internetzugang für WLAN-Clients..."
sudo iptables -A FORWARD -i wlan0 -j DROP

echo "[+] Deaktiviere RaspAP-IPTables-Script (wenn vorhanden)..."
if [ -f /etc/raspap/hostapd/enable-iptables.sh ]; then
  sudo mv /etc/raspap/hostapd/enable-iptables.sh /etc/raspap/hostapd/enable-iptables.disabled
  echo "# deaktiviert durch fix_captive.sh" | sudo tee /etc/raspap/hostapd/enable-iptables.sh >/dev/null
fi

echo "[✔] Fertig. Verbinde dich neu mit dem WLAN und teste den Redirect."
