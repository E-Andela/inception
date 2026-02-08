.PHONY: help build up down restart logs clean prune stop start ps

# Variables
COMPOSE_FILE := srcs/docker-compose.yml
COMPOSE_CMD := docker-compose -f $(COMPOSE_FILE)

# Default target
help:
	@echo "Available targets:"
	@echo "  make build       - Build Docker images"
	@echo "  make up          - Start services in detached mode"
	@echo "  make down        - Stop and remove containers"
	@echo "  make restart     - Restart all services"
	@echo "  make stop        - Stop services without removing them"
	@echo "  make start       - Start stopped services"
	@echo "  make ps          - Show running services"
	@echo "  make logs        - Show service logs (use: make logs ARGS='-f service_name')"
	@echo "  make clean       - Remove stopped containers and volumes"
	@echo "  make prune       - Remove all dangling images and containers"
	@echo "  make shell       - Open shell in a service (use: make shell SERVICE=service_name)"
	@echo "  make exec        - Execute command (use: make exec SERVICE=service_name CMD='command')"

# Build images
build:
	$(COMPOSE_CMD) build

# Start services in detached mode
up:
	$(COMPOSE_CMD) up -d

# Stop and remove containers
down:
	$(COMPOSE_CMD) down

# Stop containers
stop:
	$(COMPOSE_CMD) stop

# Start stopped containers
start:
	$(COMPOSE_CMD) start

# Restart services
restart: down up

# Show running services
ps:
	$(COMPOSE_CMD) ps

# View logs
logs:
	$(COMPOSE_CMD) logs $(ARGS)

# Remove stopped containers and volumes
clean:
	$(COMPOSE_CMD) down -v

# Remove dangling images and containers
prune:
	docker system prune -f

# Open shell in a service
shell:
	$(COMPOSE_CMD) exec $(SERVICE) /bin/bash

# Execute command in a service
exec:
	$(COMPOSE_CMD) exec $(SERVICE) $(CMD)

# Full rebuild (clean build from scratch)
rebuild: down prune build up
	@echo "✓ Services rebuilt and started"

# Show services status
status:
	@echo "=== Docker Compose Status ==="
	$(COMPOSE_CMD) ps
	@echo "\n=== Docker Compose Config ==="
	$(COMPOSE_CMD) config

# View service logs with follow
logs-follow:
	$(COMPOSE_CMD) logs -f
