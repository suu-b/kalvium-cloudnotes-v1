# Deployment


## Environment
Linux Ubuntu 
Python 3.14.4


## Application
Flask
Gunicorn

## Database
psql (PostgreSQL) 18.4 

## Access
0.0.0.0:5000

## Request Path

Browser
   ↓
Host (Ubuntu)
   ↓
Port 5000
   ↓
Gunicorn
   ↓
Flask
   ↓
PostgreSQL

## Service

systemd
   ↓
Gunicorn

