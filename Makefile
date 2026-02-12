.PHONY: up help build down stop start restart clean prune rmi rebuild logs-follow

COMPOSE_FILE := srcs/docker-compose.yml
COMPOSE_CMD := docker compose -f $(COMPOSE_FILE)

up:
	$(COMPOSE_CMD) up -d

help:
	@echo "Available targets:"
	@echo "  make up          - Start services in detached mode"
	@echo "  make build       - Build Docker images"
	@echo "  make down        - Stop and remove containers"
	@echo "  make restart     - Restart all services"
	@echo "  make stop        - Stop services without removing them"
	@echo "  make start       - Start stopped services"
	@echo "  make clean       - Remove stopped containers and volumes"
	@echo "  make prune       - Remove all dangling images and containers"
	@echo "  make rmi         - Remove all Docker images"
	@echo "  make rebuild     - Rebuild images and restart services" 
	@echo "  make logs-follow - Follow service logs in real-time"

build:
	$(COMPOSE_CMD) build

down:
	$(COMPOSE_CMD) down

stop:
	$(COMPOSE_CMD) stop

start:
	$(COMPOSE_CMD) start

restart: down up

clean:
	$(COMPOSE_CMD) down -v

prune:
	docker system prune -f

rmi:
	docker rmi -f $$(docker images -aq)

rebuild: down prune build up
	@echo "✓ Services rebuilt and started"

logs-follow:
	$(COMPOSE_CMD) logs -f

env:
	cp -r ../.secrets .
	cp ../.env ./srcs/.env
