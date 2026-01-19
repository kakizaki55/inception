*This project has been created as part of the 42 curriculum by mkakizak.*

# Inception (42)

## Description
This project sets up a small web infrastructure using **Docker Compose**. The goal is to run a complete WordPress stack with:
- **NGINX** as the single public entry point, serving HTTPS only (**TLSv1.2/TLSv1.3**).
- **WordPress + php-fpm** (no nginx inside this container).
- **MariaDB** as the database backend (no nginx inside this container).
- A dedicated **Docker network** connecting containers internally.
- Two persistent **named volumes**:
  - one for the **WordPress database** (MariaDB data files)
  - one for the **WordPress website files** (wp-content/uploads, plugins, themes, etc.)


## Instructions

### Requirements
Inside the VM you need:
- Docker Engine
- Docker Compose (plugin or legacy `docker-compose`)
- sudo privileges

Check:
```bash
docker --version
docker compose version || docker-compose --version
```

## Setup

### Create the environment file:
Create `srcs/.env` Example keys:
```bash
    DATA_PATH=**************
    DOMAIN_NAME=**************

    MARIA_DB_HOSTNAME=**************
    MARIA_DB_DATABASE=**************
    MARIA_DB_USER=**************
    MARIA_DB_PASSWORD=**************
    MARIA_DB_ROOT_PASSWORD=**************

    WP_ADMIN=**************
    WP_ADMIN_PASSWORD=**************
    WP_ADMIN_EMAIL=**************

    WP_USER=m**************
    WP_USER_PASSWORD=**************
    WP_USER_EMAIL=**************
```

### Build & Run
From the repository root:
```bash
make build
make run
```

Or in one step:
```bash
make
```

Rebuild everything:
```bash
make re
```

Stop services:
```bash
make clean
```

Remove services + images + volumes (wipes WordPress files + DB):
```bash
make fclean
```

---

## Verification / Evaluation Commands

### 1) Containers are running
```bash
docker ps
docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env ps
```

### 2) Only nginx is exposed publicly (443 only)
```bash
docker port nginx
ss -tulpen | grep -E ':443\b' || true
```

### 3) Network is configured
```bash
docker network ls | grep srcs_
docker network inspect srcs_network | sed -n '1,160p'
```

### 4) Volumes exist and are attached
```bash
docker volume ls | grep -E 'wordpress|mariadb'
docker inspect wordpress --format '{{json .Mounts}}' | sed 's/},/},\n/g'
docker inspect mariadb   --format '{{json .Mounts}}' | sed 's/},/},\n/g'
```

### 5) WordPress files exist in the WordPress volume
```bash
docker exec -it wordpress sh -lc 'ls -la /var/www/html | head -n 50'
docker exec -it nginx sh -lc 'ls -la /var/www/html | head -n 50'
```

### 6) MariaDB is reachable from WordPress
```bash
docker exec -it wordpress sh -lc 'mysqladmin ping -h"$MARIA_DB_HOSTNAME" -u"$MARIA_DB_USER" -p"$MARIA_DB_PASSWORD" --silent && echo "DB OK"'
```

### 7) Verify WordPress database users (admin + regular user)
If `wp-cli` is installed in the WordPress container:
```bash
docker exec -it wordpress sh -lc 'wp user list --allow-root'
```

### 8) Persistence check (volumes survive container recreation)
```bash
docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env down
docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up -d
```
Then confirm WP still installed (users still exist) and DB still contains data.

### 9) Restart policy check (crash recovery)
```bash
docker kill wordpress
sleep 2
docker ps | grep wordpress
```

---

## Resources

### Docker / Compose
- Docker Docs (overview): https://docs.docker.com/get-started/
- Dockerfile reference: https://docs.docker.com/reference/dockerfile/
- Compose file reference: https://docs.docker.com/compose/compose-file/
- Docker networking overview: https://docs.docker.com/network/
- Docker volumes overview: https://docs.docker.com/storage/volumes/

### NGINX + TLS
- NGINX documentation: https://nginx.org/en/docs/
- NGINX SSL/TLS basics: https://nginx.org/en/docs/http/configuring_https_servers.html

### WordPress + php-fpm
- WordPress documentation: https://wordpress.org/documentation/
- WP-CLI: https://developer.wordpress.org/cli/commands/
- PHP-FPM configuration: https://www.php.net/manual/en/install.fpm.php

### MariaDB
- MariaDB documentation: https://mariadb.com/kb/en/documentation/

### AI usage disclosure
AI (GitHub Copilot) was used to:
- help draft and refine the README structure
- suggest verification commands for docker/compose, networking, TLS checks
