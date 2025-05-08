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
git clone https://github.com/mchliyah/home_lab.git
cd home-lab

2.2 Create .env file:
.env
\# Database
DB_NAME=nextcloud
DB_USER=nextcloud_user
DB_PASS=secure_password_here
DOMAIN_NAME=yourdomain.com
DB_ROOT_PASSWORD=root_pasword
DB_HOST=db_host

\# Nextcloud Admin
ADMIN_USER=yuou admin user name 
ADMIN_PASS=your admin password
ADMIN_EMAIL=admin mail

\# Domains
DOMAIN_NAME=domain_name1
DOMAIN_NAME2=domain_name2

\# Email Configuration
EMAIL_SMTP_HOST=smtp.mail
EMAIL_SMTP_PORT=<port based on what you use >
EMAIL_SMTP_USER=user_mail
EMAIL_SMTP_PASSWORD=aplication password 
DEFAULT_PHONE_REGION=MA  # Maroc (ISO 3166-1) look for yours 

\#change to youre default language
DEFAULT_LANG=en 

\# Network

HOST_IP=<ip ansible host >
\# Ansible (optionnel)
ANSIBLE_USER=ansible_user
ANSIBLE_SSH_PRIVATE_KEY_FILE=ssh key added to ansible 

3. Build and Start Services
---------------------------
3.1 Build containers:
docker-compose build

3.2 Start services:
docker-compose up -d

or just use the make up 

4. Post-Install Configuration
-----------------------------
4.1 Configure Nextcloud:
docker exec nextcloud /update-config.sh


5. Maintenance Commands
-----------------------
5.1 Stop all services:
docker-compose down 
or make down

5.2 Backup database:

docker exec mariadb mysqldump -u root -p\${DB_PASS} --all-databases > backup.sql

6 migration: 
-------------------------------------------

migration steps will be coverd soon (maybe) 

-------------------------------------------

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
