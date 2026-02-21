# 🔄 AnyDesk ID Reset

A Windows batch script that resets your AnyDesk ID by clearing configuration files and regenerating a new one — useful when you've hit the free plan session limit.

---

## ⚠️ Disclaimer

This script is intended for **legitimate personal or administrative use only**, such as resetting a device that was incorrectly registered or managing your own machines. Bypassing AnyDesk's commercial usage restrictions to avoid purchasing a proper license may violate [AnyDesk's Terms of Service](https://anydesk.com/en/terms). Use responsibly.

---

## 🛠️ How It Works

The script performs the following steps automatically:

1. **Checks for Administrator privileges** — required to stop/start the AnyDesk service.
2. **Stops AnyDesk** — kills both the service and any running process (including portable installs).
3. **Deletes identity files** — removes `service.conf` and `system.conf` from both system-wide and user-specific AnyDesk directories. These files store the AnyDesk ID.
4. **Backs up user preferences** — saves `user.conf` (address book, UI settings) and the thumbnails folder to `%TEMP%` so your contacts and history are preserved.
5. **Deletes `ad_*` files** — clears additional cached files associated with the old identity.
6. **Restarts AnyDesk** — launches it so a new ID is generated automatically.
7. **Waits for the new ID** — polls `system.conf` every 2 seconds (up to ~30 seconds) until the new `ad.anynet.id` is confirmed.
8. **Restores user preferences** — moves back `user.conf` and thumbnails, then does a final restart of AnyDesk.

---

## 📋 Requirements

- Windows 7 or later
- AnyDesk installed (standard install or portable)
- Run as **Administrator**

---

## 🚀 Usage

1. Download `reset_any.bat`
2. Right-click → **Run as administrator**
3. Wait for the script to complete — it will confirm when done
4. Open AnyDesk and check your new ID

> The script handles both system-installed AnyDesk (`Program Files` and `Program Files (x86)`) and portable versions.

---

## 📁 Files Affected

| Path | Description |
|---|---|
| `%ALLUSERSPROFILE%\AnyDesk\service.conf` | System-wide service config (contains old ID) |
| `%ALLUSERSPROFILE%\AnyDesk\system.conf` | System-wide system config (contains old ID) |
| `%APPDATA%\AnyDesk\service.conf` | User-level service config |
| `%APPDATA%\AnyDesk\system.conf` | User-level system config |
| `%ALLUSERSPROFILE%\AnyDesk\ad_*` | Cached identity files |
| `%APPDATA%\AnyDesk\ad_*` | Cached identity files (user) |
| `%APPDATA%\AnyDesk\user.conf` | ✅ Backed up and restored (contacts, settings) |
| `%APPDATA%\AnyDesk\thumbnails\` | ✅ Backed up and restored (connection history thumbnails) |

---

## 🐛 Troubleshooting

**Script says "not Administrator"**
→ Right-click the `.bat` file and select *Run as administrator*.

**AnyDesk doesn't start after the script**
→ The script tries both `Program Files` and `Program Files (x86)`. If you use a portable version placed elsewhere, you may need to start AnyDesk manually after running the script.

**"Could not confirm new ID" warning**
→ This means AnyDesk took longer than ~30 seconds to generate a new ID. The script will still continue. Open AnyDesk manually to verify the new ID was generated.

---

## 📄 License

MIT — free to use, modify, and distribute.

---

---

## 🇲🇽 Descripción en Español

Este script de Windows (`.bat`) resetea tu ID de AnyDesk eliminando los archivos de configuración que almacenan la identidad del equipo, forzando a AnyDesk a generar una nueva ID al reiniciarse.

**¿Para qué sirve?**
Cuando AnyDesk detecta uso comercial no licenciado, puede limitar las sesiones. Este script permite generar una nueva ID en el equipo.

**¿Qué hace exactamente?**
- Detiene AnyDesk (servicio y proceso)
- Elimina los archivos `service.conf`, `system.conf` y archivos `ad_*` que contienen la ID actual
- Hace un respaldo de `user.conf` (libreta de contactos, preferencias) y las miniaturas
- Reinicia AnyDesk para generar una nueva ID
- Espera a confirmar que la nueva ID fue generada
- Restaura tus preferencias de usuario
- Hace un inicio final de AnyDesk

**Requisitos:**
- Windows 7 o superior
- AnyDesk instalado
- Ejecutar como **Administrador**

**Uso:**
1. Descarga `reset_any.bat`
2. Clic derecho → *Ejecutar como administrador*
3. Espera a que termine — mostrará "Completado" al finalizar
4. Abre AnyDesk y verifica tu nueva ID
