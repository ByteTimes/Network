<p align="center">
<img width="210" height="210" align="left" style="float: left; margin: 0 10px 0 0;" src="https://avatars.githubusercontent.com/u/58343733?s=460&u=b8c05d0428f2a7c942a2625cf9898c2fe7cce00a&v=4" alt="SavileLee"/>
</br>
<h1>一键重装 <a href="https://dreamstart.site">Debian\Centos\Ubuntu系统脚本</a></h1>
我们从未留意春秋不见，更不相信曾誓不分离的人，
</br>
有天也会变成一春一秋，咫尺天涯……
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

　　大概等待十几分钟就可以正常进入系统了，期间可通过VNC查看进度或者Ping IP的状态来判断系统是否启动成功，如果使用Ping来判断时，请注意Oracle安全组默认是禁Ping的，需要放行ICMP或者使用Tcp Ping，系统启动成功后的默认用户名：root，默认密码：dreamstart.site，为了安全，请及时登录系统修改密码。