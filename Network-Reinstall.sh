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
sleep 2s

if [[ $EUID -ne 0 ]]; then
	1>&2
echo "---------------------------------------------------------------------------------------------------------------------"
echo " Error: The current user is not the root user, please switch to the root user and re-execute the script…" 
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
sleep 1s
    exit 1
fi

echo "---------------------------------------------------------------------------------------------------------------------"
echo " Pre-environment preparation. . ."
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
sleep 2s


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

function isValidIp() {
  local ip=$1
  local ret=1
  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    ip=(${ip//\./ })
    [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
    ret=$?
  fi
  return $ret
}

function ipCheck() {
  isLegal=0
  for add in $MAINIP $GATEWAYIP $NETMASK; do
    isValidIp $add
    if [ $? -eq 1 ]; then
      isLegal=1
    fi
  done
  return $isLegal
}

function GetIp() {
  MAINIP=$(ip route get 1 | awk -F 'src ' '{print $2}' | awk '{print $1}')
  GATEWAYIP=$(ip route | grep default | awk '{print $3}' | head -1)
  SUBNET=$(ip -o -f inet addr show | awk '/scope global/{sub(/[^.]+\//,"0/",$4);print $4}' | head -1 | awk -F '/' '{print $2}')
  value=$(( 0xffffffff ^ ((1 << (32 - $SUBNET)) - 1) ))
  NETMASK="$(( (value >> 24) & 0xff )).$(( (value >> 16) & 0xff )).$(( (value >> 8) & 0xff )).$(( value & 0xff ))"
}

function UpdateIp() {
  read -r -p "Your IP: " MAINIP
  read -r -p "Your Gateway: " GATEWAYIP
  read -r -p "Your Netmask: " NETMASK
}

function SetNetwork() {
  isAuto='0'
  if [[ -f '/etc/network/interfaces' ]];then
    [[ ! -z "$(sed -n '/iface.*inet static/p' /etc/network/interfaces)" ]] && isAuto='1'
    [[ -d /etc/network/interfaces.d ]] && {
      cfgNum="$(find /etc/network/interfaces.d -name '*.cfg' |wc -l)" || cfgNum='0'
      [[ "$cfgNum" -ne '0' ]] && {
        for netConfig in `ls -1 /etc/network/interfaces.d/*.cfg`
        do
          [[ ! -z "$(cat $netConfig | sed -n '/iface.*inet static/p')" ]] && isAuto='1'
        done
      }
    }
  fi

  if [[ -d '/etc/sysconfig/network-scripts' ]];then
    cfgNum="$(find /etc/network/interfaces.d -name '*.cfg' |wc -l)" || cfgNum='0'
    [[ "$cfgNum" -ne '0' ]] && {
      for netConfig in `ls -1 /etc/sysconfig/network-scripts/ifcfg-* | grep -v 'lo$' | grep -v ':[0-9]\{1,\}'`
      do
        [[ ! -z "$(cat $netConfig | sed -n '/BOOTPROTO.*[sS][tT][aA][tT][iI][cC]/p')" ]] && isAuto='1'
      done
    }
  fi
}

function NetMode() {

  if [ "$isAuto" == '0' ]; then
echo "---------------------------------------------------------------------------------------------------------------------"
    read -r -p "Using DHCP to configure network automatically? [Y/n]:" input
echo "---------------------------------------------------------------------------------------------------------------------"    
    case $input in
      [yY][eE][sS]|[yY]) NETSTR='' ;;
      [nN][oO]|[nN]) isAuto='1' ;;
      *) NETSTR='' ;;
    esac
  fi

  if [ "$isAuto" == '1' ]; then
    GetIp
    ipCheck
    if [ $? -ne 0 ]; then
      echo "---------------------------------------------------------------------------------------------------------------------"
      echo -e "Error occurred when detecting ip. Please input manually.\n"
      echo "---------------------------------------------------------------------------------------------------------------------"
      UpdateIp
    else
      echo "IP: $MAINIP"
      echo "Gateway: $GATEWAYIP"
      echo "Netmask: $NETMASK"
      echo -e "\n"
      read -r -p "Confirm? [Y/n]:" input
      case $input in
        [yY][eE][sS]|[yY]) ;;
        [nN][oO]|[nN])
          echo -e "\n"
          UpdateIp
          ipCheck
          [[ $? -ne 0 ]] && {
            clear
            echo -e "Input error!\n"
            exit 1
          }
        ;;
        *) clear; echo "Canceled by user!"; exit 1;;
      esac
    fi
    NETSTR="--ip-addr ${MAINIP} --ip-gate ${GATEWAYIP} --ip-mask ${NETMASK}"
  fi
}

function Start() {
  isCN='0'
  geoip=$(wget --no-check-certificate -qO- https://api.ip.sb/geoip -T 10 | grep "\"country_code\":\"CN\"")
  if [[ "$geoip" != "" ]];then
    isCN='1'
  fi

  if [ "$isAuto" == '0' ]; then
    echo "Using DHCP mode."
  else
    echo "IP: $MAINIP"
    echo "Gateway: $GATEWAYIP"
    echo "Netmask: $NETMASK"
  fi

  [[ "$isCN" == '1' ]] && echo "Using domestic mode."

  if [ -f "/tmp/InstallNET.sh" ]; then
    rm -f /tmp/InstallNET.sh
  fi
  wget --no-check-certificate -qO /tmp/InstallNET.sh 'https://savilelee.github.io/Network/CoreFiles/LinuxNET.sh' && chmod a+x /tmp/InstallNET.sh

  CMIRROR=''
  CVMIRROR=''
  DMIRROR=''
  UMIRROR=''
  if [[ "$isCN" == '1' ]];then
    CMIRROR="--mirror http://mirrors.aliyun.com/centos/"
    CVMIRROR="--mirror http://mirrors.tuna.tsinghua.edu.cn/centos-vault/"
    DMIRROR="--mirror http://mirrors.aliyun.com/debian/"
    UMIRROR="--mirror http://mirrors.aliyun.com/ubuntu/"
  fi

  sed -i "/18.04/a\        [[ \"\$isDigital\" == \'20.04\' ]] && DIST=\'focal\'\;" /tmp/InstallNET.sh
  sed -i '/force-efi-extra-removable/d' /tmp/InstallNET.sh

  echo -e "\nPlease select an OS:"
  echo "  1) CentOS 7.9 (DD Image)"
  echo "  2) CentOS 7.6 (DD Image, ServerSpeeder Avaliable)"
  echo "  3) CentOS 6"
  echo "  4) Debian 9"
  echo "  5) Debian 10"
  echo "  6) Ubuntu 16.04"
  echo "  7) Ubuntu 18.04"
  echo "  8) Ubuntu 20.04"
  echo "  9) Custom image"
  echo "  0) Exit"
  echo -ne "\nYour option: "
  read N
  case $N in
    1) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/InstallNET.sh $NETSTR -dd 'https://api.moetools.net/get/centos-7-image' $DMIRROR ;;
    2) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/InstallNET.sh $NETSTR -dd 'https://api.moetools.net/get/centos-76-image' $DMIRROR ;;
    3) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/InstallNET.sh -c 6.10 -v 64 -a $NETSTR $CMIRROR ;;
    4) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/InstallNET.sh -d 9 -v 64 -a $NETSTR $DMIRROR ;;
    5) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/InstallNET.sh -d 10 -v 64 -a $NETSTR $DMIRROR ;;
    6) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/InstallNET.sh -u 16.04 -v 64 -a $NETSTR $UMIRROR ;;
    7) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; bash /tmp/InstallNET.sh -u 18.04 -v 64 -a $NETSTR $UMIRROR ;;
    8) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "Press any key to continue..." ; sed -i 's#images/netboot#legacy-images/netboot#' /tmp/InstallNET.sh; bash /tmp/InstallNET.sh -u 20.04 -v 64 -a $NETSTR $UMIRROR ;;
    9)
      echo -e "\n"
      read -r -p "Custom image URL: " imgURL
      echo -e "\n"
      read -r -p "Are you sure start reinstall? [Y/n]: " input
      case $input in
        [yY][eE][sS]|[yY]) bash /tmp/InstallNET.sh $NETSTR -dd $imgURL $DMIRROR ;;
        *) clear; echo "Canceled by user!"; exit 1;;
      esac
      ;;
    0) exit 0;;
    *) echo "Wrong input!"; exit 1;;
  esac
}

SetNetwork
NetMode
Start








