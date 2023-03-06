#!/bin/bash
sudo su
yum update -y
yum install -y httpd
cd /var/www/html
wget https://github.com/Sujagi02/Weather-API-Application/archive/refs/heads/master.zip
unzip master.zip
cp -r Weather-API-Application-master/* /var/www/html/
rm -rf Weather-API-Application-master master.zip
systemctl enable httpd 
systemctl start httpd