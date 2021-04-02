#!/bin/bash

## License: MIT
## It can reinstall Debian, Ubuntu, CentOS system with network.
## Default root password: dreamstart.site
## BLOG: https://dreamstart.site


echo -e "\n\n\n"
clear
echo -e "\n"
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\033[33m Network-Reinstall-System Tools\033[0m"
echo -e "\033[33m Reinstall the Linux system requires only network and one click \033[0m"
echo -e "\033[33m System requirements: Any Linux system with GRUB or GRUB2, recommended CentOS8/Debian10/Ubuntu20 \033[0m"
echo -e "\n"
echo -e "\033[33m [Original] One-click Network Reinstall System\033[0m"
echo -e "\033[33m https://savilelee.github.io/Network/ \033[0m"
echo "---------------------------------------------------------------------------------------------------------------------"
echo " Default root password: dreamstart.site"
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
sleep 6s

echo "---------------------------------------------------------------------------------------------------------------------"
echo " Pre-environment preparation. . ."
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
sleep 2s

function is_root() {
  if [[ 0 == "$UID" ]]; then
    print_ok "The current user is the root user, start the installation process"
  else
    print_error "The current user is not the root user, please switch to the root user and re-execute the script"
    exit 1
  fi
}

if [ -f "/usr/bin/apt-get" ];then
	isDebian=`cat /etc/issue|grep Debian`
	if [ "$isDebian" != "" ];then
		echo 'Current system is Debian'
		apt-get install -y xz-utils openssl gawk file wget curl
		apt install -y xz-utils openssl gawk file wget curl
		sleep 3s
	else
		echo 'Current system is Ubuntu'
		apt-get install -y xz-utils openssl gawk file wget curl
		apt install -y xz-utils openssl gawk file wget curl
		sleep 3s
	fi
else
    echo 'Current system is CentOS'
    yum install -y xz openssl gawk file wget curl
    sleep 3s
fi

echo "---------------------------------------------------------------------------------------------------------------------"
echo " Pre-environment preparation. . .  【OK】"
echo -e "\n"
echo " Start system installation. . . "
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
sleep 2s


if [ $1 = '-UI_Options' ]
then
	echo -e "\033[33m You have chosen to Start the Graphical Interface Options \033[0m"
	echo -e "\n"
	sleep 1s
	wget --no-check-certificate -qO UI_Options.sh 'https://savilelee.github.io/Network/CoreFiles/UI_Options.sh' && bash UI_Options.sh
fi

if [ $1 = '-CentOS_8' ]
then
	echo -e "\033[33m You have chosen to install the latest CentOS_8 \033[0m"
	echo -e "\n"
	sleep 5s
	wget --no-check-certificate -qO Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/Core_Install.sh' && bash Core_Install.sh -c 8 -v 64 -a
fi

if [ $1 = '-CentOS_7' ]
then
	echo -e "\033[33m You have chosen to install the latest CentOS_7 \033[0m"
	echo -e "\n"
	sleep 5s
	wget --no-check-certificate -qO Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/Core_Install.sh' && bash Core_Install.sh -c 7 -v 64 -a
fi

if [ $1 = '-Debian_10' ]
then
	echo -e "\033[33m You have chosen to install the latest Debian_10 \033[0m"
	echo -e "\n"
	sleep 5s
	wget --no-check-certificate -qO Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/Core_Install.sh' && bash Core_Install.sh -d 10 -v 64 -a
fi

if [ $1 = '-Debian_9' ]
then
	echo -e "\033[33m You have chosen to install the latest Debian_9 \033[0m"
	echo -e "\n"
	sleep 5s
	wget --no-check-certificate -qO Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/Core_Install.sh' && bash Core_Install.sh -d 9 -v 64 -a
fi

if [ $1 = '-Ubuntu_20.04' ]
then
	echo -e "\033[33m You have chosen to install the latest Ubuntu_20.04 \033[0m"
	echo -e "\n"
	sleep 5s
	wget --no-check-certificate -qO Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/Core_Install.sh' && bash Core_Install.sh -u 20.04 -v 64 -a
fi

if [ $1 = '-Ubuntu_18.04' ]
then
	echo -e "\033[33m You have chosen to install the latest Ubuntu_18.04 \033[0m"
	echo -e "\n"
	sleep 5s
	wget --no-check-certificate -qO Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/Core_Install.sh' && bash Core_Install.sh -u 18.04 -v 64 -a
fi

if [ $1 = '-Ubuntu_16.04' ]
then
	echo -e "\033[33m You have chosen to install the latest Ubuntu_16.04 \033[0m"
	echo -e "\n"
	sleep 5s
	wget --no-check-certificate -qO Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/Core_Install.sh' && bash Core_Install.sh -u 16.04 -v 64 -a
fi

if [ $1 = '-DD' ]
then
	echo -e "\033[33m You have chosen to install the DD package provided by you \033[0m"
	echo -e "\n"
	sleep 5s
	wget --no-check-certificate -qO Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/Core_Install.sh' && bash Core_Install.sh -dd $2
fi




if [ $1 = '-CentOS_6' ]
then
	echo -e "\033[33m You have chosen to install the latest CentOS_6 \033[0m"
	echo -e "\n"
	sleep 5s
	wget --no-check-certificate -qO Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/Core_Install.sh' && bash Core_Install.sh -c 6.10 -v 64 -a
fi

if [ $1 = '-Debian_8' ]
then
	echo -e "\033[33m You have chosen to install the latest Debian_8 \033[0m"
	echo -e "\n"
	sleep 5s
	wget --no-check-certificate -qO Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/Core_Install.sh' && bash Core_Install.sh -d 8 -v 64 -a
fi

if [ $1 = '-Debian_7' ]
then
	echo -e "\033[33m You have chosen to install the latest Debian_7 \033[0m"
	echo -e "\033[41;30m !!! Installing the old system will lead to security risks !!! \033[0m"
	echo -e "\n"
	sleep 8s
	wget --no-check-certificate -qO Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/Core_Install.sh' && bash Core_Install.sh -d 7 -v 64 -a
fi


echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\033[35m Start Installation \033[0m"
echo -e "\033[32m Start Installation \033[0m"
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
exit