#!/bin/bash

## License: MIT
## It can reinstall Debian, Ubuntu, CentOS system with network.
## Default root password: dreamstart.site
## BLOG: https://dreamstart.site

# 字体颜色配置
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
Blue="\033[36m"
Font="\033[0m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
OK="${Green}[OK]${Font}"
ERROR="${Red}[ERROR]${Font}"

# 全局设置
CentOS_8='0'
CentOS_7='0'
CentOS_6='0'
Debian_10='0'
Debian_9='0'
Ubuntu_20='0'
Ubuntu_18='0'
Ubuntu_16='0'
SPECIFIED_VERSION=''

function line() {
  echo "-------------------------------------------------------------------------------------"
}

function print_ok() {
  echo -e "${OK} ${Blue} $1 ${Font}"
}

function print_error() {
  echo -e "${ERROR} ${RedBG} $1 ${Font}"
}

# 参数判断选择
judgment_parameters() {
  local temp_version='0'
  while [[ "$#" -gt '0' ]]; do
    case "$1" in
      '-CentOS_8')
        CentOS_8='1'
        ;;
      '-CentOS_7')
        CentOS_7='1'
        ;;
      '-CentOS_6')
        CentOS_6='1'
        ;;
      '-Debian_10')
        Debian_10='1'
        ;;
      '-Debian_9')
        Debian_9='1'
        ;;
      '-Ubuntu_20.04')
        Ubuntu_20='1'
        ;;
      '-Ubuntu_18.04')
        Ubuntu_18='1'
        ;;
      '-Ubuntu_16.04')
        Ubuntu_16='1'
        ;;
      '--version')
        if [[ -z "$2" ]]; then
          print_error "Please specify the correct version."
          exit 1
        fi
        temp_version='1'
        SPECIFIED_VERSION="$2"
        shift
        ;;
    esac
    shift
  done
  if ((CentOS_8+CentOS_7+CentOS_6+Debian_10+Debian_9+Ubuntu_20+Ubuntu_18+Ubuntu_16==0)); then
    INSTALL='1'
  elif ((CentOS_8+CentOS_7+CentOS_6+Debian_10+Debian_9+Ubuntu_20+Ubuntu_18+Ubuntu_16>1)); then
    print_error "您只能选择一项操作 "
    exit 1
  fi
  if [[ "$INSTALL" -eq '1' ]] && ((temp_version+CentOS_8+CentOS_7+CentOS_6+Debian_10+Debian_9+Ubuntu_20+Ubuntu_18+Ubuntu_16>1)); then
    print_error"错误的版本信息，并且您只能选择一项操作"
    exit 1
  fi
  # Parameter information
  [[ "$CentOS_8" -eq '1' ]] && CentOS_8
  [[ "$CentOS_7" -eq '1' ]] && CentOS_7
  [[ "$CentOS_6" -eq '1' ]] && CentOS_6
  [[ "$Debian_10" -eq '1' ]] && Debian_10
  [[ "$Debian_9" -eq '1' ]] && Debian_9
  [[ "$Ubuntu_20" -eq '1' ]] && Ubuntu_20.04
  [[ "$Ubuntu_18" -eq '1' ]] && Ubuntu_18.04
  [[ "$Ubuntu_16" -eq '1' ]] && Ubuntu_16.04
}

function CopyRight() {
  clear
  echo "                                                           "
  echo "      ┌──────────────────────────────────────────────────────────────────────┐"
  echo "      │                                                                      │"
  echo "      │                一键网络重装系统 （图形化安装）                       │"
  echo "      │            Network-Reinstall-System (Graphical Install)              │"
  echo "      │                                                                      │"
  echo "      │                                    https://www.dreamstart.site       │"
  echo "      │                                                                      │"
  echo "      ├──────────────────────────────────────────────────────────────────────┤"
  echo "      │       --------------------------------------------------------       │"
  echo "      │       默认root密码：dreamstart.site                                  │"
  echo "      │       Default root password: dreamstart.site                         │"
  echo "      │       --------------------------------------------------------       │"
  echo "      └──────────────────────────────────────────────────────────────────────┘"
  echo -e "\n"
}

function isRoot_Check() {
  CopyRight
  if [[ 0 == "$UID" ]]; then
    line
    print_ok "当前用户是 root 用户，开始安装流程. . ."
    sleep 1s
  else
    line
    print_error "当前用户不是root用户,请切换到root用户重新执行脚本" 
    echo -e "\n"
    exit 1
  fi
}

function System_Check(){
  CopyRight
  line
  source '/etc/os-release'
  print_ok "安装环境准备中 Pre-environment preparation. . ."
  if [[ "${ID}" == "centos" && ${VERSION_ID} -ge 6 ]]; then
    print_ok "当前系统为 Centos ${VERSION_ID} ${VERSION}"
    INS="yum install -y"
    yum update
    $INS xz openssl gawk file wget curl

  elif [[ "${ID}" == "debian" && ${VERSION_ID} -ge 9 ]]; then
    print_ok "当前系统为 Debian ${VERSION_ID} ${VERSION}"
    INS="apt install -y"
    apt update
    $INS xz-utils openssl gawk file wget curl
  elif [[ "${ID}" == "ubuntu" && $(echo "${VERSION_ID}" | cut -d '.' -f1) -ge 16 ]]; then
    print_ok "当前系统为 Ubuntu ${VERSION_ID} ${UBUNTU_CODENAME}"
    INS="apt install -y"
    apt update
    $INS xz-utils openssl gawk file wget curl
   else
    print_error "当前系统为 ${ID} ${VERSION_ID} 不在支持的系统列表内"
    exit 1
  fi
  line
  print_ok "初始化完成 Pre-environment preparation. . ."
  print_ok "开始系统安装  Start system installation. . . "
  line
  sleep 3s
}

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
  CopyRight
  line
  if [ "$isAuto" == '0' ]; then
    read -r -p "是否使用DHCP自动配置网络 Using DHCP to Configure Network Automatically? [Y/n]:" input
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
      echo -e "未检测到正确IP信息，请手动输入 Error Detecting IP. Please input manually..\n"
      UpdateIp
    else
      CopyRight
      line
      echo "IP: $MAINIP"
      echo "Gateway: $GATEWAYIP"
      echo "Netmask: $NETMASK"
      echo -e "\n"
      read -r -p "确认，或者手动配置IP Confirm，Or Manually Configure IP？ [Y/n]:" input
      case $input in
        [yY][eE][sS]|[yY]) ;;
        [nN][oO]|[nN])
          echo -e "\n"
          UpdateIp
          ipCheck
          [[ $? -ne 0 ]] && {
            clear
            CopyRight
            line
            echo -e "输入错误,自动退出 INPUT Error，Auto Exit. . .\n"
            exit 1
          }
        ;;
      esac
    fi
    NETSTR="--ip-addr ${MAINIP} --ip-gate ${GATEWAYIP} --ip-mask ${NETMASK}"
  fi
}

function Mirror_Check() {
  isCN='0'
  geoip=$(wget --no-check-certificate -qO- https://api.ip.sb/geoip -T 10 | grep "\"country_code\":\"CN\"")
  if [[ "$geoip" != "" ]];then
    isCN='1'
  fi

  if [ "$isAuto" == '0' ]; then
    echo -e "\n"
    print_ok "使用默认DHCP模式 Using DHCP mode."
  else
    print_ok "IP: $MAINIP"
    print_ok "Gateway: $GATEWAYIP"
    print_ok "Netmask: $NETMASK"
  fi

  [[ "$isCN" == '1' ]] && print_ok "检测服务器IP在中国大陆，使用中国境内镜像地址 Using domestic mode."

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
  echo "      ┌──────────────────────────────────────────────────────────────────────┐"
  echo "      │                                                                      │"
  echo "      │                一键网络重装系统 （图形化安装）                       │"
  echo "      │            Network-Reinstall-System (Graphical Install)              │"
  echo "      │                                                                      │"
  echo "      │                                    https://www.dreamstart.site       │"
  echo "      │                                                                      │"
  echo "      ├──────────────────────────────────────────────────────────────────────┤"
  echo "      │       --------------------------------------------------------       │"
  echo "      │       默认root密码：dreamstart.site                                  │"
  echo "      │       Default root password: dreamstart.site                         │"
  echo "      │       --------------------------------------------------------       │"
  echo "      ├──────────────────────────────────────────────────────────────────────┤"
  echo "      │                                                                      │"
  echo "      │      选择你想安装的系统 Which System Install:                        │"
  echo "      │                                                                      │"
  echo "      │      1) Latest 【CentOS 8】(DD Image)                                │"                                                           
  echo "      │      2) Latest 【CentOS 7】(DD Image)                                │"
  echo "      │      3) Latest 【CentOS 6】                                          │"
  echo "      │                                                                      │"
  echo "      │      4) Latest 【Debian 10】(Recommend)                              │"
  echo "      │      5) Latest 【Debian 9】                                          │"
  echo "      │                                                                      │"
  echo "      │      6) Latest 【Ubuntu 20.04】(Recommend)                           │"
  echo "      │      7) Latest 【Ubuntu 18.04】                                      │"
  echo "      │      8) Latest 【Ubuntu 16.04】                                      │"
  echo "      │                                                                      │"
  echo "      │     ------安装其他系统请确保系统来源可靠，否则不建议使用。------     │"
  echo "      │     ------   Please make sure the source of the system    ------     │"
  echo "      │     ------ is reliable, otherwise it is not recommended.  ------     │"
  echo "      │                                                                      │"
  echo "      │      9) Latest 【DD System】                                         │"
  echo "      │      0) Exit                                                         │"
  echo "      │                                                                      │"
  echo "      └──────────────────────────────────────────────────────────────────────┘"
  line
  print_ok " 请输入数字选择 Enter the System Identification Nnumber : "
  read Num
  case $Num in
    1) CentOS_8 ;;
    2) CentOS_7 ;;
    3) CentOS_6 ;;
    4) Debian_10 ;;
    5) Debian_9 ;;
    6) Ubuntu_20.04 ;;
    7) Ubuntu_18.04 ;;
    8) Ubuntu_16.04;;
    9)
      echo -e "\n"
      CopyRight
      line
      read -r -p "请输入系统镜像地址 Custom image URL: " imgURL
      Install_start
      bash /tmp/Core_Install.sh $NETSTR -dd $imgURL $DMIRROR ;;
    0) exit 0;;
    *) echo "错误输入，自动退出… Wrong input，Auto Exit..."; exit 1;;
  esac
}

function Install_start() {
  System_Check
  SetNetwork
  NetMode
  Mirror_Check
  if [ -f "/tmp/Core_Install.sh" ]; then
    rm -f /tmp/Core_Install.sh
  fi
  wget --no-check-certificate -qO /tmp/Core_Install.sh 'https://savilelee.github.io/Network/CoreFiles/Core_Install.sh' && chmod a+x /tmp/Core_Install.sh
  echo -e "\nPassword: dreamstart.site\n"; read -s -n1 -p "按任意键继续,Ctrl+C退出... Press any key to continue, Ctrl+C to Exit..." ; 
}

function CentOS_8() {
  Install_start
  bash /tmp/Core_Install.sh -c 8 -v 64 -a -firmware $NETSTR $CMIRROR
}

function CentOS_7() {
  Install_start
  bash /tmp/Core_Install.sh -c 7.9.2009 -v 64 -a -firmware $NETSTR $CMIRROR
}

function CentOS_6() {
  Install_start
  bash /tmp/Core_Install.sh -c 6.10 -v 64 -a -firmware $NETSTR $CMIRROR
}

function Debian_10() {
  Install_start
  bash /tmp/Core_Install.sh -d 10 -v 64 -a -firmware $NETSTR $CMIRROR
}

function Debian_9() {
  Install_start
  bash /tmp/Core_Install.sh -d 9 -v 64 -a -firmware $NETSTR $CMIRROR
}

function Ubuntu_20.04() {
  Install_start
  bash /tmp/Core_Install.sh -u 20.04 -v 64 -a -firmware $NETSTR $CMIRROR
}

function Ubuntu_18.04() {
  Install_start
  bash /tmp/Core_Install.sh -u 18.04 -v 64 -a -firmware $NETSTR $CMIRROR
}

function Ubuntu_16.04() {
  Install_start
  bash /tmp/Core_Install.sh -u 16.04 -v 64 -a -firmware $NETSTR $CMIRROR
}


isRoot_Check
judgment_parameters "$@"
MENU "$@"

