============================================
Home Lab Setup Guide - Step by Step
============================================

1. System Requirements
-----------------------
- Linux server (Ubuntu 22.04 recommended)
- Docker 20.10+ installed
- Docker Compose 2.0+
- Domain name with DNS pointing to your IP
- Ports 80, 443, 8443, and 5000-5150 open

2. Initial Setup
----------------
2.1 Clone repository:
git clone https://github.com/mchliyah/home-lab.git
cd home-lab

2.2 Create .env file:
.env
DB_NAME=nextcloud
DB_USER=nextcloud_user
DB_PASS=secure_password_here
DOMAIN_NAME=yourdomain.com

3. Build and Start Services
---------------------------
3.1 Build containers:
docker-compose build

3.2 Start services:
docker-compose up -d

or ust use the make up 

4. Post-Install Configuration
-----------------------------
4.1 Configure Nextcloud:
docker exec nextcloud /update-config.sh


5. Maintenance Commands
-----------------------
5.1 Stop all services:
docker-compose down | make down


5.2 Backup database:
docker exec mariadb mysqldump -u root -p\${DB_PASS} --all-databases > backup.sql

7. Access Services
------------------
7.1 Nextcloud: https://yourdomain.com
7.2 Traccar: http://yourdomain.com
7.3 Admin credentials (change immediately) if it not sat by the env:
   Username: admin
   Password: admin

8. Troubleshooting
------------------
8.1 Check logs:
docker-compose logs -f

8.2 Reset permissions:
docker exec nextcloud chown -R www-data:www-data /var/www/html

8.3 Test database connection:
docker exec mariadb mysql -u \${DB_USER} -p\${DB_PASS} -e "SHOW DATABASES;"

============================================
