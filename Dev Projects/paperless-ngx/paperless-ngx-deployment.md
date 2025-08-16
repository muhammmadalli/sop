<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [🛠️ Paperless-ngx Deployment & Hardening Guide](#-paperless-ngx-deployment--hardening-guide)
  - [01. 📁 Folder Structure](#01--folder-structure)
  - [02. 👤 Create Paperless Service User](#02--create-paperless-service-user)
  - [03. 🐍 Python Virtual Environment](#03--python-virtual-environment)
  - [04. 🗃️ PostgreSQL Configuration](#04--postgresql-configuration)
  - [05. 🔧 Redis Configuration](#05--redis-configuration)
  - [06. 🌐 Gunicorn Systemd Service](#06--gunicorn-systemd-service)
  - [07. 🌍 Nginx Configuration](#07--nginx-configuration)
  - [08. 🗂️ Samba Share](#08--samba-share)
  - [09. 🖼️ ImageMagick PDF Support](#09--imagemagick-pdf-support)
  - [10. 📦 jbig2enc Installation](#10--jbig2enc-installation)
  - [11. 🧠 NLTK Data](#11--nltk-data)
  - [12. 🔐 Firewall Rules (UFW)](#12--firewall-rules-ufw)
  - [13. 🔐 Environment Variables](#13--environment-variables)
  - [14. 🧪 Verify Setup](#14--verify-setup)
  - [15. 🧹 Privilege Cleanup (Optional)](#15--privilege-cleanup-optional)
  - [16. 🛡️ Fail2Ban for Nginx](#16--fail2ban-for-nginx)
  - [17. 📜 Auditd and Logrotate](#17--auditd-and-logrotate)
  - [18. 🔄 System Maintenance Tips](#18--system-maintenance-tips)
- [Summary](#summary)
  - [✅ Summary Table](#-summary-table)
  - [📋 Config Table](#-config-table)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# 🛠️ Paperless-ngx Deployment & Hardening Guide

A comprehensive guide to deploying and securing Paperless-ngx on Debian 11 using socket-only services, systemd, and optional enhancements.

## 01. 📁 Folder Structure
Create the necessary directories and set ownership and permissions:
```bash
mkdir -p /opt/paperless/{consumption,media,data}
chown -R paperless:paperless /opt/paperless
chmod -R 750 /opt/paperless
```

## 02. 👤 Create Paperless Service User
Create a dedicated system user for Paperless:
```bash
useradd -r -s /usr/sbin/nologin -d /opt/paperless paperless
passwd -l paperless
```

## 03. 🐍 Python Virtual Environment
Set up a virtual environment for Paperless:
```bash
python3 -m venv /opt/paperless/.local
source /opt/paperless/.local/bin/activate
pip install --upgrade pip
pip install paperless-ngx
```

## 04. 🗃️ PostgreSQL Configuration
Configure PostgreSQL for socket-only access.

1. Edit postgresql.conf:
```ini
listen_addresses = ''
unix_socket_directories = '/var/run/postgresql'
```

2. Edit pg_hba.conf:
```ini
local   paperless   paperless   peer
```

3. Create database and role:
```bash
sudo -u postgres createuser paperless
sudo -u postgres createdb -O paperless paperless
```

## 05. 🔧 Redis Configuration
1. Edit /etc/redis/redis.conf:
```ini
port 0
unixsocket /run/redis/redis.sock
unixsocketperm 770
requirepass your_secure_password
```

2. Set permissions of redis socket:
```bash
chown redis:paperless /run/redis/redis.sock
chmod 770 /run/redis/redis.sock
usermod -aG redis paperless
```

## 06. 🌐 Gunicorn Systemd Service
1. Create /etc/systemd/system/paperless-web.service:
```ini
[Unit]
Description=Paperless Web Server
After=network.target

[Service]
User=paperless
Group=paperless
RuntimeDirectory=paperless
ExecStart=/opt/paperless/.local/bin/gunicorn \
    --bind unix:/run/paperless/paperless.sock \
    paperless_wsgi:application
ProtectSystem=full
ProtectHome=true
PrivateTmp=true
NoNewPrivileges=true
MemoryMax=500M
CPUQuota=50%
Restart=always

[Install]
WantedBy=multi-user.target
```

2. Enable and start:
```bash
systemctl enable --now paperless-web
```

## 07. 🌍 Nginx Configuration
1. Create /etc/nginx/sites-available/paperless:
```Nginx
server {
    listen 80;
    server_name your.domain.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name your.domain.com;

    ssl_certificate /etc/letsencrypt/live/your.domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your.domain.com/privkey.pem;

    location / {
        proxy_pass http://unix:/run/paperless/paperless.sock;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

2. Enable and reload:
```bash
ln -s /etc/nginx/sites-available/paperless /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx
certbot --nginx -d your.domain.com
```

## 08. 🗂️ Samba Share
Edit /etc/samba/smb.conf:
```ini
[consumption]
   path = /opt/paperless/consumption
   browseable = yes
   writable = yes
   guest ok = no
   valid users = paperless
```

2. Enable Samba:
```bash
systemctl enable --now smbd
```

## 09. 🖼️ ImageMagick PDF Support
Edit /etc/ImageMagick-6/policy.xml:
```xml
<policy domain="coder" rights="read|write" pattern="PDF" />
```

## 10. 📦 jbig2enc Installation
Install the encoder manually:
```bash
git clone https://github.com/agl/jbig2enc.git
cd jbig2enc
make
cp jbig2 /usr/local/bin/
```

## 11. 🧠 NLTK Data
```python
import nltk
nltk.download('punkt')
nltk.download('stopwords')
nltk.download('snowball_data')
```

Move data to:
```bash
mkdir -p /usr/share/nltk_data
mv ~/nltk_data/* /usr/share/nltk_data/
```

## 12. 🔐 Firewall Rules (UFW)
```bash
sudo apt install ufw
ufw default deny incoming
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw deny 5432
ufw deny 6379
ufw enable
```



## 13. 🔐 Environment Variables
Create /opt/paperless/.env:
```ini
PAPERLESS_REDIS=unix:///run/redis/redis.sock?password=your_secure_password
PAPERLESS_DBHOST=/var/run/postgresql
PAPERLESS_DBUSER=paperless
PAPERLESS_DBPASS=
PAPERLESS_DBNAME=paperless
PAPERLESS_CONSUMPTION_DIR=/opt/paperless/consumption
PAPERLESS_MEDIA_ROOT=/opt/paperless/media
PAPERLESS_DATA_DIR=/opt/paperless/data
```

## 14. 🧪 Verify Setup
Check service status and socket:
```bash
systemctl status paperless-web
curl --unix-socket /run/paperless/paperless.sock http://localhost
```

## 15. 🧹 Privilege Cleanup (Optional)
Remove unused roles and tighten access:
```sql
DROP ROLE IF EXISTS paperless_old;
REVOKE ALL ON DATABASE paperless FROM PUBLIC;
```

## 16. 🛡️ Fail2Ban for Nginx
Open /etc/fail2ban/jail.d/nginx.conf
```ini
[nginx-http-auth]
enabled = true
port    = http,https
filter  = nginx-http-auth
logpath = /var/log/nginx/error.log
maxretry = 3
```

```bash
systemctl enable --now fail2ban
```

## 17. 📜 Auditd and Logrotate
```bash
apt install auditd logrotate
nano /etc/logrotate.d/paperless
```

```ini
/opt/paperless/logs/*.log {
    daily
    missingok
    rotate 14
    compress
    notifempty
    create 640 paperless paperless
}
```




## 18. 🔄 System Maintenance Tips
- Use systemctl list-units --type=service to monitor services.
- Backup /opt/paperless and PostgreSQL regularly.

# Summary

## ✅ Summary Table
| Component | Configuration Summary | Security Level |
|----|----|----| 
| OS (Debian 11) | Offline install, tuned swap, clean structure | 🟢 Hardened | 
| Redis | Unix socket only, password auth, restricted permissions | 🟢 Hardened | 
| PostgreSQL | Socket-only, peer auth, locked-down pg_hba.conf | 🟢 Hardened | 
| Gunicorn | Unix socket only, systemd sandboxing | 🟢 Hardened | 
| Nginx | HTTPS with redirect, reverse proxy to socket | 🟢 Hardened | 
| Python (.local) | Virtualenv under /opt/paperless/.local, isolated from system | 🟢 Hardened | 
| Paperless-ngx | Manual install, secure env, verified OCR tools | 🟢 Hardened | 
| Samba Share | Shared input folder with restricted access | 🟡 Controlled | 
| ImageMagick PDF | Enabled PDF processing for thumbnails | 🟡 Controlled | 
| jbig2enc | Installed manually, used for PDF compression | 🟡 Controlled | 
| NLTK Data | Downloaded for ML features, stored securely | 🟡 Controlled | 
| Firewall | UFW/iptables with minimal exposure | 🟢 Hardened | 
| User Accounts | No shell, no password, isolated permissions | 🟢 Hardened | 
| Fail2Ban | Brute-force protection for Nginx | 🟢 Hardened | 
| Auditd | Tracks file access and system events | 🟢 Hardened | 
| Logrotate | Manages logs for Paperless and system services | 🟢 Hardened | 



---



## 📋 Config Table
| Component | Access Method | User | Path/Socket |
|-----|-----|-----|-----| 
| PostgreSQL | Unix socket | paperless | /var/run/postgresql | 
| Redis | Unix socket + auth | paperless | /run/redis/redis.sock | 
| Gunicorn | Unix socket | paperless | /run/paperless/paperless.sock | 
| Samba | Network share | paperless | /opt/paperless/consumption | 
| Nginx | Reverse proxy | - | /etc/nginx/sites-available | 




