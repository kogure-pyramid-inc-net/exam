#!/bin/bash
set -eu

yum -y update
yum -y install ntp httpd

sed -i -e "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8080/g" /etc/httpd/conf/httpd.conf

#mod_rewriteを使う。mod_rewriteドキュメントの基本の例をそのまま書いた。
str="ProxyPass /images http://localhost:8080/assets"
if grep "${str}" /etc/httpd/conf/httpd.conf > /dev/null 
then
  echo httpd.conf not edit
else
  echo ${str} >> /etc/httpd/conf/httpd.conf
  echo "ProxyPassReverse /images http://localhost:8080/assets" >> /etc/httpd/conf/httpd.conf
fi
