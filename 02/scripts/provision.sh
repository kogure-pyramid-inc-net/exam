#!/bin/bash
set -eu

yum -y update
yum -y install ntp httpd php

sed -i -e "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8080/g" /etc/httpd/conf/httpd.conf

sed -i -e "s/DirectoryIndex index.html/DirectoryIndex index.php index.html/g" /etc/httpd/conf/httpd.conf