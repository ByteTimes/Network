<p align="center">
<img width="210" height="180" align="left" style="float: left; margin: 0 10px 0 0;" src="https://github.com/SavileLee/Oracle/blob/cloud/Lib/oracle.png?raw=true" alt="SavileLee"/>

<h1>Oracle Cloud<a href="https://dreamstart.site"> For System</a></h1>
一键重装Debian\Centos\Ubuntu系统
</p>

[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Linkedin Badge](https://img.shields.io/badge/-Linkedin-1ca0f1?style=ightgrey&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/SavileLee/)](https://www.linkedin.com/in/SavileLee/)
[![Twitter Badge](https://img.shields.io/badge/-Twitter-1ca0f1?style=lightgrey&labelColor=1ca0f1&logo=twitter&logoColor=white&link=https://twitter.com/SavileLee)](https://twitter.com/SavileLee)
[![Gmail Badge](https://img.shields.io/badge/-Gmail-1ca0f1?style=ightgrey&logo=Gmail&logoColor=white&link=mailto:liyesen@gmail.com)](mailto:liyesen@gmail.com)


### 支持重装的系统：
```
Debian 9/10
Ubuntu 18.04/16.04
CentOS 6/7
自定义DD镜像
```
### 特性/优化：
```
自动获取IP地址、网关、子网掩码
自动判断网络环境，选择国内/外镜像，再也不用担心卡半天了
超级懒人一键化，无需复杂的命令
解决萌咖脚本中一些导致安装错误的问题
CentOS 7 镜像抛弃LVM，回归ext4，减少不稳定因素
```
### 使用方法：
```
wget --no-check-certificate -O AutoReinstall.sh https://savilelee.github.io/Oracle/AutoReinstall.sh && bash AutoReinstall.sh
```
### 初始密码：
```
- 默认用户名：root
- 默认密码：dreamstart.site
```

### 直接ReInstall Debian 10，命令中的 -d 后面为Debian版本号，-v 后面为64位/32位
```
bash <(wget --no-check-certificate -qO- 'https://savilelee.github.io/Oracle/LinuxNET.sh') -d 10 -v 64 -a -firmware
```
### 建议初始系统Ubuntu16.04，经测试使用非常稳定，需要安装下面的组件：
#### 1. 安装所需软件
```
apt-get install -y xz-utils openssl gawk file
```
#### 2. 更新APT源
```
apt-get update
```

### Install DD系统
```
bash <(wget --no-check-certificate -qO- 'https://savilelee.github.io/Oracle/LinuxNET.sh') -dd "https://****.***/***.x64.tar.gz"
```
### Timezone
```
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" >/etc/timezone
```

### Root
```
#!/bin/bash
echo root:***** |sudo chpasswd root
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo reboot
```
