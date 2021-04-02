# Install Win8.1
```
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/MoeClub/Note/master/InstallNET.sh') -dd "https://api.moeclub.org/redirect/win8.1emb_x64.tar.gz"
```

# Timezone
```
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" >/etc/timezone
```

# Root
```
#!/bin/bash
echo root:***** |sudo chpasswd root
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo reboot
```

# Windows Image
```
# win7emb_x86.tar.gz:
https://api.moeclub.org/GoogleDrive/1srhylymTjYS-Ky8uLw4R6LCWfAo1F3s7 
https://api.moeclub.org/redirect/win7emb_x86.tar.gz

# win8.1emb_x64.tar.gz:
https://api.moeclub.org/GoogleDrive/1cqVl2wSGx92UTdhOxU9pW3wJgmvZMT_J
https://api.moeclub.org/redirect/win8.1emb_x64.tar.gz

# win10ltsc_x64.tar.gz:
https://api.moeclub.org/GoogleDrive/1OVA3t-ZI2arkM4E4gKvofcBN9aoVdneh
https://api.moeclub.org/redirect/win10ltsc_x64.tar.gz
```

# Linux sysctl.conf
```
# This line below add by user.
fs.file-max = 104857600
fs.nr_open = 1048576
vm.overcommit_memory = 1
net.ipv4.ip_forward = 1
net.core.somaxconn = 4096
net.core.optmem_max = 262144
net.core.rmem_max = 8388608
net.core.wmem_max = 8388608
net.core.rmem_default = 262144
net.core.wmem_default = 262144
net.core.netdev_max_backlog = 65536
net.ipv4.tcp_mem = 262144 6291456 8388608
net.ipv4.tcp_rmem = 16384 262144 8388608
net.ipv4.tcp_wmem = 8192 262144 8388608
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_syn_retries = 4
net.ipv4.tcp_synack_retries = 3
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_fin_timeout = 24
net.ipv4.tcp_keepalive_intvl = 32
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_time = 900
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 8
#net.ipv4.icmp_echo_ignore_all = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_slow_start_after_idle = 0
#net.ipv4.tcp_fastopen = 3
#net.core.default_qdisc = fq
#net.ipv4.tcp_congestion_control = bbr

```
