include ./srcs/.env

all: build run

build:
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
	docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env down --rmi all --remove-orphans
	# Remove dangling build cache to free disk in small VMs
	docker builder prune -af
	rm -rf $(DATA_PATH)

.PHONY: all down re clean fclean
