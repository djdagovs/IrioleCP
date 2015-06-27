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
startinstall=${1:-"startinstall"}
installapache=${1:-"installapache"}
installmysql=${1:-"installmysql"}
configuremysql=${1:-"configuremysql"}
installphp=${1:-"installphp"}
installingbinddns=${1:-"installingbinddns"}
configurebinddns=${1:-"configurebinddns"}
startiriolecp=${1:-"startiriolecp"}

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
pause 3
yum -y update
jumpto $installapache

installapache:
echo "Installing Apache ..."
pause 3
yum -y install httpd
jumpto $installmysql

installmysql:
echo "Installing MySQL ..."
pause 3
yum -y install mysql-server
jumpto $configuremysql

configuremysql:
echo "Now to configure MySQL - you'll need to do a bit of input for this step!"
pause 3
service mysqld start
/usr/bin/mysql_secure_installation
service mysqld stop
jumpto $installphp
echo "Installing PHP ..."
pause 3
yum -y nistall php php-mysql
goto $installingbinddns

installingbinddns:
echo "Installing DNS ..."
pause 3
yum -y install bind bind-utils
goto $configurebinddns

configurebinddns:
echo "Auto conigure of BIND DNS not written yet."
pause 1
echo "Visit https://goo.gl/YVaJ5r for more information on how to configure BIND DNS"
pause 3
echo "Setting up the BIND chroot environment ..."
pause 3
yum -y install bind-chroot
service named restart
goto $startiriolecp

startiriolecp:
if (( $(ps -ef | grep -v grep | grep httpd | wc -1) > 0 ))
then
	echo "Apache service already running ..."
else
	service httpd start
fi
if (( $(ps -ef | grep -v grep | grep mysqld | wc -1) > 0 ))
then
	echo "MySQL service already running ..."
else
	service mysqld start
fi