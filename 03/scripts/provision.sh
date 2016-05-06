#!/bin/bash
set -eu

yum -y update
yum -y install httpd

sed -i -e "s/Listen 80$/Listen 8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8080/g" /etc/httpd/conf/httpd.conf

#単純に/var/www/htmlのAllowOverrideを書き換えて.htaccessを有効にすればいいのだが
#残念なことにAllowOverride Noneはいろいろな場所にある。

#最下行に同じ<Directory "/var/www/html">設定を追記すると動くは動くけど、書いた以外の設定は残るのか破棄されるのか不明。。。
#printf "<Directory \"/var/www/html\">\nAllowOverride All\n</Directory>" >> /etc/httpd/conf/httpd.conf

#しかしながら行番号指定置換はちょっと。。。
sed -i -e "338s/AllowOverride None/AllowOverride All/g" /etc/httpd/conf/httpd.conf

#かといって2番目出現指定も危ない
#sed -i -e "s/AllowOverride None/AllowOverride All/2" /etc/httpd/conf/httpd.conf
