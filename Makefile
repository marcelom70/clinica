.PHONY: build run stop test init-db clean logs shell help

# Docker image and container names
IMAGE_NAME=clinica-app
CONTAINER_NAME=clinica-app
DB_CONTAINER_NAME=clinica-db
NETWORK_NAME=clinica-network

# Default port
PORT=8000

help:
	@echo "Available commands:"
	@echo "  make build       - Build Docker image"
	@echo "  make run         - Run application in Docker container"
	@echo "  make stop        - Stop and remove containers"
	@echo "  make test        - Run tests"
	@echo "  make init-db     - Initialize database with schema"
	@echo "  make clean       - Remove all containers and images"
	@echo "  make logs        - View application logs"
	@echo "  make shell       - Open shell in the container"

build:
	docker build -t $(IMAGE_NAME) .

network:
	docker network create $(NETWORK_NAME) || true

db:
	docker run --name $(DB_CONTAINER_NAME) \
		--network $(NETWORK_NAME) \
		-e POSTGRES_PASSWORD=1234 \
		-e POSTGRES_DB=clinica_medica_dev \
		-d postgres:14-alpine

run: network db
	docker run --name $(CONTAINER_NAME) \
		--network $(NETWORK_NAME) \
		-p $(PORT):8000 \
		-e DATABASE_URL=postgresql://postgres:1234@$(DB_CONTAINER_NAME):5432/clinica_medica_dev \
		-d $(IMAGE_NAME)
	@echo "Application running at http://localhost:$(PORT)"

stop:
	docker stop $(CONTAINER_NAME) $(DB_CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) $(DB_CONTAINER_NAME) || true

test:
	docker exec $(CONTAINER_NAME) python -m pytest

init-db:
	docker exec $(CONTAINER_NAME) python src/utils/init_db.py

clean: stop
	docker rmi $(IMAGE_NAME) || true
	docker network rm $(NETWORK_NAME) || true

logs:
	docker logs -f $(CONTAINER_NAME)

shell:
	docker exec -it $(CONTAINER_NAME) /bin/bash

# Create a requirements.txt file if it doesn't exist
requirements.txt:
	@echo "Creating requirements.txt file..."
	@echo "fastapi==0.95.0" > requirements.txt
	@echo "uvicorn==0.21.1" >> requirements.txt
	@echo "asyncpg==0.27.0" >> requirements.txt
	@echo "python-dotenv==1.0.0" >> requirements.txt
	@echo "pytest==7.3.1" >> requirements.txt
	@echo "pytest-asyncio==0.21.0" >> requirements.txt
	@echo "httpx==0.24.0" >> requirements.txt
	@echo "pydantic==1.10.7" >> requirements.txt
	@echo "pydantic[email]==1.10.7" >> requirements.txt
	@echo "jinja2==3.1.2" >> requirements.txt