#!/bin/bash

## License: MIT
## It can reinstall Debian, Ubuntu, CentOS system with network.
## Default root password: dreamstart.site
## BLOG: https://dreamstart.site


function CopyRight() {
  clear
  echo "                                                           "
  echo "================================================================"
  echo "=                                                              ="
  echo "=           一键网络重装系统 （图形化安装）                    ="
  echo "=        Network-Reinstall-System (Graphical Install)          ="
  echo "=                                                              ="
  echo "=                                https://www.dreamstart.site   ="
  echo "=                                                              ="
  echo "================================================================"
  echo "=   --------------------------------------------------------   ="
  echo "=   默认root密码：dreamstart.site                              ="
  echo "=   Default root password: dreamstart.site                     ="
  echo "=   --------------------------------------------------------   ="
  echo "================================================================"
  echo -e "\n"
  sleep 2s
}

CopyRight
if [[ $EUID -ne 0 ]]; then
	1>&2
  echo "================================================================"
  echo "Error:当前用户不是 root 用户,请切换到 root 用户重新执行脚本. . ." 
  echo "================================================================"
  echo -e "\n"
  sleep 1s
    exit 1
fi

  echo "================================================================"
  echo " 安装环境准备中 Pre-environment preparation. . ."
  echo "================================================================"
  echo -e "\n"
  sleep 2s

if [ -f "/usr/bin/apt-get" ];then
	isDebian=`cat /etc/issue|grep Debian`
	if [ "$isDebian" != "" ];then
		echo 'Current system is Debian'
		apt-get install -y xz-utils openssl gawk file wget curl
		apt install -y xz-utils openssl gawk file wget curl
    sleep 2s
	else
		echo 'Current system is Ubuntu'
		apt-get install -y xz-utils openssl gawk file wget curl
		apt install -y xz-utils openssl gawk file wget curl
    sleep 2s
	fi
else
    echo 'Current system is CentOS'
    yum install -y xz openssl gawk file wget curl
    sleep 2s
  fi
CopyRight
  echo "================================================================"
  echo " 初始化完成. . . Pre-environment preparation. . . 【OK】"
  echo -e "\n"
  echo " 开始系统安装  Start system installation. . . "
  echo "================================================================"
  echo -e "\n"
  sleep 1s

if [ -f "/tmp/Core_Install.sh" ]; then
    rm -f /tmp/Core_Install.sh
  fi
  wget --no-check-certificate -qO /tmp/Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/LinuxNET.sh' && chmod a+x /tmp/Core_Install.sh

  echo -e "\n\n\n"
  clear
  echo -e "\n"
  echo "                                                           "
  echo "================================================================"
  echo "=                                                              ="
  echo "=           一键网络重装系统 （图形化安装）                    ="
  echo "=        Network-Reinstall-System (Graphical Install)          ="
  echo "=                                                              ="
  echo "=                                https://www.dreamstart.site   ="
  echo "=                                                              ="
  echo "================================================================"
  echo "=   --------------------------------------------------------   ="
  echo "=   默认root密码：dreamstart.site                              ="
  echo "=   Default root password: dreamstart.site                     ="
  echo "=   --------------------------------------------------------   ="
  echo "================================================================"
  echo "                                                                "
  echo "Which System do you want to Install:"
  echo "                                                                "
  echo "  1) Latest 【CentOS 8】(DD Image)"                                                               
  echo "  2) Latest 【CentOS 7】(DD Image)"
  echo "  3) Latest 【CentOS 6】"
  echo "                                                                "
  echo "  4) Latest 【Debian 10】(Recommend)"
  echo "  5) Latest 【Debian 9】"
  echo "                                                                "
  echo "  6) Latest 【Ubuntu 20.04】(Recommend)"
  echo "  7) Latest 【Ubuntu 18.04】"
  echo "  8) Latest 【Ubuntu 16.04】"
  echo "                                                                "
  echo "                                                                "
  echo "  ======安装其他系统请确保系统来源可靠，否则不建议使用。======  "
  echo "  =======  Please make sure the source of the system   =======  "
  echo "  =======is reliable, otherwise it is not recommended. =======  "
  echo "                                                                "
  echo "  9) Latest 【DD System】"
  echo "  0) Exit"
  echo "                                                                "
  echo "                                                                "
  echo "================================================================"
  echo "                                                                "
  echo -ne "\nEnter the System Identification Nnumber (for example: 0)"
  read N
  case $N in
  	1) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/Core_Install.sh  -c 8 -v 64 -a -firmware ;;
    2) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/Core_Install.sh -c 7 -v 64 -a -firmware ;;
    3) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/Core_Install.sh -c 6.10 -v 64 -a -firmware ;;
    4) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/Core_Install.sh -d 10 -v 64 -a -firmware ;;
    5) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/Core_Install.sh -d 10 -v 64 -a -firmware ;;
    6) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; sed -i 's#images/netboot#legacy-images/netboot#' /tmp/Core_Install.sh; bash /tmp/Core_Install.sh -u 20.04 -v 64 -a ;;
    7) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/Core_Install.sh -u 18.04 -v 64 -a ;;
    8) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/Core_Install.sh -u 16.04 -v 64 -a ;;
    9)
      echo -e "\n"
      read -r -p "Custom image URL: " imgURL
      echo -e "\n"
      read -r -p "Are you sure start reinstall? [Y/n]: " input
      case $input in
        [yY][eE][sS]|[yY]) bash /tmp/Core_Install.sh -dd "$imgURL" ;;
        *) clear; echo "Canceled by user!"; exit 1;;
      esac
      ;;
    0) exit 0;;
    *) echo "Wrong input!"; exit 1;;
  esac
}
