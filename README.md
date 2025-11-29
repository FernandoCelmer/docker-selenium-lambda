# Docker Selenium Lambda - Python 3.14

[![Docker Lint](https://github.com/FernandoCelmer/docker-selenium-lambda/actions/workflows/docker-lint.yml/badge.svg)](https://github.com/FernandoCelmer/docker-selenium-lambda/actions/workflows/docker-lint.yml)
[![Python](https://img.shields.io/badge/Python-3.14-blue.svg)](https://www.python.org/)
[![Docker](https://img.shields.io/badge/Docker-Latest-blue.svg)](https://www.docker.com/)
[![AWS Lambda](https://img.shields.io/badge/AWS-Lambda-orange.svg)](https://aws.amazon.com/lambda/)
[![License](https://img.shields.io/badge/License-GPLv3-green.svg)](LICENSE)

Base Dockerfile for AWS Lambda with Python 3.14, including code quality tools and linting.

## Commands

```bash
make lint
make build
make test
make run
```

## Build

```bash
docker build -t lambda-python-314 .
docker run -p 9000:8080 lambda-python-314
```

## Test Lambda Function

```bash
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
  -H "Content-Type: application/json" \
  -d '{}'
```

## Code Quality

The project uses Hadolint for Dockerfile linting. Configuration is in `.code_quality/.hadolint.yaml`.

GitHub Actions automatically runs linting on push and pull requests.

## Resources

- [Hadolint Documentation](https://hadolint.github.io/hadolint/)
- [AWS Lambda Python Image](https://docs.aws.amazon.com/lambda/latest/dg/python-image.html)
