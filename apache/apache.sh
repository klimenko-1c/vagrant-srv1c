sudo apt-get update

sudo apt-get install libmagickwand5

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
echo ttf-mscorefonts-installer msttcorefonts/present-mscorefonts-eula note | sudo debconf-set-selections
sudo apt-get -y install ttf-mscorefonts-installer

sudo sh -c 'echo srv1c > /etc/hostname'

cp /vagrant/deb64.tar.gz .
tar -xf deb64.tar.gz

sudo dpkg -i 1c-enterprise83-common_8.3.10-1981_amd64.deb
sudo dpkg -i 1c-enterprise83-common-nls_8.3.10-1981_amd64.deb
sudo dpkg -i 1c-enterprise83-server_8.3.10-1981_amd64.deb
sudo dpkg -i 1c-enterprise83-server-nls_8.3.10-1981_amd64.deb
sudo dpkg -i 1c-enterprise83-ws_8.3.10-1981_amd64.deb
sudo dpkg -i 1c-enterprise83-ws-nls_8.3.10-1981_amd64.deb

sudo sh -c 'echo LoadModule _1cws_module "/opt/1C/v8.3/x86_64/wsap24.so" > /etc/apache2/mods-available/mod1c.load'
sudo ln -s ../mods-available/mod1c.load /etc/apache2/mods-enabled/mod1c.load

sudo mkdir /var/www/test
sudo touch /etc/apache2/sites-available/1c.conf
sudo ln -s ../sites-available/1c.conf /etc/apache2/sites-enabled/1c.conf
sudo /opt/1C/v8.3/x86_64/webinst -apache24 -wsdir test -dir /var/www/test -connstr "Srvr=srv1c;Ref=test;" -confPath /etc/apache2/sites-available/1c.conf
sudo service apache2 reload