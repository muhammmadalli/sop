<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [🛠 Seafile with Self-Signed TLS](#-seafile-with-self-signed-tls)
- [1. Generate a self-signed certificate](#1-generate-a-self-signed-certificate)
  - [2. Adjust docker-compose.yml](#2-adjust-docker-composeyml)
  - [3. Configure Seafile to use the cert](#3-configure-seafile-to-use-the-cert)
  - [4. Access Seafile](#4-access-seafile)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# 🛠 Seafile with Self-Signed TLS
# 1. Generate a self-signed certificate

On your Windows host (PowerShell) or inside WSL2:

```bash
mkdir D:\seafile\shared\ssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 `
  -keyout D:\seafile\shared\ssl\seafile.key `
  -out D:\seafile\shared\ssl\seafile.crt `
  -subj "/CN=seafile.my"
```

This creates:

seafile.key → private key

seafile.crt → certificate

⚠️ Replace seafile.my with your actual hostname or IP if needed.

## 2. Adjust docker-compose.yml

In your D:\seafile\docker-compose.yml, modify the seafile service:

```yaml
version: '3'

services:
  db:
    image: mariadb:10.11
    container_name: seafile-mysql
    environment:
      - MYSQL_ROOT_PASSWORD=db_dev_root_pw
      - MYSQL_LOG_CONSOLE=true
    volumes:
      - ./shared/db:/var/lib/mysql
    networks:
      - seafile-net

  memcached:
    image: memcached:1.6
    container_name: seafile-memcached
    entrypoint: memcached -m 256
    networks:
      - seafile-net

  seafile:
    image: seafileltd/seafile-mc:11.0.10
    container_name: seafile
    ports:
      - "80:80"
      - "443:443"
    environment:
      - DB_HOST=db
      - DB_ROOT_PASSWD=db_dev_root_pw
      - SEAFILE_SERVER_LETSENCRYPT=false
      - SEAFILE_SERVER_HOSTNAME=localhost   # change to your hostname
    volumes:
      - ./shared/seafile:/shared
      - ./shared/ssl:/shared/ssl  # mount SSL certs
    depends_on:
      - db
      - memcached
    networks:
      - seafile-net

networks:
  seafile-net:
```

## 3. Configure Seafile to use the cert

Once the container starts the first time, it will create an Nginx config inside /shared/seafile/conf.

Edit (inside the container or via mounted path):

D:\seafile\shared\seafile\conf\nginx.conf

Replace the SSL section with:

server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate /shared/ssl/seafile.crt;
    ssl_certificate_key /shared/ssl/seafile.key;

    # ... rest of Seafile’s config ...
}


Then restart Seafile:

docker compose restart seafile

## 4. Access Seafile

Now you can visit:

https://localhost


Your browser will warn about the self-signed cert — accept it, and you’ll see the Seafile login.

✨ From here, you have a working Seafile Community server with self-signed TLS.