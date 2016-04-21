#!/bin/bash
set -eu

yum -y update
yum -y install ntp httpd

#$付けとかないとprivisionのたびに8080808080....って増えます
sed -i -e "s/Listen 80$/Listen 8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8080/g" /etc/httpd/conf/httpd.conf

#出題注意書きにもあるのでアウト
#mv /var/www/html/assets /var/www/html/images 

#反則スレスレだけど多分出題意図としては違うのでしょう
#ln -s /var/www/html/assets /var/www/html/images

#置き換えだとこの回答でしょうか
str="Alias /images/ \"/var/www/html/assets/\""
if grep "${str}" /etc/httpd/conf/httpd.conf > /dev/null 
then
  echo httpd.conf not edit
else
  echo ${str} >> /etc/httpd/conf/httpd.conf
fi