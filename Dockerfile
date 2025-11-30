ARG PYTHON_VERSION=3.14
ARG BROWSER=chromium

FROM public.ecr.aws/lambda/python:${PYTHON_VERSION}

ARG BROWSER=chromium

COPY scripts/install-chromium.sh scripts/install-firefox.sh scripts/install-tor.sh /tmp/
RUN chmod +x /tmp/install-*.sh && \
    if [ "$BROWSER" = "chromium" ]; then \
        /tmp/install-chromium.sh; \
    elif [ "$BROWSER" = "tor" ]; then \
        /tmp/install-tor.sh; \
    else \
        /tmp/install-firefox.sh; \
    fi && \
    rm -f /tmp/install-*.sh

ENV BROWSER=${BROWSER}

COPY requirements.txt ${LAMBDA_TASK_ROOT}/

RUN pip install --no-cache-dir --root-user-action=ignore --upgrade pip && \
    pip install --no-cache-dir --root-user-action=ignore -r "${LAMBDA_TASK_ROOT}/requirements.txt"

COPY lambda_function.py ${LAMBDA_TASK_ROOT}/
COPY browsers/ ${LAMBDA_TASK_ROOT}/browsers/

CMD ["lambda_function.lambda_handler"]
