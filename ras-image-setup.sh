
#!/bin/bash

cd /home/pi/

# Install requirements
apt update && apt install -yq \
    python3-smbus i2c-tools git python3-dev python3-pip \
    libfreetype6-dev libjpeg-dev build-essential libsdl-dev \
    libportmidi-dev libsdl-ttf2.0-dev libsdl-mixer1.2-dev libsdl-image1.2-dev libopenjp2-7 \
    python3-RPi.GPIO watchdog

if [ ! -d /home/pi/ras ]
then
    git clone https://github.com/Eficent/ras.git
else
    cd ras
    git fetch origin
    git reset --hard origin/master
fi

pip3 install -r /home/pi/ras/requirements.txt
cp -f /home/pi/ras-image-setup/config.txt /boot/
cp -f /home/pi/ras-image-setup/modules /etc/
cp -f /home/pi/ras-image-setup/rc.local /etc/
cp -f /home/pi/ras-image-setup/bcm2835-wdt.conf /etc/modprobe.d/bcm2835-wdt.conf
cp -f /home/pi/ras-image-setup/system.conf /etc/systemd/system.conf
cp -f /home/pi/ras-image-setup/watchdog.conf /etc/watchdog.conf
mv /home/pi/ras/dicts/credentials.json.sample /home/pi/ras/dicts/credentials.json

# Setup ras launcher service
cp -f /home/pi/ras-image-setup/ras-launcher.service /lib/systemd/system/
chmod 755 /lib/systemd/system/ras-launcher.service
chown root: /lib/systemd/system/ras-launcher.service

# Setup resin-wifi-connect
apt update && \
apt install -y -d network-manager && \
apt install -y network-manager 
sh /home/pi/ras-image-setup/wifi-connect-raspbian-install.sh

cp -rf /home/pi/ras-image-setup/ui/img  /usr/local/share/wifi-connect/ui/
cp -f /home/pi/ras-image-setup/ui/index.html /usr/local/share/wifi-connect/ui/index.html

apt -yq clean
apt -yq autoremove
rm -rf /var/lib/apt/lists/*