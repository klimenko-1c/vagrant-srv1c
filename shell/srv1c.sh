#!/bin/sh

sudo locale-gen en_US ru_RU ru_RU.UTF-8
sudo update-locale LANG=ru_RU.UTF8
sudo dpkg-reconfigure locales
reboot

wget http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu48_4.8.1.1-3ubuntu0.6_amd64.deb
sudo dpkg -i libicu48_4.8.1.1-3ubuntu0.6_amd64.deb

# ???
#apt-get install libxslt1.1 ssl-cert

sudo sh -c 'echo "deb http://1c.postgrespro.ru/deb/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/postgrespro-1c.list'
wget --quiet -O - http://1c.postgrespro.ru/keys/GPG-KEY-POSTGRESPRO-1C-92 | sudo apt-key add - && sudo apt-get update
sudo apt-get --assume-yes install postgresql-pro-1c-9.4

#откроем /etc/postgresql/9.4/main/pg_hba.conf и найдем в нем строку:
#local all postgres peer 
#и приведем ее к виду:
#local	all	postgres	trust
sudo sh -c "sed 's/local[ \t]\+all[ \t]\+postgres[ \t]\+peer[ \t]*/#&\nlocal all postgres trust/' /etc/postgresql/9.4/main/pg_hba.conf > /etc/postgresql/9.4/main/pg_hba.conf"
sudo service postgresql restart
psql -U postgres -d template1 -c "ALTER USER postgres PASSWORD 'postgres'"

sudo sh -c 'echo "kernel.shmmax=2147483648" >> /etc/sysctl.conf'
sysctl -p

apt-get install imagemagick
sudo find /usr/lib/ -name "libMagickWand.so*" -print
sudo ln -s -T /usr/lib/libMagickWand.so.5 /usr/lib/libWand.so

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
echo ttf-mscorefonts-installer msttcorefonts/present-mscorefonts-eula note | sudo debconf-set-selections
sudo apt-get install ttf-mscorefonts-installer


dpkg --add-architecture i386 && apt-get update
sudo apt-get install libc6:i386
sudo dpkg -i aksusbd_2.0-1_i386.deb
