#!/bin/bash



function main
{
welcome
R-U-Root
prerequisites
build-setup
configs
heavy-lifting
}



function welcome
{
clear
echo "



=======================================

     Aerofoil live build creator

======================================="





echo "This is what you wanted, right?"
read a
if [[ $a == "Y" || $a == "y" ]]; then
        echo "ok, we gonna do it!"
        sleep 2s
        clear
else 
	exit 1
fi
}


function R-U-Root
{
if [ $EUID -ne 0 ]; then
	echo " Sorry, gotta be root! Try using \"sudo\""
	exit 1
fi
}

function prerequisites
{
if [ -e /usr/bin/aptitude ]; then 
	echo "Using Debian I see"
	if [ -e /usr/bin/debootstrap ]; then
		echo "debootstrap found"
	else
		aptitude install -y debootstrap
	fi
	if [ -e /usr/bin/live-build ]; then
		echo "live-build found"
	else
		apt-get install -y live-build
	fi
elif [ -e /usr/bin/pacman ]; then
	echo "Using Arch I see"
	if [ -e /usr/bin/debootstrap ]; then
		echo "debootstrap found"
	else
		if [ -e /usr/bin/pacaur ]; then
			echo "pacaur found, installing debootstrap"
			pacaur -S --noconfirm debootstrap
		elif [ -e /usr/bin/yaourt ]; then
			echo "yaourt found, installing debootstrap"
			yaourt -S debootstrap
		else
			echo "sorry, you need to somehow install debootstrap from the AUR"
			exit 1
		fi
	fi
	if [ -e /usr/bin/live-build ]; then
		echo "live-build found"
	else
		if [ -e /usr/bin/pacaur ]; then
			echo "pacaur found, installing live-build"
			pacaur -S --noconfirm live-build-git
		elif [ -e /usr/bin/yaourt ]; then
			echo "yaourt found, installing live-build"
			yaourt -S live-build-git
		else
			echo "sorry, you need to somehow install live-build-git from the AUR"
			exit 1
		fi
	fi
else
	echo "errors have occured!
This is probably because you are not on Debian or Arch Linux. Please use this script while running one of those distros!"
	exit 1
fi
}

function build-setup
{
	mkdir live-default
	cd live-default
	lb init 
	cp /usr/share/doc/live-build/examples/auto/* auto/
}

function configs
{
cat ./auto-config > ./auto/config
}

function heavy-lifting
{
	lb clean
	lb config
	lb build
}
#run it!
main