#!/bin/bash
# Iriole CP Setup

function jumpto
{
	label=$1
	cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
	eval "$cmd"
	exit
}

start=${1:-"start"}
startinstall=${2:-"startinstall"}
installapache=${3:-"installapache"}
installmysql=${4:-"installmysql"}
configuremysql=${5:-"configuremysql"}
installphp=${6:-"installphp"}
installingbinddns=${7:-"installingbinddns"}
configurebinddns=${8:-"configurebinddns"}
downloadiriolecpfiles=${8:-"downloadiriolecpfiles"}
startiriolecp=${9:-"startiriolecp"}

jumpto $start

start:
echo "Welcome to the IrioleCP setup script"
read -p "Would you like to install IrioleCP? (y/n)" CONT
echo
if [ "$CONT" == "y" ];
then
	jumpto startinstall
else
	echo "Exiting installation..."
	exit
fi

startinstall:
echo "Updating packages ..."
sleep 3
yum -y update
jumpto $installapache

installapache:
echo "Installing Apache ..."
sleep 3
yum -y install httpd
jumpto $installmysql

installmysql:
echo "Installing MySQL ..."
sleep 3
yum -y install mysql-server
jumpto $configuremysql

configuremysql:
echo "Now to configure MySQL - you'll need to do a bit of input for this step!"
sleep 3
service mysqld start
/usr/bin/mysql_secure_installation
service mysqld stop
jumpto $installphp

installphp:
echo "Installing PHP ..."
sleep 3
yum -y install php php-mysql
jumpto $installingbinddns

installingbinddns:
echo "Installing DNS ..."
sleep 3
yum -y install bind bind-utils
jumpto $configurebinddns

configurebinddns:
echo "Auto conigure of BIND DNS not written yet."
sleep 1
echo "Visit https://goo.gl/YVaJ5r for more information on how to configure BIND DNS"
sleep 3
echo "Setting up the BIND chroot environment ..."
sleep 3
yum -y install bind-chroot
service named restart
jumpto $downloadiriolecpfiles

downloadiriolecpfiles:
yum -y install unzip
wget -P /var/www/html/ https://github.com/richardhedges/IrioleCP/archive/master.zip
unzip /var/www/html/master.zip
rm -rf /var/www/html/LICENSE
rm -rf /var/www/html/README.md
rm -rf /var/www/html/iriolecp.sh
mv /var/www/html/cp/* /var/www/html/
rm -rf /var/www/html/cp
jumpto $startiriolecp

startiriolecp:
# if (( $(ps -ef | grep -v grep | grep httpd | wc -l) > 0 ))
# if (( $(ps -ef | grep -v grep | grep httpd | wc -1) > 0 ))
# then
	# echo "Apache service already running ..."
# else
	service httpd start
# fi
# if (( $(ps -ef | grep -v grep | grep mysqld | wc -1) > 0 ))
# then
	# echo "MySQL service already running ..."
# else
	service mysqld start
# fi