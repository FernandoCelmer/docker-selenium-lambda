.PHONY: lint build build-chromium build-firefox build-tor test test-chromium test-firefox test-tor run run-chromium run-firefox run-tor push push-chromium push-firefox push-tor help

IMAGE_NAME = docker-selenium-lambda
DOCKERFILE = Dockerfile
PYTHON_VERSION ?= 3.14
BROWSER ?= chromium
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

build: lint ## Build Docker image (default: chromium)
	@echo "Building Docker image with $(BROWSER)..."
	@docker build --build-arg PYTHON_VERSION=$(PYTHON_VERSION) --build-arg BROWSER=$(BROWSER) -t $(IMAGE_NAME):$(BROWSER) -t $(IMAGE_NAME):latest .

build-chromium: lint ## Build Docker image with Chromium
	@echo "Building Docker image with Chromium..."
	@docker build --build-arg PYTHON_VERSION=$(PYTHON_VERSION) --build-arg BROWSER=chromium -t $(IMAGE_NAME):chromium -t $(IMAGE_NAME):latest .

build-firefox: lint ## Build Docker image with Firefox
	@echo "Building Docker image with Firefox..."
	@docker build --build-arg PYTHON_VERSION=$(PYTHON_VERSION) --build-arg BROWSER=firefox -t $(IMAGE_NAME):firefox .

build-tor: lint ## Build Docker image with Tor Browser
	@echo "Building Docker image with Tor Browser..."
	@docker build --build-arg PYTHON_VERSION=$(PYTHON_VERSION) --build-arg BROWSER=tor -t $(IMAGE_NAME):tor .

test: build ## Test Docker image locally
	@echo "Testing Docker image with $(BROWSER)..."
	docker run --rm -p 9000:8080 -e BROWSER=$(BROWSER) $(IMAGE_NAME):$(BROWSER) &
	@sleep 2
	@curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
		-H "Content-Type: application/json" \
		-d '{}' || true
	@docker ps | grep $(IMAGE_NAME) | awk '{print $$1}' | xargs docker stop || true

test-chromium: build-chromium ## Test Chromium Docker image locally
	@echo "Testing Chromium Docker image..."
	docker run --rm -p 9000:8080 -e BROWSER=chromium $(IMAGE_NAME):chromium &
	@sleep 2
	@curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
		-H "Content-Type: application/json" \
		-d '{}' || true
	@docker ps | grep $(IMAGE_NAME) | awk '{print $$1}' | xargs docker stop || true

test-firefox: build-firefox ## Test Firefox Docker image locally
	@echo "Testing Firefox Docker image..."
	docker run --rm -p 9000:8080 -e BROWSER=firefox $(IMAGE_NAME):firefox &
	@sleep 2
	@curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
		-H "Content-Type: application/json" \
		-d '{}' || true
	@docker ps | grep $(IMAGE_NAME) | awk '{print $$1}' | xargs docker stop || true

test-tor: build-tor ## Test Tor Browser Docker image locally
	@echo "Testing Tor Browser Docker image..."
	docker run --rm -p 9000:8080 -e BROWSER=tor $(IMAGE_NAME):tor &
	@sleep 2
	@curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
		-H "Content-Type: application/json" \
		-d '{}' || true
	@docker ps | grep $(IMAGE_NAME) | awk '{print $$1}' | xargs docker stop || true

run: build ## Run Docker container
	@echo "Running container with $(BROWSER)..."
	docker run --rm -p 9000:8080 -e BROWSER=$(BROWSER) $(IMAGE_NAME):$(BROWSER)

run-chromium: build-chromium ## Run Chromium Docker container
	@echo "Running Chromium container..."
	docker run --rm -p 9000:8080 -e BROWSER=chromium $(IMAGE_NAME):chromium

run-firefox: build-firefox ## Run Firefox Docker container
	@echo "Running Firefox container..."
	docker run --rm -p 9000:8080 -e BROWSER=firefox $(IMAGE_NAME):firefox

run-tor: build-tor ## Run Tor Browser Docker container
	@echo "Running Tor Browser container..."
	docker run --rm -p 9000:8080 -e BROWSER=tor $(IMAGE_NAME):tor

push: build ## Push Docker image to Docker Hub
	@if [ -z "$(DOCKER_HUB_USER)" ]; then \
		echo "Error: DOCKER_HUB_USER not set. Set it as environment variable or use: make push DOCKER_HUB_USER=yourusername"; \
		exit 1; \
	fi
	@echo "Tagging image for Docker Hub..."
	docker tag $(IMAGE_NAME):$(BROWSER) $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):$(BROWSER)
	@if [ "$(BROWSER)" = "chromium" ]; then \
		docker tag $(IMAGE_NAME):chromium $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):latest; \
	fi
	@echo "Pushing to Docker Hub..."
	docker push $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):$(BROWSER)
	@if [ "$(BROWSER)" = "chromium" ]; then \
		docker push $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):latest; \
	fi
	@echo "Image pushed successfully: $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):$(BROWSER)"

push-chromium: build-chromium ## Push Chromium Docker image to Docker Hub
	@if [ -z "$(DOCKER_HUB_USER)" ]; then \
		echo "Error: DOCKER_HUB_USER not set"; \
		exit 1; \
	fi
	@echo "Tagging Chromium image for Docker Hub..."
	docker tag $(IMAGE_NAME):chromium $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):chromium
	docker tag $(IMAGE_NAME):chromium $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):latest
	@echo "Pushing to Docker Hub..."
	docker push $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):chromium
	docker push $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):latest
	@echo "Chromium image pushed successfully"

push-firefox: build-firefox ## Push Firefox Docker image to Docker Hub
	@if [ -z "$(DOCKER_HUB_USER)" ]; then \
		echo "Error: DOCKER_HUB_USER not set"; \
		exit 1; \
	fi
	@echo "Tagging Firefox image for Docker Hub..."
	docker tag $(IMAGE_NAME):firefox $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):firefox
	@echo "Pushing to Docker Hub..."
	docker push $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):firefox
	@echo "Firefox image pushed successfully"

push-tor: build-tor ## Push Tor Browser Docker image to Docker Hub
	@if [ -z "$(DOCKER_HUB_USER)" ]; then \
		echo "Error: DOCKER_HUB_USER not set"; \
		exit 1; \
	fi
	@echo "Tagging Tor Browser image for Docker Hub..."
	docker tag $(IMAGE_NAME):tor $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):tor
	@echo "Pushing to Docker Hub..."
	docker push $(DOCKER_HUB_USER)/$(DOCKER_HUB_REPO):tor
	@echo "Tor Browser image pushed successfully"

clean: ## Remove unused Docker images
	@echo "Cleaning Docker images..."
	docker image prune -f
