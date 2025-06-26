
# CaptivePortalRB – Captive Portal mit rollenbasierter Zugriffskontrolle

## 🧩 Projektbeschreibung

Dieses Projekt implementiert ein Captive Portal auf einem Raspberry Pi, das Nutzern nach dem Verbinden mit einem offenen WLAN eine Loginseite präsentiert. Nach erfolgreichem Login wird – abhängig von der gewählten Rolle (Kind, Teenager, Erwachsener) – der Internetzugang differenziert freigeschaltet.

Das Projekt vereint Linux-Netzwerktechnik, Firewall-Logik (iptables), Python-Entwicklung mit Flask sowie Datenbankanbindung via SQLite. Ziel ist ein kontrolliertes, lokal gesteuertes Netzwerkgateway, das sich flexibel anpassen lässt.

## 🏗️ Systemarchitektur

- **Hardware**: Raspberry Pi (alternativ Ubuntu VM)
- **Netzwerk**:
  - `wlan0`: Access Point (hostapd)
  - `eth0`: Internet-Uplink
- **Software-Komponenten**:
  - `hostapd` – WLAN Access Point
  - `dnsmasq` – DHCP & DNS
  - `iptables` – Rollenbasierte Netzfreigabe
  - `Flask` – Webserver für Loginseite
  - `SQLite` – Datenbank zur Benutzerverwaltung
  - `openNDS` – Captive-Portal-Umleitung
- **Rollen**:
  - **Kind** → nur Whitelist (z. B. Lernseiten)
  - **Teenager** → eingeschränkter Zugriff (z. B. kein Social Media)
  - **Erwachsener** → uneingeschränkter Internetzugang

## 🗂️ Projektstruktur

```
CaptivePortalRB/
├── app/                      # Flask Webserver mit Loginseite
│   ├── app.py  
├── scripts/                  # Bash-Skripte für iptables-Rollenzuweisung
│   └── set-role.sh
├── data/                     # SQLite Datenbank
│   └── clients.db
├── config/                   # hostapd, dnsmasq, openNDS Configs
├── README.md
```

## 🚀 Setup-Anleitung (Kurzfassung)

### 1. Raspberry Pi vorbereiten
```bash
sudo apt update && sudo apt install hostapd dnsmasq iptables python3 python3-pip
```

### 2. Flask installieren
```bash
python3 -m venv venv
source venv/bin/activate
pip install flask
```

### 3. Datenbank initialisieren
```bash
sqlite3 data/clients.db < schema.sql
```

### 4. Captive Portal starten
```bash
sudo systemctl start hostapd
sudo systemctl start dnsmasq
sudo python3 app/app.py
```

## 📋 Features

- WLAN-Access-Point mit automatischer DHCP-Vergabe
- Umleitung auf Loginseite per DNS und HTTP-Redirect
- Benutzer-Login mit Namens- und Rollenauswahl
- Rollenabhängige Freischaltung über iptables-Regeln
- Benutzerdatenbank mit MAC- und IP-Tracking
- Testweise Integration von RaspAP, NoDogSplash, openNDS
- Ausführliche Tagesreflexionen und Fehleranalyse

## ❌ Bekannte Probleme

- **nftables** kollidiert mit iptables und openNDS → auf iptables-legacy umstellen
- **RaspAP** hinterlässt viele versteckte Dienste/Konflikte → mit Vorsicht einsetzen
- **NoDogSplash** instabil bei Rollenlogik → openNDS als Ersatz empfohlen
- **Flask als root** nötig für iptables → mit `sudo` oder per Wrapper ausführen

## 📚 Quellen

- [openNDS Doku](https://opennds.readthedocs.io/en/stable/)
- [Flask Docs](https://flask.palletsprojects.com/)
- [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)
- [hostapd](https://w1.fi/hostapd/)
- [iptables](https://man7.org/linux/man-pages/man8/iptables.8.html)
- [RaspAP GitHub](https://github.com/RaspAP/raspap-webgui)

## 🧠 Lessons Learned

Das Projekt war technisch anspruchsvoller als erwartet. Viele Probleme entstanden durch Konflikte zwischen Tools, doppelte IP-Zuweisungen und Rechteprobleme bei der Skriptausführung. Besonders lehrreich waren die Themen: Netzwerkaufbau unter Linux, systematisches Debugging, iptables-Regeln dynamisch setzen, und der Umgang mit unvollständiger Dokumentation. Auch wenn nicht alles am Ende funktionierte, war der Lerneffekt enorm.

## Autor

**Joris Brunold**  
Lehrfirma: Netcloud  
Projektzeitraum: Juni 2025  
Projektname: *CaptivePortalRB*

