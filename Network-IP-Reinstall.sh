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
  sleep 1s
}


function isRoot_Check(){
if [[ $EUID -ne 0 ]]; then
	1>&2
  echo "================================================================"
  echo "Error:当前用户不是 root 用户,请切换到 root 用户重新执行脚本. . ." 
  echo "================================================================"
  echo -e "\n"
  sleep 1s
    exit 1
fi
}


function System_Check(){
  CopyRight
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

  echo "================================================================"
  echo " 初始化完成. . . Pre-environment preparation. . . 【OK】"
  echo " 开始系统安装  Start system installation. . . "
  echo "================================================================"
  echo -e "\n"
  sleep 3s
}


function isValidIp() {
  CopyRight
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
  CopyRight

  if [ "$isAuto" == '0' ]; then
    echo -e "是否使用DHCP自动配置网络. . .\n"
    read -r -p "Using DHCP to configure network automatically? [Y/n]:" input
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
      echo -e "未检测到正确IP信息，请手动输入. . .\n"
      echo -e "Error occurred when detecting ip. Please input manually.\n"
      UpdateIp
    else
      CopyRight
      echo "IP: $MAINIP"
      echo "Gateway: $GATEWAYIP"
      echo "Netmask: $NETMASK"
      echo -e "\n"
      read -r -p "确认 Confirm? [Y/n]:" input
      case $input in
        [yY][eE][sS]|[yY]) ;;
        [nN][oO]|[nN])
          echo -e "\n"
          UpdateIp
          ipCheck
          [[ $? -ne 0 ]] && {
            clear
            echo -e "输入错误 Input Error. . .\n"
            exit 1
          }
        ;;
        *) clear; echo "已被用户取消 Canceled by user!"; exit 1;;
      esac
    fi
    NETSTR="--ip-addr ${MAINIP} --ip-gate ${GATEWAYIP} --ip-mask ${NETMASK}"
  fi
}

function Start() {
  CopyRight
  isCN='0'
  geoip=$(wget --no-check-certificate -qO- https://api.ip.sb/geoip -T 10 | grep "\"country_code\":\"CN\"")
  if [[ "$geoip" != "" ]];then
    isCN='1'
  fi

  if [ "$isAuto" == '0' ]; then
    echo "使用默认DHCP模式 Using DHCP mode."
  else
    echo "IP: $MAINIP"
    echo "Gateway: $GATEWAYIP"
    echo "Netmask: $NETMASK"
  fi

  [[ "$isCN" == '1' ]] && echo "检测服务器IP在中国，使用中国镜像地址 Using domestic mode."

  if [ -f "/tmp/Core_Install.sh" ]; then
    rm -f /tmp/Core_Install.sh
  fi
  wget --no-check-certificate -qO /tmp/Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/Core_Install.sh' && chmod a+x /tmp/Core_Install.sh

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
}

function MENU() {
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
  echo "=                                                              ="
  echo "=  选择你想安装的系统 Which System Install:                    ="
  echo "=                                                              ="
  echo "=  1) Latest 【CentOS 7.9】(DD Image)                          ="                                                           
  echo "=  2) Latest 【CentOS 7】(DD Image, ServerSpeeder Avaliable)   ="
  echo "=  3) Latest 【CentOS 6】                                      ="
  echo "=                                                              ="
  echo "=  4) Latest 【Debian 10】(Recommend)                          ="
  echo "=  5) Latest 【Debian 9】                                      ="
  echo "=                                                              ="
  echo "=  6) Latest 【Ubuntu 20.04】(Recommend)                       ="
  echo "=  7) Latest 【Ubuntu 18.04】                                  ="
  echo "=  8) Latest 【Ubuntu 16.04】                                  ="
  echo "=                                                              ="
  echo "= ======安装其他系统请确保系统来源可靠，否则不建议使用。====== ="
  echo "= ======   Please make sure the source of the system    ====== ="
  echo "= ====== is reliable, otherwise it is not recommended.  ====== ="
  echo "=                                                              ="
  echo "=  9) Latest 【DD System】                                     ="
  echo "=  0) Exit                                                     ="
  echo "=                                                              ="
  echo "================================================================"
  echo -ne "\nEnter the System Identification Nnumber (for example: 0)"
  read Num
  case $Num in
  	1) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "按任意键继续... Press any key to continue..." ; bash /tmp/Core_Install.sh  $NETSTR -dd 'https://api.moetools.net/get/centos-7-image' $DMIRROR ;;
    2) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "按任意键继续... Press any key to continue..." ; bash /tmp/Core_Install.sh $NETSTR -dd 'https://api.moetools.net/get/centos-76-image' $DMIRROR ;;
    3) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "按任意键继续... Press any key to continue..." ; bash /tmp/Core_Install.sh -c 6.10 -v 64 -a -firmware ;;
    4) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "按任意键继续... Press any key to continue..." ; bash /tmp/Core_Install.sh -d 10 -v 64 -a -firmware $NETSTR $CMIRROR ;;
    5) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "按任意键继续... Press any key to continue..." ; bash /tmp/Core_Install.sh -d 9 -v 64 -a -firmware $NETSTR $CMIRROR ;;
    6) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "按任意键继续... Press any key to continue..." ; bash /tmp/Core_Install.sh -u 20.04 -v 64 -a -firmware $NETSTR $CMIRROR ;;
    7) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "按任意键继续... Press any key to continue..." ; bash /tmp/Core_Install.sh -u 18.04 -v 64 -a -firmware $NETSTR $CMIRROR ;;
    8) echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "按任意键继续... Press any key to continue..." ; bash /tmp/Core_Install.sh -u 16.04 -v 64 -a -firmware $NETSTR $CMIRROR ;;
    9)
      echo -e "\n"
      read -r -p "请输入系统镜像地址 Custom image URL: " imgURL
      echo -e "\n"
      read -r -p "你确定要重装系统吗 Are you sure start reinstall? [Y/n]: " input
      case $input in
        [yY][eE][sS]|[yY]) bash /tmp/Core_Install.sh $NETSTR -dd "$imgURL" $DMIRROR ;;
        *) clear; echo "已被用户取消. . .Canceled by user. . ."; exit 1;;
      esac
      ;;
    0) exit 0;;
    *) echo "错误输入，自动退出. . .Wrong input，Auto EXIT. . ."; exit 1;;
  esac
}

SetNetwork
NetMode
Start
