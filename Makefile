.PHONY: help build up down clean

# Default target: print available commands
help:
	@echo "Available commands:"
	@echo "  make build   - Build all service images defined in docker-compose.yaml"
	@echo "  make up      - Start all services in the foreground"
	@echo "  make down    - Stop and remove all running service containers"
	@echo "  make clean   - Remove dangling (unused) Docker images to free disk space"

# Build all service images defined in docker-compose.yaml
build:
	docker compose build

# Start all services in the background
up:
	docker compose up -d

# Stop and remove all running service containers
down:
	docker compose down

# Remove dangling (unused) Docker images to free disk space
clean:
	docker image prune -f
