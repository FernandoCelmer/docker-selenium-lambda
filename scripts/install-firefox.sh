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
    bzip2 \
    gzip \
    tar \
    findutils && \
/usr/bin/dnf clean all && \
rm -rf /var/cache/dnf /var/log/dnf.log

GECKODRIVER_VERSION="0.34.0"
FIREFOX_VERSION="131.0"

mkdir -p /opt/firefox
mkdir -p /opt/geckodriver

curl -fL --retry 3 --retry-delay 2 -o "/tmp/firefox.tar.bz2" \
    "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.bz2"
curl -fL --retry 3 --retry-delay 2 -o "/tmp/geckodriver.tar.gz" \
    "https://github.com/mozilla/geckodriver/releases/download/v${GECKODRIVER_VERSION}/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz"

/usr/bin/tar -jxf /tmp/firefox.tar.bz2 --strip-components=1 -C /opt/firefox/
/usr/bin/tar -zxf /tmp/geckodriver.tar.gz -C /opt/geckodriver/

chmod +x /opt/geckodriver/geckodriver /opt/firefox/firefox

rm -rf /tmp/*.tar.gz /tmp/*.tar.bz2

