.PHONY: help build up down restart logs ps migrate shell clean

help:
	@echo "PulseFort Commands"
	@echo ""
	@echo "build      Build containers"
	@echo "up         Start stack"
	@echo "down       Stop stack"
	@echo "restart    Restart stack"
	@echo "logs       View logs"
	@echo "ps         List containers"
	@echo "migrate    Run Alembic migrations"
	@echo "shell      Open app shell"
	@echo "clean      Remove containers and volumes"

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

logs:
	docker compose logs -f

ps:
	docker compose ps

migrate:
	docker compose exec app alembic upgrade head

shell:
	docker compose exec app sh

clean:
	docker compose down -v