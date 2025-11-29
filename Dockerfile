ARG PYTHON_VERSION=3.14

FROM public.ecr.aws/lambda/python:${PYTHON_VERSION} as build

RUN dnf install -y unzip && \
    curl -Lo "/tmp/chromedriver-linux64.zip" "https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.85/linux64/chromedriver-linux64.zip" && \
    curl -Lo "/tmp/chrome-linux64.zip" "https://storage.googleapis.com/chrome-for-testing-public/131.0.6778.85/linux64/chrome-linux64.zip" && \
    unzip /tmp/chromedriver-linux64.zip -d /opt/ && \
    unzip /tmp/chrome-linux64.zip -d /opt/ && \
    dnf clean all

FROM public.ecr.aws/lambda/python:${PYTHON_VERSION}

RUN dnf install -y atk cups-libs gtk3 libXcomposite alsa-lib \
    libXcursor libXdamage libXext libXi libXrandr libXScrnSaver \
    libXtst pango at-spi2-atk libXt xorg-x11-server-Xvfb \
    xorg-x11-xauth dbus-glib dbus-glib-devel nss mesa-libgbm \
    dejavu-sans-fonts dejavu-serif-fonts dejavu-sans-mono-fonts && \
    dnf clean all

COPY --from=build /opt/chrome-linux64 /opt/chrome-linux64
COPY --from=build /opt/chromedriver-linux64 /opt/chromedriver-linux64

RUN CHROME_DIR=$(find /opt/chrome-linux64 -type d -name "chrome-linux64" | head -1) && \
    CHROMEDRIVER_PATH=$(find /opt/chromedriver-linux64 -name chromedriver -type f | head -1) && \
    mkdir -p /opt/chrome && \
    cp -r "$CHROME_DIR"/* /opt/chrome/ && \
    cp "$CHROMEDRIVER_PATH" /opt/chromedriver && \
    chmod +x /opt/chrome/chrome /opt/chromedriver

COPY requirements.txt ${LAMBDA_TASK_ROOT}/

RUN pip install --no-cache-dir --root-user-action=ignore --upgrade pip && \
    pip install --no-cache-dir --root-user-action=ignore -r requirements.txt

COPY lambda_function.py ${LAMBDA_TASK_ROOT}/

CMD ["lambda_function.lambda_handler"]
