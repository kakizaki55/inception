include ./srcs/.env

all: build run

build:
	# mkdir -p $(DATA_PATH)/mariadb
	# mkdir -p $(DATA_PATH)/wordpress 
	# echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee -a /etc/hosts
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env build --no-cache

run:
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up -d

re:
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env down --remove-orphans
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env build --no-cache
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up -d

clean:
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env down --remove-orphans

fclean: clean
	# Remove named volumes belonging to this compose project (wipes WP files + DB)
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env down -v --remove-orphans
	# Remove images built for this project
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env down --rmi all --remove-orphans
	# Remove dangling build cache to free disk in small VMs
	docker builder prune -af

.PHONY: all down re clean fclean
