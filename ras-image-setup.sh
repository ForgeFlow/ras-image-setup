
#!/bin/bash

cd /home/pi/

# Install requirements
apt update && apt install -yq \
    python3-smbus i2c-tools git python3-dev python3-pip \
    libfreetype6-dev libjpeg-dev build-essential libsdl-dev \
    libportmidi-dev libsdl-ttf2.0-dev libsdl-mixer1.2-dev libsdl-image1.2-dev libopenjp2-7 \
    python3-RPi.GPIO
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
cp -f /home/pi/ras/config.txt /boot/
mv /home/pi/ras/credentials.json.sample /home/pi/ras/credentials.json
mv /home/pi/ras/data.json.sample /home/pi/ras/data.json

git clone https://github.com/lthiery/SPI-Py.git
cd SPI-Py
python3 setup.py install
cd ..
rm -R SPI-Py

bash < curl -L https://github.com/hveficent/resin-wifi-connect/raw/master/scripts/raspbian-install.sh

# Setup ras portal service
cp -f /home/pi/ras/ras-portal.service /lib/systemd/system/
chmod 755 /lib/systemd/system/ras-portal.service
chown root: /lib/systemd/system/ras-portal.service

# Setup ras launcher service
cp -f /home/pi/ras/ras-launcher.service /lib/systemd/system/
chmod 755 /lib/systemd/system/ras-launcher.service
chown root: /lib/systemd/system/ras-launcher.service

systemctl stop dhcpcd
systemctl disable dhcpcd

systemctl enable NetworkManager
systemctl start NetworkManager

systemctl enable ras-portal.service
systemctl start ras-portal.service