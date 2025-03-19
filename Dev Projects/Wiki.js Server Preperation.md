# WikiJS Server Deployment 
## Update the machine

### Fetch latest updates

`sudo apt -qqy update`

### Install all updates automatically

`sudo DEBIAN_FRONTEND=noninteractive apt-get -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' dist-upgrade`

## Install Docker

### Install dependencies to install Docker

`sudo apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install ca-certificates curl gnupg lsb-release`

### Register Docker package registry

```plaintext
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### Refresh package udpates and install Docker

```plaintext
sudo apt -qqy update
sudo apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install ca-certificates curl gnupg lsb-release
```

## Setup Containers

### Create installation directory for Wiki.js

`mkdir -p /etc/wiki`

### Generate DB secret

`openssl rand -base64 32 > /etc/wiki/.db-secret`

### Create internal docker network

`docker network create wikinet`

### Create data volume for PostgreSQL

`docker volume create pgdata`

### Create the containers

```plaintext
docker create --name=db -e POSTGRES_DB=wiki -e POSTGRES_USER=wiki -e POSTGRES_PASSWORD_FILE=/etc/wiki/.db-secret -v /etc/wiki/.db-secret:/etc/wiki/.db-secret:ro -v pgdata:/var/lib/postgresql/data --restart=unless-stopped -h db --network=wikinet postgres:15
docker create --name=wiki -e DB_TYPE=postgres -e DB_HOST=db -e DB_PORT=5432 -e DB_PASS_FILE=/etc/wiki/.db-secret -v /etc/wiki/.db-secret:/etc/wiki/.db-secret:ro -e DB_USER=wiki -e DB_NAME=wiki -e UPGRADE_COMPANION=1 --restart=unless-stopped -h wiki --network=wikinet -p 80:3000 -p 443:3443 ghcr.io/requarks/wiki:2
docker create --name=wiki-update-companion -v /var/run/docker.sock:/var/run/docker.sock:ro --restart=unless-stopped -h wiki-update-companion --network=wikinet ghcr.io/requarks/wiki-update-companion:latest
```

## Setup Firewall

```plaintext
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw --force enable
```

## Start the containers

```plaintext
docker start db
docker start wiki
docker start wiki-update-companion
```

## For Certificates from Let's Encrypt

```plaintext
docker stop wiki
docker rm wiki
docker create --name=wiki -e LETSENCRYPT_DOMAIN=wikisop.lte.paf.mil -e LETSENCRYPT_EMAIL=muhammmadali@yahoo.com -e SSL_ACTIVE=1 -e DB_TYPE=postgres -e DB_HOST=db -e DB_PORT=5432 -e DB_PASS_FILE=/etc/wiki/.db-secret -v /etc/wiki/.db-secret:/etc/wiki/.db-secret:ro -e DB_USER=wiki -e DB_NAME=wiki -e UPGRADE_COMPANION=1 --restart=unless-stopped -h wiki --network=wikinet -p 80:3000 -p 443:3443 ghcr.io/requarks/wiki:2
docker start wiki
docker logs wiki
```

## Details of Current Implementation

muhammmadali@lte.paf.mil

https://wikisop.lte.paf.mil

### Create use self-signed certificates for HTTPS 

```plaintext
mkdir -p /etc/ssl/wikijs
cd /etc/ssl/wikijs

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
   -keyout wikijs.key -out wikijs.crt \
   -subj "/C=PK/ST=Punjab/L=Rawalpindi/O=PAF/CN=wikisop.lte.paf.mil"
```

### Create Docker container with mounted certificates

#### Stop and Remove Previous Docker Container

```plaintext
docker stop wiki
docker rm wiki
```

#### Create New Container

```plaintext
docker create --name=wiki -v /etc/ssl/wikijs:/wiki/certs -e WIKI_TLS_KEY=/wiki/certs/wikijs.key -e WIKI_TLS_CERT=/wiki/certs/wikijs.crt -e SSL_ACTIVE=1 -e DB_TYPE=postgres -e DB_HOST=db -e DB_PORT=5432 -e DB_PASS_FILE=/etc/wiki/.db-secret -v /etc/wiki/.db-secret:/etc/wiki/.db-secret:ro -e DB_USER=wiki -e DB_NAME=wiki -e UPGRADE_COMPANION=1 --restart=unless-stopped -h wiki --network=wikinet -p 80:3000 -p 443:3443 ghcr.io/requarks/wiki:2
```

####  Start the container and enter it as root user

```plaintext
docker start wiki
docker exec -it --user root wiki /bin/sh
```

#### Assign correct permissions to SSL certificate and key

```plaintext
chmod 644 /wiki/certs/wikijs.*
```

#### Open and edit CONFIG.YML file in the docker

```plaintext
vi /wiki/config.yml
```

Set the ssl configurations as provided below

```xml
ssl:
  enabled: true
  port: 3443
  provider: custom
  format: pem
  key: /wiki/certs/wikijs.key
  cert: /wiki/certs/wikijs.crt
  passphrase: null
  dhparam: null
```

### Restart the container

```plaintext
docker restart wiki
docker logs wiki
```

The following logs (if appeared) mean that the correct HTTPS configuration were successfully applied.

```plaintext
2025-03-16T19:40:39.353Z [MASTER] info: =======================================
2025-03-16T19:40:39.354Z [MASTER] info: = Wiki.js 2.5.306 =====================
2025-03-16T19:40:39.355Z [MASTER] info: =======================================
2025-03-16T19:40:39.355Z [MASTER] info: Initializing...
2025-03-16T19:40:39.730Z [MASTER] info: Using database driver pg for postgres [ OK ]
2025-03-16T19:40:39.734Z [MASTER] info: Connecting to database...
2025-03-16T19:40:39.757Z [MASTER] info: Database Connection Successful [ OK ]
2025-03-16T19:40:40.176Z [MASTER] warn: Mail is not setup! Please set the configuration in the administration area!
2025-03-16T19:40:40.233Z [MASTER] info: Loading GraphQL Schema...
2025-03-16T19:40:40.861Z [MASTER] info: GraphQL Schema: [ OK ]
2025-03-16T19:40:41.079Z [MASTER] info: HTTP Server on port: [ 3000 ]
2025-03-16T19:40:41.090Z [MASTER] info: HTTPS Server on port: [ 3443 ]
2025-03-16T19:40:41.133Z [MASTER] info: HTTP Server: [ RUNNING ]
2025-03-16T19:40:41.134Z [MASTER] info: HTTPS Server: [ RUNNING ]
2025-03-16T19:40:41.247Z [MASTER] info: No new analytics providers found: [ SKIPPED ]
2025-03-16T19:40:41.273Z [MASTER] info: Loaded 21 authentication strategies: [ OK ]
2025-03-16T19:40:41.282Z [MASTER] info: No new comment providers found: [ SKIPPED ]
2025-03-16T19:40:41.293Z [MASTER] info: No new editors found: [ SKIPPED ]
2025-03-16T19:40:41.315Z [MASTER] info: No new loggers found: [ SKIPPED ]
2025-03-16T19:40:41.360Z [MASTER] info: No new renderers found: [ SKIPPED ]
2025-03-16T19:40:41.374Z [MASTER] info: No new search engines found: [ SKIPPED ]
2025-03-16T19:40:41.392Z [MASTER] info: No new storage targets found: [ SKIPPED ]
2025-03-16T19:40:41.392Z [MASTER] info: Checking for installed optional extensions...
2025-03-16T19:40:41.399Z [MASTER] info: Optional extension git is installed. [ OK ]
2025-03-16T19:40:41.401Z [MASTER] info: Optional extension pandoc was not found on this system. [ SKIPPED ]
2025-03-16T19:40:41.403Z [MASTER] info: Optional extension puppeteer was not found on this system. [ SKIPPED ]
2025-03-16T19:40:41.404Z [MASTER] info: Optional extension sharp was not found on this system. [ SKIPPED ]
2025-03-16T19:40:41.407Z [MASTER] info: Authentication Strategy Local: [ OK ]
```