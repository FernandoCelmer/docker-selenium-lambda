# Docker Selenium Lambda

[![Docker Lint](https://github.com/FernandoCelmer/docker-selenium-lambda/actions/workflows/docker-lint.yml/badge.svg)](https://github.com/FernandoCelmer/docker-selenium-lambda/actions/workflows/docker-lint.yml)
[![Python](https://img.shields.io/badge/Python-3.9%20%7C%203.10%20%7C%203.11%20%7C%203.12%20%7C%203.13%20%7C%203.14-blue.svg)](https://www.python.org/)
[![Docker](https://img.shields.io/badge/Docker-Latest-blue.svg)](https://www.docker.com/)
[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-fernandocelmer%2Fdocker--selenium--lambda-blue)](https://hub.docker.com/r/fernandocelmer/docker-selenium-lambda)
[![AWS Lambda](https://img.shields.io/badge/AWS-Lambda-orange.svg)](https://aws.amazon.com/lambda/)
[![License](https://img.shields.io/badge/License-GPLv3-green.svg)](LICENSE)

Base Dockerfile for AWS Lambda with multiple Python versions support, including Selenium, Chromium, ChromeDriver, code quality tools and linting.

## Features

- **Multiple Python Versions** - Supports Python 3.9, 3.10, 3.11, 3.12, 3.13, and 3.14
- **Selenium 4.15.2** - Web automation framework
- **Chromium** - Headless browser installed via system package
- **ChromeDriver** - Chrome automation driver (version 131.0.6778.85)
- **Code Quality** - Hadolint for Dockerfile linting
- **CI/CD** - Automated build and push for all Python versions

## Supported Python Versions

- Python 3.9
- Python 3.10
- Python 3.11
- Python 3.12
- Python 3.13
- Python 3.14 (default)

## Commands

```bash
make lint
make build
make build PYTHON_VERSION=3.11
make test
make run
make push DOCKER_HUB_USER=yourusername
```

## Docker Hub

Pre-built images are available on Docker Hub: [fernandocelmer/docker-selenium-lambda](https://hub.docker.com/r/fernandocelmer/docker-selenium-lambda)

### Quick Start

```bash
docker pull fernandocelmer/docker-selenium-lambda:python3.14
docker run -p 9000:8080 fernandocelmer/docker-selenium-lambda:python3.14
```

### Available Tags

All Python versions are available:
```bash
docker pull fernandocelmer/docker-selenium-lambda:python3.9
docker pull fernandocelmer/docker-selenium-lambda:python3.10
docker pull fernandocelmer/docker-selenium-lambda:python3.11
docker pull fernandocelmer/docker-selenium-lambda:python3.12
docker pull fernandocelmer/docker-selenium-lambda:python3.13
docker pull fernandocelmer/docker-selenium-lambda:python3.14
docker pull fernandocelmer/docker-selenium-lambda:latest  # Python 3.14
```

Short version tags:
```bash
docker pull fernandocelmer/docker-selenium-lambda:3.9
docker pull fernandocelmer/docker-selenium-lambda:3.10
docker pull fernandocelmer/docker-selenium-lambda:3.11
docker pull fernandocelmer/docker-selenium-lambda:3.12
docker pull fernandocelmer/docker-selenium-lambda:3.13
docker pull fernandocelmer/docker-selenium-lambda:3.14
```

## Build

Build with default Python version (3.14):
```bash
docker build -t docker-selenium-lambda:python3.14 .
```

Build with specific Python version:
```bash
docker build --build-arg PYTHON_VERSION=3.14 -t docker-selenium-lambda:python3.11 .
```

Or using Makefile:
```bash
make build PYTHON_VERSION=3.14
```

## Test Lambda Function

```bash
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
  -H "Content-Type: application/json" \
  -d '{}'
```

## Selenium Configuration

The Dockerfile includes:
- Chromium browser installed via system package manager (yum)
- ChromeDriver for browser automation (downloaded from Chrome for Testing)
- All required system dependencies for headless browser operation
- Selenium Python package (4.15.2)

The Lambda function is pre-configured with Chromium options optimized for AWS Lambda:
- `--headless` - Run without GUI
- `--no-sandbox` - Required for Lambda environment
- `--disable-dev-shm-usage` - Prevents shared memory issues
- `--disable-gpu` - Disable GPU acceleration
- `--single-process` - Run in single process mode
- `--disable-software-rasterizer` - Disable software rasterizer

## Code Quality

The project uses Hadolint for Dockerfile linting. Configuration is in `.code_quality/.hadolint.yaml`.

GitHub Actions automatically runs linting on push and pull requests.

## Resources

- [Hadolint Documentation](https://hadolint.github.io/hadolint/)
- [AWS Lambda Python Image](https://docs.aws.amazon.com/lambda/latest/dg/python-image.html)
- [Selenium Documentation](https://www.selenium.dev/documentation/)
- [ChromeDriver for Testing](https://googlechromelabs.github.io/chrome-for-testing/)
