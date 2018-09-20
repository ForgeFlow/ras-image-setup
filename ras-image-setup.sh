
#!/bin/bash

cd /home/pi/

# Install requirements
apt update && apt install -yq \
    python3-smbus i2c-tools git python3-dev python3-pip \
    libfreetype6-dev libjpeg-dev build-essential libsdl-dev \
    libportmidi-dev libsdl-ttf2.0-dev libsdl-mixer1.2-dev libsdl-image1.2-dev libopenjp2-7 \
    python3-RPi.GPIO dnsmasq hostapd isc-dhcp-server
apt clean
rm -rf /var/lib/apt/lists/*

if [ ! -d /home/pi/ras ]
then
    git clone https://github.com/Eficent/ras.git
else
    cd ras
    git fetch origin
    git reset --hard origin/master
fi

pip3 install -r /home/pi/ras/requeriments.txt
cp -f /home/pi/ras-image-setup/config.txt /boot/
cp -f /home/pi/ras-image-setup/modules /etc/
cp -f /home/pi/ras-image-setup/rc.local /etc/
mv /home/pi/ras/dicts/credentials.json.sample /home/pi/ras/dicts/credentials.json
mv /home/pi/ras/dicts/data.json.sample /home/pi/ras/dicts/data.json

git clone https://github.com/lthiery/SPI-Py.git
cd SPI-Py
python3 setup.py install
cd ..
rm -R SPI-Py

# systemctl stop dhcpcd
# systemctl disable dhcpcd

# systemctl enable NetworkManager
# systemctl start NetworkManager

# Setup ras portal service
cp -f /home/pi/ras-image-setup/ras-portal.service /lib/systemd/system/
chmod 755 /lib/systemd/system/ras-portal.service
chown root: /lib/systemd/system/ras-portal.service

# systemctl enable ras-portal.service
# systemctl start ras-portal.service

# Setup ras launcher service
cp -f /home/pi/ras-image-setup/ras-launcher.service /lib/systemd/system/
chmod 755 /lib/systemd/system/ras-launcher.service
chown root: /lib/systemd/system/ras-launcher.service

# systemctl enable ras-launcher.service
# systemctl start ras-launcher.service

# Setup resin-wifi-connect

bash /home/pi/ras-image-setup/wifi-connect-raspbian-install.sh
