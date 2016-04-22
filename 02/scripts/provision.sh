#!/bin/bash
set -eu

yum -y update
yum -y install ntp httpd

sed -i -e "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8080/g" /etc/httpd/conf/httpd.conf

#mod_redirectを使う。
#一度クライアントに戻るから無駄が多いのと、
#一度戻ったあとの挙動はクライアントの実装次第なので（よっぽどひねくれたクライアントじゃなければ大丈夫と思うけど）
#厳密な意味で「サーバサイドだけでの解決」にはなっていないかも。
str="Redirect /images http://localhost:5001/assets"
if grep "${str}" /etc/httpd/conf/httpd.conf > /dev/null 
then
  echo httpd.conf not edit
else
  echo ${str} >> /etc/httpd/conf/httpd.conf
fi