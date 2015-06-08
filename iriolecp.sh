#!/bin/bash
# Iriole CP Setup

echo "Welcome to the IrioleCP setup script"

echo "Would you like to install IrioleCP?"
select yn in "Yes" "No"; do
	case $yn in
		Yes )

			echo "Beginning installation ..."

		break;;
		No ) exit;;
	esac
done