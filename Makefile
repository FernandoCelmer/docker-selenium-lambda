.PHONY: lint build test run help

IMAGE_NAME = lambda-python-314
DOCKERFILE = Dockerfile

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

lint: ## Run Hadolint on Dockerfile
	@echo "Running Hadolint..."
	@if command -v hadolint > /dev/null; then \
		hadolint --config .code_quality/.hadolint.yaml $(DOCKERFILE); \
	else \
		echo "Hadolint not installed. Running via Docker..."; \
		docker run --rm -i -v $(PWD)/.code_quality/.hadolint.yaml:/root/.hadolint.yaml hadolint/hadolint < $(DOCKERFILE); \
	fi

build: lint ## Build Docker image
	@echo "Building Docker image..."
	docker build -t $(IMAGE_NAME) .

test: build ## Test Docker image locally
	@echo "Testing Docker image..."
	docker run --rm -p 9000:8080 $(IMAGE_NAME) &
	@sleep 2
	@curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
		-H "Content-Type: application/json" \
		-d '{}' || true
	@docker ps | grep $(IMAGE_NAME) | awk '{print $$1}' | xargs docker stop || true

run: build ## Run Docker container
	@echo "Running container..."
	docker run --rm -p 9000:8080 $(IMAGE_NAME)

clean: ## Remove unused Docker images
	@echo "Cleaning Docker images..."
	docker image prune -f
