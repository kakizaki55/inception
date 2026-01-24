# Inception — User Documentation

This project runs a small web stack using Docker. It starts these services:

- **Nginx**: the web server (HTTPS on port 443)
- **WordPress (PHP-FPM)**: runs the WordPress application
- **MariaDB**: the database used by WordPress

All services run in containers and communicate over a private Docker network.

---

## Tech stack

### Nginx (HTTPS)
- Listens on **port 443** (https).
- Serves the WordPress site.
- Sends `.php` requests to PHP-FPM in the WordPress container.

### WordPress (PHP-FPM)
- Downloads and installs WordPress automatically on first run .
- Creates the WordPress admin user and a normal user using values from the `.env` file.
- Exposes PHP-FPM on port **9000** to the internal Docker network (not published to the host).

### MariaDB
- Stores all WordPress data.
- Runs only on the Docker network .

---

## 1) Start/stop commands 

from root 
````bash
make
````
````bash
make fclean
````

## 2) Access Website  

Open your browser and go to "https://mkakizak.42.fr"

For admin panel ""https://mkakizak.42.fr/wp-admin"

## 3) Manage credentials

From the admin panal, navigate to user tab and you can add or edit all users. 

## 4) check docker containers

````bash
docker ps
````


