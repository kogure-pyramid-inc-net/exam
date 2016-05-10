#!/bin/bash
set -eu

yum -y update
yum -y install httpd

sed -i -e "s/Listen 80$/Listen 8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8080/g" /etc/httpd/conf/httpd.conf

chmod -R a+x /var/log/httpd

#install fluentd
if [ -e /etc/td-agent/conf.d/httpd_log.conf ]; then
	echo "/etc/td-agent/conf.d/httpd_log.conf already exists."
else
	#インストール途中でコケたときのことを考えると１行づつチェックすべきか。。。
	curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
	chmod -R a+w /vagrant/app/logs
	chmod -R a+w /var/log/td-agent/
	mkdir /etc/td-agent/conf.d/
	cp /vagrant/scripts/httpd_log.conf /etc/td-agent/conf.d/
	echo "@include conf.d/*.conf" >> /etc/td-agent/td-agent.conf
fi