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
    xz \
    tar \
    findutils && \
/usr/bin/dnf clean all && \
rm -rf /var/cache/dnf /var/log/dnf.log

GECKODRIVER_VERSION="0.34.0"
TOR_VERSION="15.0.2"

mkdir -p /opt/tor-browser
mkdir -p /opt/geckodriver

curl -fL --retry 3 --retry-delay 2 -o "/tmp/tor-browser-linux64.tar.xz" \
    "https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_ALL.tar.xz"
curl -fL --retry 3 --retry-delay 2 -o "/tmp/geckodriver.tar.gz" \
    "https://github.com/mozilla/geckodriver/releases/download/v${GECKODRIVER_VERSION}/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz"

cd /opt/tor-browser && xz -dc /tmp/tor-browser-linux64.tar.xz | tar -xf - --strip-components=1
cd /opt/geckodriver && tar -zxf /tmp/geckodriver.tar.gz

chmod +x /opt/geckodriver/geckodriver /opt/tor-browser/Browser/firefox /opt/tor-browser/Browser/start-tor-browser /opt/tor-browser/Browser/TorBrowser/Tor/tor

mkdir -p /opt/tor-data
mkdir -p /opt/tor-config
cat > /opt/tor-config/torrc << 'EOF'
SocksPort 127.0.0.1:9050
DataDirectory /opt/tor-data
EOF

rm -rf /tmp/*.tar.xz /tmp/*.tar.gz

