#!/bin/bash

dnf update -y
dnf install -y httpd wget php-fpm php-mysqli php-json php php-devel mariadb105

wget http://ja.wordpress.org/latest-ja.tar.gz -P /tmp/
tar zxvf /tmp/latest-ja.tar.gz -C /tmp
mkdir -p /var/www/html
cp -r /tmp/wordpress/* /var/www/html/
chown apache:apache -R /var/www/html

systemctl enable httpd.service
systemctl start httpd.service

# yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
# systemctl restart amazon-ssm-agent