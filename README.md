# Docker Selenium Lambda

[![Docker Lint](https://github.com/FernandoCelmer/docker-selenium-lambda/actions/workflows/docker-lint.yml/badge.svg)](https://github.com/FernandoCelmer/docker-selenium-lambda/actions/workflows/docker-lint.yml)
[![Python](https://img.shields.io/badge/Python-3.14-blue.svg)](https://www.python.org/)
[![Docker](https://img.shields.io/badge/Docker-Latest-blue.svg)](https://www.docker.com/)
[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-fernandocelmer%2Fdocker--selenium--lambda-blue)](https://hub.docker.com/r/fernandocelmer/docker-selenium-lambda)
[![AWS Lambda](https://img.shields.io/badge/AWS-Lambda-orange.svg)](https://aws.amazon.com/lambda/)
[![License](https://img.shields.io/badge/License-GPLv3-green.svg)](LICENSE)

Base Dockerfile for AWS Lambda with Python 3.14, including Selenium with Chromium and Firefox support, code quality tools and linting.

## Features

- **Python 3.14** - Latest Python version with build argument support
- **Selenium 4.15.2** - Web automation framework
- **Chromium** - Headless browser (version 131.0.6778.85) with ChromeDriver
- **Firefox** - Headless browser with GeckoDriver
- **Tor Browser** - Privacy-focused browser with Tor network support
- **Multiple Browser Support** - Separate Docker tags for Chromium, Firefox, and Tor
- **Code Quality** - Hadolint for Dockerfile linting
- **CI/CD** - Automated build and push for all browsers

## Commands

### Chromium
```bash
make lint
make build-chromium
make test-chromium
make run-chromium
make push-chromium DOCKER_HUB_USER=yourusername
```

### Firefox
```bash
make lint
make build-firefox
make test-firefox
make run-firefox
make push-firefox DOCKER_HUB_USER=yourusername
```

### Tor Browser
```bash
make lint
make build-tor
make test-tor
make run-tor
make push-tor DOCKER_HUB_USER=yourusername
```

### Generic (defaults to Chromium)
```bash
make build BROWSER=chromium
make build BROWSER=firefox
make build BROWSER=tor
make test BROWSER=chromium
make run BROWSER=chromium
```

## Docker Hub

Pre-built images are available on Docker Hub: [fernandocelmer/docker-selenium-lambda](https://hub.docker.com/r/fernandocelmer/docker-selenium-lambda)

### Quick Start

**Chromium (default):**
```bash
docker pull fernandocelmer/docker-selenium-lambda:latest
docker run -p 9000:8080 -e BROWSER=chromium fernandocelmer/docker-selenium-lambda:latest
```

**Firefox:**
```bash
docker pull fernandocelmer/docker-selenium-lambda:firefox
docker run -p 9000:8080 -e BROWSER=firefox fernandocelmer/docker-selenium-lambda:firefox
```

**Tor Browser:**
```bash
docker pull fernandocelmer/docker-selenium-lambda:tor
docker run -p 9000:8080 -e BROWSER=tor fernandocelmer/docker-selenium-lambda:tor
```

### Available Tags

**Chromium:**
```bash
docker pull fernandocelmer/docker-selenium-lambda:latest
docker pull fernandocelmer/docker-selenium-lambda:chromium
```

**Firefox:**
```bash
docker pull fernandocelmer/docker-selenium-lambda:firefox
```

**Tor Browser:**
```bash
docker pull fernandocelmer/docker-selenium-lambda:tor
```

**Tag Descriptions:**
- `latest` - Chromium browser (default tag)
- `chromium` - Chromium browser
- `firefox` - Firefox browser
- `tor` - Tor Browser with Tor network support

## Build

**Chromium:**
```bash
docker build --build-arg BROWSER=chromium -t docker-selenium-lambda:chromium .
```

**Firefox:**
```bash
docker build --build-arg BROWSER=firefox -t docker-selenium-lambda:firefox .
```

**Tor Browser:**
```bash
docker build --build-arg BROWSER=tor -t docker-selenium-lambda:tor .
```

**Using Makefile:**
```bash
make build-chromium
make build-firefox
make build-tor
make build BROWSER=chromium
make build BROWSER=firefox
make build BROWSER=tor
```

## Test Lambda Function

```bash
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
  -H "Content-Type: application/json" \
  -d '{}'
```

## Selenium Configuration

The Dockerfile includes:
- **Chromium**: Chrome for Testing (v131.0.6778.85) with ChromeDriver
- **Firefox**: Latest Firefox with GeckoDriver (v0.34.0)
- **Tor Browser**: Tor Browser (v13.0.16) with GeckoDriver and Tor network support
- All required system dependencies for headless browser operation
- Selenium Python package (4.15.2)

The Lambda function automatically detects the browser via `BROWSER` environment variable:
- Set `BROWSER=chromium` for Chromium
- Set `BROWSER=firefox` for Firefox
- Set `BROWSER=tor` for Tor Browser

**Chromium options optimized for AWS Lambda:**
- `--headless=new` - Run without GUI
- `--no-sandbox` - Required for Lambda environment
- `--disable-dev-shm-usage` - Prevents shared memory issues
- `--single-process` - Run in single process mode

**Firefox options optimized for AWS Lambda:**
- `--headless` - Run without GUI
- Optimized window size and memory settings

**Tor Browser options optimized for AWS Lambda:**
- `--headless` - Run without GUI
- SOCKS5 proxy configured to 127.0.0.1:9050
- Tor network routing enabled
- Optimized window size and memory settings

## Code Quality

The project uses Hadolint for Dockerfile linting. Configuration is in `.code_quality/.hadolint.yaml`.

GitHub Actions automatically runs linting on push and pull requests.

## Resources

- [Hadolint Documentation](https://hadolint.github.io/hadolint/)
- [AWS Lambda Python Image](https://docs.aws.amazon.com/lambda/latest/dg/python-image.html)
- [Selenium Documentation](https://www.selenium.dev/documentation/)
- [ChromeDriver for Testing](https://googlechromelabs.github.io/chrome-for-testing/)
