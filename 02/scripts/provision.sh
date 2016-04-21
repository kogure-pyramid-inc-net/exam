#!/bin/bash
set -eu

yum -y update
yum -y install ntp httpd

sed -i -e "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8080/g" /etc/httpd/conf/httpd.conf

#設定ファイル挿入よりも.htccessに書いて設置した方がいいのかも
#この書き方だとわかりにくすぎる。複数行挿入の何かいい書き方は。。
sed -i -e "/^<Directory \"\/var\/www\/html\">$/a RewriteEngine On\nRewriteBase \/\nRewriteRule ^images\/(.+)$ assets/\$1 [L]\n" /etc/httpd/conf/httpd.conf
