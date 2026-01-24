include ./srcs/.env

all: build run

build:
	# Ensure host data dirs exist for volume backing storage
	mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env build --no-cache

run:
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up -d

re:
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env down --remove-orphans
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env build --no-cache
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up -d

down:
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env down --remove-orphans

fclean: clean
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env down --rmi all --remove-orphans
	# Remove dangling build cache to free disk in small VMs
	docker builder prune -af
	docker volume prune -f
	# If you really want to wipe host data too, uncomment the next line
	# rm -rf $(DATA_PATH)

.PHONY: all down re clean fclean
