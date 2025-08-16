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

## 11. 🔐 Environment Variables
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

## 12. 🧪 Verify Setup
Check service status and socket:
```bash
systemctl status paperless-web
curl --unix-socket /run/paperless/paperless.sock http://localhost
```

## 13. 🧹 Privilege Cleanup (Optional)
Remove unused roles and tighten access:
```sql
DROP ROLE IF EXISTS paperless_old;
REVOKE ALL ON DATABASE paperless FROM PUBLIC;
```

## 14. 🔄 System Maintenance Tips
- Use systemctl list-units --type=service to monitor services.
- Rotate logs with logrotate.
- Backup /opt/paperless and PostgreSQL regularly.

# 📋 Summary Table
| Component | Access Method | User | Path/Socket |
|-----|-----|-----|-----| 
| PostgreSQL | Unix socket | paperless | /var/run/postgresql | 
| Redis | Unix socket + auth | paperless | /run/redis/redis.sock | 
| Gunicorn | Unix socket | paperless | /run/paperless/paperless.sock | 
| Samba | Network share | paperless | /opt/paperless/consumption | 
| Nginx | Reverse proxy | - | /etc/nginx/sites-available | 




