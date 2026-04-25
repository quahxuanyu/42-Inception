.PHONY: up down build logs clean restart

# Run the application in detached mode
up:
	docker compose -f srcs/docker-compose.yaml up -d

# Stop the application
down:
	docker compose -f srcs/docker-compose.yaml down

# Build the images
build:
	docker compose -f srcs/docker-compose.yaml build

# View logs
logs:
	docker compose -f srcs/docker-compose.yaml logs -f

# Clean up volumes and orphans
clean:
	docker compose -f srcs/docker-compose.yaml down -v --remove-orphans

# Restart the application
restart: down up
