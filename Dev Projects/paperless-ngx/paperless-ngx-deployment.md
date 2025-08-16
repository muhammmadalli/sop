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

