#!/bin/bash
set -eu

echo argc:$#,argv:$@ #特に意味はない
if [ $# == 2 ]; then
    cp /vagrant/scripts/.htaccess /var/www/html/
    htpasswd -bc /var/www/.htpasswd $1 $2
    echo .htaccess created.
else
	if [ -e /var/www/html/.htaccess ]; then
		rm /var/www/html/.htaccess
		rm /var/www/.htpasswd
		echo .htaccess removed.
	fi
fi

function is_running() {
	SERVICE_NAME=$1
	IS_SERVICE_RUNNING=$(service $SERVICE_NAME status | grep "running")
	if [ "$IS_SERVICE_RUNNING" == "" ]; then
		echo 'false'
	else
		echo 'true'
	fi
}

IS_HTTPD_RUNNING=$(is_running httpd)
if [ "$IS_HTTPD_RUNNING" == 'true' ]; then
  service httpd restart
else
  service httpd start
fi
