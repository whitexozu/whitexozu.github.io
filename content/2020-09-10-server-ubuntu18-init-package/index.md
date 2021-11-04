---
title: '[Ubuntu 18] Initial install package'
date: 2020-09-10 08:05:34
author: TMM
categories: SERVER
tags: ubuntu 18
---

ubuntu 18 설치 후 초기 설치들입니다.

## 노트북 전원유지

```bash
$ sudo vi /etc/systemd/logind.conf

...
#HandleLidSwitch=suspend
# 위 내용을 아래 내용으로 변경
HandleLidSwitch=ignore
...

$ systemctl restart systemd-logind
```

## root 비밀번호 설정

- sudo passwd

## network

- sudo lshw -C Network
  - 네트워크 확인
- /etc/netplan

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp2s0:
     dhcp4: no
     addresses: [192.168.1.101/24]
     gateway4: 192.168.1.1
     nameservers:
       addresses: [210.220.163.82,219.250.36.130]
  wifis:
    wlp2s0:
      dhcp4: no
      dhcp6: no
      addresses: [192.168.0.102/24]
      gateway4: 192.168.0.1
      nameservers:
        addresses: [210.220.163.82,219.250.36.130]
      access-points:
        MGHouse
          password: 04010501
```

## ssh

- sudo agt-get install ssh
- sudo service ssh start

## add user

- sudo adduser meetphin
- sudo passwd meetphin
- sudo groupadd dev
- sudo usermod -a -G sudo meetphin
- sudo usermod -d /var/dev/python user

## git

- sudo apt-get install git

## dockr

- curl -fsSL https://get.docker.com/ | sudo sh

## docker-compose

- sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-\$(uname -m)" -o /usr/local/bin/docker-compose
- sudo chmod +x /usr/local/bin/docker-compose

## nvm

- sudo apt-get install build-essential libssl-dev
- curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
- source ~/.bashrc

## 참고 사이트

- usermod: https://blog.leocat.kr/notes/2018/01/22/linux-add-user-to-groups

```toc

```
