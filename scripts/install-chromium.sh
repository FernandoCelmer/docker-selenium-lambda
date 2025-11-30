#!/bin/bash
set -e

/usr/bin/dnf install -y \
    atk \
    cups-libs \
    dbus-glib \
    gtk3 \
    libX11 \
    libXcomposite \
    libXcursor \
    libXdamage \
    libXext \
    libXfixes \
    libXi \
    libXinerama \
    libXrandr \
    libXrender \
    libXScrnSaver \
    libXtst \
    libXt \
    libGL \
    alsa-lib \
    nss \
    mesa-libgbm \
    pango \
    procps \
    dejavu-sans-fonts \
    tar \
    findutils \
    unzip && \
/usr/bin/dnf clean all && \
rm -rf /var/cache/dnf /var/log/dnf.log

CHROME_VERSION="131.0.6778.85"

curl -fL --retry 3 --retry-delay 2 -o "/tmp/chromedriver-linux64.zip" \
    "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chromedriver-linux64.zip"
curl -fL --retry 3 --retry-delay 2 -o "/tmp/chrome-linux64.zip" \
    "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chrome-linux64.zip"

/usr/bin/unzip -q /tmp/chromedriver-linux64.zip -d /opt/
/usr/bin/unzip -q /tmp/chrome-linux64.zip -d /opt/

CHROME_DIR=$(/usr/bin/find /opt/chrome-linux64 -type d -name "chrome-linux64" | head -1)
CHROMEDRIVER_PATH=$(/usr/bin/find /opt/chromedriver-linux64 -name chromedriver -type f | head -1)

mkdir -p /opt/chrome
cp -r "$CHROME_DIR"/* /opt/chrome/
cp "$CHROMEDRIVER_PATH" /opt/chromedriver

chmod +x /opt/chrome/chrome /opt/chromedriver

rm -rf /tmp/chrome-linux64 /tmp/chromedriver-linux64 /tmp/*.zip

