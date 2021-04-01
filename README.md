<p align="center">
<img width="210" height="180" align="left" style="float: left; margin: 0 10px 0 0;" src="https://github.com/SavileLee/Oracle/blob/cloud/Lib/oracle.png?raw=true" alt="SavileLee"/>
</br>
<h1>Oracle Cloud<a href="https://dreamstart.site"> For Debian</a></h1>
一键重装Debian\Centos\Ubuntu系统
</p>

[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Linkedin Badge](https://img.shields.io/badge/-Linkedin-1ca0f1?style=ightgrey&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/SavileLee/)](https://www.linkedin.com/in/SavileLee/)
[![Twitter Badge](https://img.shields.io/badge/-Twitter-1ca0f1?style=lightgrey&labelColor=1ca0f1&logo=twitter&logoColor=white&link=https://twitter.com/SavileLee)](https://twitter.com/SavileLee)
[![Gmail Badge](https://img.shields.io/badge/-Gmail-1ca0f1?style=ightgrey&logo=Gmail&logoColor=white&link=mailto:liyesen@gmail.com)](mailto:liyesen@gmail.com)


### 1. 安装所需软件
```
apt-get install -y xz-utils openssl gawk file
```
### 2. 更新APT源
```
apt-get update
```
### 3. 运行脚本，命令中的 -d 后面为Debian版本号，-v 后面为64位/32位
```
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/SavileLee/Oracle/cloud/LinuxNET.sh') -d 9 -v 64 -a
```
### 4. 建议：
```
已测试原系统Ubuntu16.04安装成功，建议使用
- 默认用户名：root
- 默认密码：dreamstart.site
```

## ReInstall Debian 10
```
bash <(wget --no-check-certificate -qO- 'https://SavileLee.github.io/LinuxNET.sh') -d 10 -v 64 -a -firmware
```
## Install DD系统
```
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/LinuxNET.sh') -dd "https://****.***/***.x64.tar.gz"
```
## Timezone
```
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" >/etc/timezone
```

## Root
```
#!/bin/bash
echo root:Vicer |sudo chpasswd root
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo reboot
```
