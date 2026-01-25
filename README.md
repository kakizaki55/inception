*This project has been created as part of the 42 curriculum by mkakizak.*

# Inception

## Description
This project sets up a small web infrastructure using **Docker Compose**. The goal is to run a complete WordPress stack with:
- **NGINX** as the single public entry point, serving HTTPS only (**TLSv1.2/TLSv1.3**).
- **WordPress + php-fpm** (no nginx inside this container).
- **MariaDB** as the database backend (no nginx inside this container).
- A dedicated **Docker network** connecting containers internally.
- Two persistent **named volumes**:
  - one for the **WordPress database** (MariaDB data files)
  - one for the **WordPress website files** (wp-content/uploads, plugins, themes, etc.)

  ### Virtual Machines vs Docker
  - VMs run full OS per guest; containers share the host kernel.
  - VMs use more resources and start slower; containers are lighter and faster.

  ### Secrets vs Environment Variables
  - Env vars are easy to read; secrets are protected by design.
  - Secrets can be mounted and rotated; env vars last for the container.

  ### Docker Network vs Host Network
  - Host network: uses host stack, no port mapping.
  - Host may be faster; bridge is more portable and safer.

  ### Docker Volumes vs Bind Mounts
  - Volumes: managed by Docker, portable, good for production data.
  - Bind mounts: direct host paths, great for local dev/editing.
  - Volumes work across environments; bind mounts depend on host paths/permissions.
  - Volumes separate app data from host; bind mounts expose host specifics.


## Instructions

### Requirements
Inside the VM you need:
- Docker Engine
- Docker Compose
- sudo privileges

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
- help draft code and readme. to make basic structers that needed to be filled in.
- Used as a Tutor to explain concepts regarding contianers and best practices(and point me in the right direction to start researching).

