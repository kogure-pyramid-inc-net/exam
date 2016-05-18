#!/bin/bash
set -eu

yum -y update
#pcre-develのソースが発見できなかった
yum -y install gcc gcc-c++ pcre-devel #python-devel

cd /tmp


# install apache ########################################################################
#apacheをconfigureするためのAPRつーもの
wget http://ftp.jaist.ac.jp/pub/apache//apr/apr-1.5.2.tar.gz
tar xzvf apr-1.5.2.tar.gz
cd apr-1.5.2
./configure
make
#/usr/local/apr
make install
cd ..

#apr-utilも必要らしい
wget http://ftp.jaist.ac.jp/pub/apache//apr/apr-util-1.5.4.tar.gz
tar xzvf apr-util-1.5.4.tar.gz
cd apr-util-1.5.4
./configure --with-apr=/usr/local/apr
make
make install
cd ..

#PCREとやらも必要
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.37.tar.gz
tar xzvf pcre-8.37.tar.gz
cd pcre-8.37
#configureにgcc-c++が必要
./configure
make
make install
cd ..

#apache本体
wget http://ftp.yz.yamagata-u.ac.jp/pub/network/apache//httpd/httpd-2.4.20.tar.gz
tar xzvf httpd-2.4.20.tar.gz
cd httpd-2.4.20
#configureにpcre-develも必要だがソースが見つからずyumで入れた
./configure #--with-pcre=/usr/local/bin/pcre-config
make
make install
cd ..


# install nginx ##########################################################################
#zlib(nginxのconfigureで必要)
wget http://zlib.net/zlib-1.2.8.tar.gz
tar xzvf zlib-1.2.8.tar.gz
cd zlib-1.2.8
./configure
make
make install
cd ..

#nginx
wget http://nginx.org/download/nginx-1.10.0.tar.gz
tar xzvf nginx-1.10.0.tar.gz
cd nginx-1.10.0
./configure \
 --with-http_realip_module 

make
make install
cd ..

# install php ###########################################################################
#libxml2(phpのconfigureで必要)
wget http://xmlsoft.org/sources/libxml2-2.9.3.tar.gz
tar xzvf libxml2-2.9.3.tar.gz
cd libxml2-2.9.3
./configure --without-python
#python-devel(libxml2のmakeで必要)
make
make install
cd ..

#php
wget -O php-5.6.21.tar.gz http://jp2.php.net/get/php-5.6.21.tar.gz/from/this/mirror
tar xzvf php-5.6.21.tar.gz
cd php-5.6.21
#perl
yum -y install perl
sed -i -e "s/#\!\/replace\/with\/path\/to\/perl\/interpreter -w/#\!\/usr\/bin\/perl -w/g" /usr/local/apache2/bin/apxs
./configure --with-apxs2=/usr/local/apache2/bin/apxs --enable-mbstring --enable-mbregex
make ZEND_EXTRA_LIBS='-lresolv'
make install
cd ..

########################################################################################

sed -i -e "s/Listen 80$/Listen 9000/g" /usr/local/apache2/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:9000/g" /usr/local/apache2/conf/httpd.conf
sed -i -e "s/DocumentRoot \"\/usr\/local\/apache2\/htdocs\"/DocumentRoot \"\/var\/www\/html\"/g" /usr/local/apache2/conf/httpd.conf
sed -i -e "s/<Directory \"\/usr\/local\/apache2\/htdocs\">/<Directory \"\/var\/www\/html\">/g" /usr/local/apache2/conf/httpd.conf
sed -i -e "s/    DirectoryIndex index.html/    DirectoryIndex index.php index.html/g" /usr/local/apache2/conf/httpd.conf
echo "AddType application/x-httpd-php .php" >> /usr/local/apache2/conf/httpd.conf

if [ -e /usr/local/nginx/conf/conf.d/reverse_proxy.conf ]; then
	echo "/usr/local/nginx/conf/conf.d/reverse_proxy.conf already copied."
else
	sed -i -e "\$s/}/include \/usr\/local\/nginx\/conf\/conf.d\/*;}/g" /usr/local/nginx/conf/nginx.conf
	mkdir /usr/local/nginx/conf/conf.d
	cp /vagrant/scripts/reverse_proxy.conf /usr/local/nginx/conf/conf.d/reverse_proxy.conf
	mkdir /usr/local/nginx/html/healthcheck
	echo "healthcheck ok" > /usr/local/nginx/html/healthcheck/index.html
fi
