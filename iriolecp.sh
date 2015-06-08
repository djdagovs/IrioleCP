#!/bin/bash
# Iriole CP Setup

function jumpto {
	label=$1
	cmd=$(sed -n "/$label:/{:a,;n;p;ba};" $0 | grep -v ':$')
	eval "$cmd"
	exit
}

start=${1:-"start"}

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