.PHONY: lint build test run push help

IMAGE_NAME = docker-selenium-lambda
DOCKERFILE = Dockerfile
PYTHON_VERSION ?= 3.14
DOCKER_HUB_USER ?= $(shell echo $$DOCKER_HUB_USER)
DOCKER_HUB_REPO ?= $(shell echo $$DOCKER_HUB_REPO || echo $(IMAGE_NAME))
DOCKER_HUB_TAG ?= latest

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
	@echo "Building Docker image with Python $(PYTHON_VERSION)..."
	docker build --build-arg PYTHON_VERSION=$(PYTHON_VERSION) -t $(IMAGE_NAME):python$(PYTHON_VERSION) .

test: build ## Test Docker image locally
	@echo "Testing Docker image with Python $(PYTHON_VERSION)..."
	docker run --rm -p 9000:8080 $(IMAGE_NAME):python$(PYTHON_VERSION) &
	@sleep 2
	@curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
		-H "Content-Type: application/json" \
		-d '{}' || true
	@docker ps | grep $(IMAGE_NAME) | awk '{print $$1}' | xargs docker stop || true

run: build ## Run Docker container
	@echo "Running container with Python $(PYTHON_VERSION)..."
	docker run --rm -p 9000:8080 $(IMAGE_NAME):python$(PYTHON_VERSION)

push: build ## Push Docker image to Docker Hub
	@if [ -z "$(DOCKER_HUB_USER)" ]; then \
		echo "Error: DOCKER_HUB_USER not set. Set it as environment variable or use: make push DOCKER_HUB_USER=yourusername"; \
		exit 1; \
	fi
	@echo "Tagging image for Docker Hub..."
	docker tag $(IMAGE_NAME):python$(PYTHON_VERSION) $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):python$(PYTHON_VERSION)
	docker tag $(IMAGE_NAME):python$(PYTHON_VERSION) $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):$(PYTHON_VERSION)
	@if [ "$(PYTHON_VERSION)" = "3.14" ]; then \
		docker tag $(IMAGE_NAME):python$(PYTHON_VERSION) $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):latest; \
	fi
	@echo "Pushing to Docker Hub..."
	docker push $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):python$(PYTHON_VERSION)
	docker push $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):$(PYTHON_VERSION)
	@if [ "$(PYTHON_VERSION)" = "3.14" ]; then \
		docker push $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):latest; \
	fi
	@echo "Image pushed successfully: $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):python$(PYTHON_VERSION)"

clean: ## Remove unused Docker images
	@echo "Cleaning Docker images..."
	docker image prune -f
