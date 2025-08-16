<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [🧾 Paperless-ngx Server Deployment Brief](#-paperless-ngx-server-deployment-brief)
  - [1. Server Operating System](#1-server-operating-system)
  - [2. Paperless-ngx Application Deployment](#2-paperless-ngx-application-deployment)
  - [3. Implementation Details](#3-implementation-details)
  - [4. Optional Enhancements](#4-optional-enhancements)
    - [Samba Share](#samba-share)
    - [ImageMagick PDF Support](#imagemagick-pdf-support)
    - [jbig2enc Encoder](#jbig2enc-encoder)
    - [NLTK Data](#nltk-data)
  - [5. Security Hardening Measures](#5-security-hardening-measures)
    - [Redis](#redis)
    - [PostgreSQL](#postgresql)
    - [Gunicorn](#gunicorn)
    - [Nginx](#nginx)
    - [System User Isolation](#system-user-isolation)
    - [Systemd Sandboxing](#systemd-sandboxing)
    - [Firewall Rules](#firewall-rules)
    - [Fail2Ban](#fail2ban)
    - [Audit Logging](#audit-logging)
    - [Logrotate](#logrotate)
  - [📊 Summary Table](#-summary-table)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# 🧾 Paperless-ngx Server Deployment Brief

## 1. Server Operating System

- **Distribution**: Debian 11 (Bullseye)
- **Installation Method**: Offline/DVD-based setup with manual package resolution
- **System Tuning**:
  - Optimized swap and resource allocation
  - Clean folder structure for maintainability
  - Privilege isolation for service accounts

## 2. Paperless-ngx Application Deployment

- **Installation Type**: Manual (non-Docker)
- **Components**:
  - **Gunicorn**: WSGI server running Paperless
  - **Redis**: Message broker (socket-only, password-protected)
  - **PostgreSQL**: Database (socket-only, peer-authenticated)
  - **Nginx**: Reverse proxy handling HTTPS and HTTP redirection
- **Python Environment**:
  - Located at `/opt/paperless/.local`
  - Created using `python3 -m venv`
  - Isolated from system Python packages
  - Activated via `source /opt/paperless/.local/bin/activate`

## 3. Implementation Details

- **Folder Structure**:
  - `/opt/paperless`: Application root
  - `/opt/paperless/consumption`: Input folder (shared via Samba)
  - `/opt/paperless/media`: Document storage
- **Systemd Services**:
  - `paperless-web.service`: Gunicorn via Unix socket
  - `redis.service`, `postgresql.service`: Hardened and isolated
- **Environment Configuration**:
  - `.env` file with socket paths and credentials
  - Redis and PostgreSQL accessed via Unix sockets only

## 4. Optional Enhancements

### Samba Share
- Configured to share `/opt/paperless/consumption` folder
- Accessible to LAN devices for easy document ingestion
- Permissions restricted to Paperless service account

### ImageMagick PDF Support
- Enabled PDF processing by modifying `/etc/ImageMagick-6/policy.xml`
- Allows direct thumbnail generation from PDFs
- Falls back to Ghostscript only if needed

### jbig2enc Encoder
- Compiled from source and installed manually
- Reduces size of generated PDFs via JBIG2 compression
- Used during OCR post-processing

### NLTK Data
- Downloaded Snowball Stemmer, Stopwords, and Punkt tokenizer
- Stored in `/usr/share/nltk_data`
- Enables machine learning features for document classification and tagging

## 5. Security Hardening Measures

### Redis
- Bound to Unix socket only
- Password authentication enabled
- Socket permissions restricted to Paperless service account

### PostgreSQL
- Bound to Unix socket only
- Peer authentication for `paperless` Linux user
- Access restricted via `pg_hba.conf`

### Gunicorn
- Bound to Unix socket only
- Managed via systemd with sandboxing options

### Nginx
- Handles HTTPS via Let's Encrypt
- Redirects HTTP to HTTPS
- Proxies securely to Gunicorn socket

### System User Isolation
- `paperless` user has no shell access
- No password or SSH access permitted

### Systemd Sandboxing
- `ProtectSystem`, `PrivateTmp`, `NoNewPrivileges`
- Resource limits applied (`MemoryMax`, `CPUQuota`)

### Firewall Rules
- Only ports 22, 80, and 443 allowed
- Redis and PostgreSQL TCP ports blocked

### Fail2Ban
- Monitors Nginx logs for brute-force attempts
- Automatically bans suspicious IPs

### Audit Logging
- Enabled via `auditd` for file access and system events
- Logs rotated and managed securely

### Logrotate
- Configured for Paperless logs and system services
- Prevents log overflow and ensures retention

## 📊 Summary Table

| Component            | Configuration Summary                                                  | Security Level |
|----------------------|------------------------------------------------------------------------|----------------|
| **OS (Debian 11)**   | Offline install, tuned swap, clean structure                           | 🟢 Hardened     |
| **Redis**            | Unix socket only, password auth, restricted permissions                | 🟢 Hardened     |
| **PostgreSQL**       | Socket-only, peer auth, locked-down `pg_hba.conf`                      | 🟢 Hardened     |
| **Gunicorn**         | Unix socket only, systemd sandboxing                                   | 🟢 Hardened     |
| **Nginx**            | HTTPS with redirect, reverse proxy to socket                           | 🟢 Hardened     |
| **Python (.local)**  | Virtualenv under `/opt/paperless/.local`, isolated from system         | 🟢 Hardened     |
| **Paperless-ngx**    | Manual install, secure env, verified OCR tools                         | 🟢 Hardened     |
| **Samba Share**      | Shared input folder with restricted access                             | 🟡 Controlled   |
| **ImageMagick PDF**  | Enabled PDF processing for thumbnails                                  | 🟡 Controlled   |
| **jbig2enc**         | Installed manually, used for PDF compression                           | 🟡 Controlled   |
| **NLTK Data**        | Downloaded for ML features, stored securely                            | 🟡 Controlled   |
| **Firewall**         | UFW/iptables with minimal exposure                                     | 🟢 Hardened     |
| **User Accounts**    | No shell, no password, isolated permissions                            | 🟢 Hardened     |
| **Fail2Ban**         | Brute-force protection for Nginx                                       | 🟢 Hardened     |
| **Auditd**           | Tracks file access and system events                                   | 🟢 Hardened     |
| **Logrotate**        | Manages logs for Paperless and system services                         | 🟢 Hardened     |