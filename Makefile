NAME = inception
DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yaml
LOGIN = xquah

all: build start

# Create folders required by subject (host-side persistence path)
create_folder:
	mkdir -p /home/$(LOGIN)/data/mariadb
	mkdir -p /home/$(LOGIN)/data/wordpress

# Build all images from the compose file
build: create_folder
	@docker compose -f $(DOCKER_COMPOSE_FILE) build

# Create and start containers in detached mode
start:
	@docker compose -f $(DOCKER_COMPOSE_FILE) up -d

# Stop running containers without removing them
stop:
	@docker compose -f $(DOCKER_COMPOSE_FILE) stop

# Show service logs
logs:
	@docker compose -f $(DOCKER_COMPOSE_FILE) logs

# Shut down containers and remove them
clean:
	@docker compose -f $(DOCKER_COMPOSE_FILE) down

# Full cleanup: host data, images, containers, orphans, and volumes
fclean:
	@sudo rm -rf /home/$(LOGIN)/data/mariadb
	@sudo rm -rf /home/$(LOGIN)/data/wordpress
	@docker compose -f $(DOCKER_COMPOSE_FILE) down --rmi all --remove-orphans -v

prune:
	@docker system prune -a --volumes

re: fclean all

# Backward-compatible aliases
up: start
down: clean
restart: re

.PHONY: all create_folder build start stop logs clean fclean prune re up down restart
