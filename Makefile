.PHONY: up help build down stop start restart clean prune rmi rebuild logs-follow nuke

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
	@echo "  make nuke        - Stop/remove all containers, images, volumes, networks"
	@echo "  make rebuild     - Rebuild images and restart services" 
	@echo "  make logs-follow - Follow service logs in real-time"
	@echo "  make fclean      - Clean all containers, images, and secrets" 
	@echo "  make env         - Copy secrets and environment files"

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
	@if [ -n "$$(docker images -aq)" ]; then \
		docker rmi -f $$(docker images -aq); \
	else \
		echo "No images to remove."; \
	fi

rebuild: down prune build up
	@echo "✓ Services rebuilt and started"

logs-follow:
	$(COMPOSE_CMD) logs -f

nuke:
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true
	@rm -rf .secrets
	@rm -f srcs/.env
	@echo "✓ All containers, images, volumes, networks removed and secrets cleaned"

env:
	@cp -r /home/eandela/Documents/.secrets .
	@cp /home/eandela/Documents/.env ./srcs/.env
	@echo "✓ Secrets and environment files copied"
