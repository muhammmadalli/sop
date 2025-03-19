# Deploy SMSC.io
> SMSC Open Source Solution with Monitoring, Billing, SMPP, SS7 and REST API support.
> Provided as Open Source Repo at [text](https://github.com/bulktrade/SMSC#)

## Steps to undertake
1. Prepare a **Debian** / Ubuntu Server Machine.
2. Update and Upgrade, preferably using `apt`
3. Go to the folder of your choice.
4. Run the following commands as sudo: -

```bash
apt update && apt install git npm graphicsmagick python3 python3-pip python-is-python3 2to3 build-essential software-properties-common
echo 'export PYTHON=$(which python3)' >> ~/.bashrc
source ~/.bashrc
git clone https://github.com/bulktrade/SMSC.git
cd SMSC
nano /etc/apt/sources.list
```
Add the following repos in the `/etc/apt/sources.list` file
```cpp
deb http://deb.debian.org/debian/ bookworm main contrib non-free
deb http://security.debian.org/debian-security bookworm-security main contrib non-free
deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free
deb http://deb.debian.org/debian/ bookworm-backports main contrib non-free
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
```

```bash
apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev \
  libssl-dev libreadline-dev libffi-dev wget -y
cd /usr/src
wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
tar -xvzf Python-2.7.18.tgz
cd Python-2.7.18
./configure --enable-optimizations
make -j$(nproc)
make altinstall
ln -s /usr/local/bin/python2.7 /usr/bin/python2
python2.7 --version
```

## Start admin module

### Installation
* `cd modules/admin`
* `npm install`

> If the above method fails with errors, use ` npm install --legacy-peer-deps`

#### Solution 1: Manually Install PhantomJS
Try installing PhantomJS manually before running npm install again:

```bash
sudo apt update
sudo apt install phantomjs -y
phantomjs --version
```
After verifying that it's installed, retry:

`npm install`


#### Solution 2: Use an Alternative Installation for PhantomJS
> If installing via apt doesn't work, use npm to install it separately:

```bash
npm install -g phantomjs-prebuilt
npm install -g node-gyp
```

Then, retry:

`npm install`

### Serve
* `npm start` 

> go to [http://0.0.0.0:3000](http://0.0.0.0:3000) or [http://localhost:3000](http://localhost:3000) in your browser of the server machine.
> Or go to http://<server-ip>:3000 from another browser.

### Admin module credentials
	
	Username: admin
	Password: admin
	URL: /admin
	
## Start core module

### Start Spring boot application
* `cd modules/core`
* `mvn spring-boot:run`

### Receive access and refresh tokens
 POST request on [http://localhost:8080/rest/auth/token](http://localhost:8080/rest/auth/token) with valid credentials
 
### Admin credentials
 
	Username: admin
	Password: admin
	
### User credentials

	Username: user
	Password: password
	
### Docker images launching

* PostgreSQL   
`$ docker run -d -p 5432:5432 -e POSTGRESQL_USER=test -e POSTGRESQL_PASS=oe9jaacZLbR9pN 
-e POSTGRESQL_DB=smsc orchardup/postgresql` 
* MySQL   
`$ docker run -p 3306:3306 -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=smsc 
-e MYSQL_USER=user -e MYSQL_PASSWORD=password -d mysql:latest` 
* Oracle  
`$ docker run -d --shm-size=2g -p 1521:1521 alexeiled/docker-oracle-xe-11g` 

### HAL Browser

    /rest/repository/browser/index.html

### Default application properties (can be changed through system properties (use -D))
* `smsc.database.dialect = postgresql` - database, which is used (other options - mysql, oracle, hsqldb, h2)
* `encrypt.key = smsc.io` - used in password encryption
* `jwt.header = X-Authorization` - name of request header, which is used for JWT authentication
* `jwt.secret = smsc.io` - used in access token signature
* `jwt.expiration = 3600` - lifetime of access token (seconds).