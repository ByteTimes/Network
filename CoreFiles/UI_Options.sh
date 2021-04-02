#!/bin/bash

## License: MIT
## It can reinstall Debian, Ubuntu, CentOS system with network.
## Default root password: dreamstart.site
## BLOG: https://dreamstart.site

wget -N --no-check-certificate https://savilelee.github.io/Network/Network-Reinstall.sh && chmod a+x Network-Reinstall.sh

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
echo "                                                                "
ech="Which System do you want to Install:"
echo "                                                                "
echo "                                                                "
echo "  0) Latest 【CentOS 8】(Recommend)"
echo "  1) Latest 【CentOS 7】"
echo "                                                                "
echo "  2) Latest 【Debian 10】(Recommend)"
echo "  3) Latest 【Debian 9】"
echo "                                                                "
echo "  4) Latest 【Ubuntu 20.04】(Recommend)"
echo "  5) Latest 【Ubuntu 18.04】"
echo "  6) Latest 【Ubuntu 16.04】"
echo "                                                                "
echo "                                                                "
echo "  ======以下系统已经过时，失去官方技术支持，不推荐使用。======  "
echo "  ====== The system is outdated and is not recommended. ======  "
echo "                                                                "
echo "  7) Latest 【CentOS 6】"
echo "  8) Latest 【Debian 8】"
echo "  9) Latest 【Debian 7】"
echo "  10) Latest 【DD System】"
echo "                                                                "
echo '  Custom DD System：bash Network-Reinstall.sh -DD "%URL%" '
echo "                                                                "
echo "================================================================"
echo "                                                                "
echo -n "Enter the System Identification Nnumber (for example: 0)"
read Num
case $Num in
  0) bash Network-Reinstall.sh -CentOS_8 ;;
  1) bash Network-Reinstall.sh -CentOS_7 ;;
  2) bash Network-Reinstall.sh -Debian_10 ;;
  3) bash Network-Reinstall.sh -Debian_9 ;;
  4) bash Network-Reinstall.sh -Ubuntu_20.04 ;;
  5) bash Network-Reinstall.sh -Ubuntu_18.04 ;;
  6) bash Network-Reinstall.sh -Ubuntu_16.04;;
 
  7) bash Network-Reinstall.sh -CentOS_6 ;;
  8) bash Network-Reinstall.sh -Debian_8 ;;
  9) bash Network-Reinstall.sh -Debian_7 ;;
  10) bash Network-Reinstall.sh -DD ;;

  *) echo "Wrong input, please enter again!" ;;
esac