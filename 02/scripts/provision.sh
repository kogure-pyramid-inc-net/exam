#!/bin/bash
set -eu

yum -y update
#-Uにしてもコケる(多分rpmのalready installedがエラー扱いになってるのでは？)ので、
#パッケージ存在で処理分けるしか無い。というか単にyumにあればそれで済むのに！
if rpm -qa | grep nginx > /dev/null
then
	echo "nginx packege already exists."
else
	rpm -Uvh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
fi
yum -y install ntp httpd nginx

sed -i -e "s/Listen 80$/Listen 8090/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8090/g" /etc/httpd/conf/httpd.conf

if [ -e /etc/nginx/conf.d/reverse_proxy.conf ]; then
	echo "/etc/nginx/conf.d/reverse_proxy.conf already exists. not copied."
else
	#nginx.confの中に　include /etc/nginx/conf.d/*.conf;　が書いてあるので追加設定を.confでコピーしとけば読み込まれる。
	cp /vagrant/scripts/reverse_proxy.conf /etc/nginx/conf.d/
fi
