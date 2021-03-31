<p align="center">
<img width="210" height="180" align="left" style="float: left; margin: 0 10px 0 0;" src="https://raw.githubusercontent.com/SavileLee/Oracle/cloud/Lib/oracle.png" alt="SavileLee"/>
</br>
<h1>Oracle Cloud<a href="https://dreamstart.site"> For Debian</a></h1>
一键重装Debian\Centos\Ubuntu系统
</p>

[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Linkedin Badge](https://img.shields.io/badge/-Linkedin-1ca0f1?style=ightgrey&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/SavileLee/)](https://www.linkedin.com/in/SavileLee/)
[![Twitter Badge](https://img.shields.io/badge/-Twitter-1ca0f1?style=lightgrey&labelColor=1ca0f1&logo=twitter&logoColor=white&link=https://twitter.com/SavileLee)](https://twitter.com/SavileLee)
[![Gmail Badge](https://img.shields.io/badge/-Gmail-1ca0f1?style=ightgrey&logo=Gmail&logoColor=white&link=mailto:liyesen@gmail.com)](mailto:liyesen@gmail.com)

# 安装前环境说明
　　- 初始系统为Ubuntu 16

　　- 即将安装的系统为Debian 10

# 方法
## 1. 安装所需软件
apt-get install -y xz-utils openssl gawk file
## 2. 更新源
apt-get update
## 3. 运行脚本，命令中的 -d 后面为Debian版本号，-v 后面为64位/32位，可根据需求进行替换
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/SavileLee/Oracle/cloud/LinuxNET.sh') -d 10 -v 64 -a -firmware

　　大概等待十几分钟就可以正常进入系统了，期间可通过VNC查看进度或者Ping IP的状态来判断系统是否启动成功，如果使用Ping来判断时，请注意Oracle安全组默认是禁Ping的，需要放行ICMP或者使用Tcp Ping，系统启动成功后的默认用户名：root，默认密码：MoeClub.org，为了安全，请及时登录系统修改密码。
