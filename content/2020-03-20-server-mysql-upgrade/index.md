---
title: '[MySQL] Centos7 에서 MySQL 5.6을 5.7로 업그레이드'
date: 2020-03-20 08:05:34
author: TMM
categories: Server
tags: MySQL upgrade
---

5.6은 JSON 지원이 안되네요.<br />
그래서 업그레이드를 하기로 했습니다.

### 서비스 중지

```bash
$ sudo systemctl stop mysqld
```

### MySQL5.6 백업

```bash
$ sudo cp -r /var/lib/mysql /var/lib/mysql.original
```

### MySQL5.6 RPM 삭제

```bash
$ yum remove mysql-community-release
```

### wget 설치

```bash
$ yum install wget
```

### MySQL5.7 다운로드

```bash
$ wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
```

### MySQL 설치

```bash
$ sudo rpm -ivh mysql57-community-release-el7-11.noarch.rpm
```

### MySQL 서버 업그레이드

```bash
$ sudo yum update mysql-server
```

### 서비스 시작

```bash
$ sudo systemctl start mysqld
```

### 확인

```bash
$ mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 5
Server version: 5.7.29 MySQL Community Server (GPL)

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

```toc

```
