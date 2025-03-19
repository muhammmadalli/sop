# Deploy SMSC.io
> SMSC Open Source Solution with Monitoring, Billing, SMPP, SS7 and REST API support.
> Provided as Open Source Repo at [text](https://github.com/bulktrade/SMSC#)

## Steps to undertake
1. Prepare a Ubuntu Server Machine.
2. Update and Upgrade, preferably using apt
3. Go to the folder of your choice.
4. Run the following commands as sudo: -

```bash
apt update && apt install git
git clone [text](https://github.com/bulktrade/SMSC.git)
```

## Start admin module

### Installation
* `cd modules/admin`
* `npm install`

### Serve
* `npm start` 

> go to [http://0.0.0.0:3000](http://0.0.0.0:3000) or [http://localhost:3000](http://localhost:3000) in your browser

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