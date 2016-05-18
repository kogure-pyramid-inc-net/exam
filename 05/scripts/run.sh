#!/bin/bash
set -eu

if [ -f /usr/local/apache2/logs/httpd.pid ]; then
	/usr/local/apache2/bin/apachectl restart
else
	/usr/local/apache2/bin/apachectl start
fi

if [ -f /usr/local/nginx/logs/nginx.pid ]; then
	/usr/local/nginx/sbin/nginx -s reload
else
	/usr/local/nginx/sbin/nginx
fi
