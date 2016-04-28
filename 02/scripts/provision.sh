#!/bin/bash
set -eu

yum -y update
rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
yum -y install ntp httpd nginx

sed -i -e "s/Listen 80/Listen 8090/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8090/g" /etc/httpd/conf/httpd.conf

sed -i -e "\$d" /etc/nginx/nginx.conf
cat /vagrant/scripts/nginx.conf.append >> /etc/nginx/nginx.conf