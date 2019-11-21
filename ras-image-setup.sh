
#!/bin/bash

# Install requirements
apt update && apt install -yq \
    python3-smbus i2c-tools git python3-dev python3-pip \
    libfreetype6-dev libjpeg-dev build-essential libsdl-dev \
    libportmidi-dev libsdl-ttf2.0-dev libsdl-mixer1.2-dev libsdl-image1.2-dev libopenjp2-7 \
    python3-RPi.GPIO watchdog hostapd dnsmasq
apt -yq clean
apt -yq autoremove
rm -rf /var/lib/apt/lists/*

# Clone oot project
cd /home/pi/
git clone https://github.com/tegin/oot
cd oot
git checkout dev-xmlrpc
pip3 install -r requirements.txt
pip3 install .


# Clone ras project
git clone https://github.com/eficent/ras.git
cd ras
git checkout ras3-eficent
pip3 install cmdline PyGithub luma.oled


# Configure settings
cp -f /home/pi/ras-image-setup/config.txt /boot/
cp -f /home/pi/ras-image-setup/modules /etc/
cp -f /home/pi/ras-image-setup/bcm2835-wdt.conf /etc/modprobe.d/bcm2835-wdt.conf
cp -f /home/pi/ras-image-setup/system.conf /etc/systemd/system.conf
cp -f /home/pi/ras-image-setup/watchdog.conf /etc/watchdog.conf

# Setup ras service
cp -f /home/pi/ras/ras.service /lib/systemd/system/
systemctl enable ras.service

# Disable hostapd
systemctl disable hostapd
