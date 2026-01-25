# Inception — Developer Documentation

This document is for developers/administrators who want to set up, build, and operate this project.

The stack is:
- **nginx** (HTTPS reverse proxy on port 443)
- **wordpress** (PHP-FPM app server, internal port 9000)
- **mariadb** (database, internal port 3306)

All containers run on the same Docker network created by Compose.

---

## 1)

### Requirements

Read requirements in README.md. 

## 2) Build and launch

All main commands are in the root `Makefile`.

### 2.1 Build images
```bash
make build
```
-  This also Creates `${DATA_PATH}/mariadb` and `${DATA_PATH}/wordpress` if not present.

### 2.2 Start containers
```bash
make run
```

### 2.3 Build + start
```bash
make
```
This runs `make build` then `make run`.

### 2.4 Rebuild and restart the stack
```bash
make re
```
What it does:
- Stops containers
- Starts containers again

### 2.5 Stop the stack
```bash
make down
```

### 2.6 Full cleanup
```bash
make fclean
```
Notes:
- This removes built images and build cache.
- It prunes unused volumes (it does NOT delete `${DATA_PATH}` by default).

---

## 3) Useful Docker/Compose commands

All commands below assume you run them from the project root.

### 3.1 Check container status
```bash
docker ps
```

### 3.2 View logs
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

### 3.3 Open a shell inside a container
```bash
docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env exec nginx sh
```
For Debian-based containers you can also use `bash` if installed.

### 3.4 Restart a single service
```bash
docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env restart wordpress
```

### 3.5 Remove stopped containers and unused volumes
Safe prune (only unused volumes):
```bash
docker volume prune -f
```

List volumes:
```bash
docker volume ls
```

Inspect a volume (useful for evaluation):
```bash
docker volume inspect <volume>
```

---

## 4) Where data is stored and how it persists

### 4.1 Persistent data locations (host)
Persistent data is stored under:
- `${DATA_PATH}/wordpress` (WordPress files: core, themes, plugins, uploads)
- `${DATA_PATH}/mariadb` (MariaDB database files)

Because these paths are on volumes, deleting/rebuilding containers does **not** delete your site/data.

### 4.3 How to reset data
If you want a completely fresh WordPress + database:
1) Stop containers:
```bash
make fclean
```
2) Delete the host data directories:
```bash
sudo rm -rf `${DATA_PATH}`
```
3) Rebuild and start:
```bash
make
```
