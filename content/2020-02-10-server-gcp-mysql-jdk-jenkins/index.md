---
title: '[GCP] instance 생성 + Mysql + JDK + Jenkins'
date: 2020-02-10 08:05:34
author: TMM
categories: Server
tags: GCP Mysql JDK Jenkins
---

### Instance 생성

1.  [https://console.cloud.google.com/](https://console.cloud.google.com/)
2.  좌측 상단 대메뉴 > VM 인스턴스
3.  기번정보, 카드정보 입력
4.  Compute Engine 화면이 나오면 약 1분간 대기후 "만들기" 버튼 클릭
5.  인스턴스 만들기에서 지역 한국 선택, 부팅 디스크 CentOS7 선택, 방화벽 모두 선택
6.  VPC 네트워크 설정
    - 외부 IP 주소 목록 > 유형을 고정아이피 선택
    - 필요한 방화벽 규칙 등록

### Mysql 5.7

1.  설치
    ```bash
    $ sudo yum -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
    $ sudo yum -y install mysql-community-server
    $ sudo systemctl enable mysqld
    $ sudo systemctl start mysqld
    ```
2.  보안설정

    ```
    $ /usr/bin/mysql_secure_installation

    Set root password? [Y/n] y
    New password:
    Re-enter new password:
    ... Success!
    Remove anonymous users? [Y/n] y
    ... Success!
    Disallow root login remotely? [Y/n] y
    ... Success!
    Remove test database and access to it? [Y/n] y
    ... Success!
    Reload privilege tables now? [Y/n] y
    ... Success!
    ```

3.  사용자 생성

    ```bash
    $ mysql -u root -p

    > CREATE DATABASE mcs;
    > grant all privileges on mcs.* to 'jhkim'@'localhost' identified by 'p@ssWord';
    > grant all privileges on mcs.* to 'jhkim'@'%' identified by 'p@ssWord';
    ```

4.  문자열 설정

    ```bash
    $ sudo vi /etc/my.cnf

    [clinet]
    default-character-set = utf8

    [mysqld]
    character-set-server=utf8
    collation-server=utf8_general_ci
    init_connect=SET collation_connection = utf8_general_ci
    init_connect=set NAMES utf8

    [mysqldump]
    default-character-set = utf-8
    sudo systemctl restart mysqld
    ```

5.  접속
    ```bash
    $ mysql -u jhkim -p
    $ mysql -h [server ip] -P 3306 -u jhkim -p
    ```

### JDK 설치

1.  다운로드  
    jdk-8u241-linux-x64.tar.gz 랑 비슷한 버젼을 오라클에서 다운받아 GCP 서버에 업로드 한다.
2.  압축해제
    ```bash
    $ gunzip jdk-8u241-linux-x64.tar.gz
    $ tar -xvf jdk-8u241-linux-x64.tar
    ```
3.  자바링크 생성
    ```bash
    $ sudo mv jdk1.8.0_241 /usr/local
    $ cd /usr/local
    $ sudo ln -s jdk1.8.0_241/ java
    ```
4.  환경변수 등록

    ```bash
    $ sudo vi /etc/profile

    JAVA_HOME=/usr/local/java
    CLASSPATH=.:$JAVA_HOME/bin/tools.jar
    PATH=$PATH:$JAVA_HOME/bin
    export JAVA_HOME CLASSPATH PATH
    ```

5.  적용 및 확인
    ```bash
    $ source /etc/profile
    $ java -version
    ```

### Maven 설치

1.  다운로드
    ```bash
    $ wget https://archive.apache.org/dist/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
    ```
2.  압축해제
    ```bash
    $ gunzip apache-maven-3.5.2-bin.tar.gz
    $ tar -xvf apache-maven-3.5.2-bin.tar
    ```
3.  Maven 링크 생성
    ```bash
    $ sudo mv apache-maven-3.5.2 /usr/local
    $ cd /usr/local
    $ sudo ln -s apache-maven-3.5.2/ maven
    ```
4.  환경변수 등록

    ```bash
    $ sudo vi /etc/profile

    MAVEN_HOME=/usr/local/maven
    PATH=$PATH:$MAVEN_HOME/bin
    export MAVEN_HOME
    ```

5.  적용 및 확인
    ```bash
    $ source /etc/profile
    $ mvn -version
    ```

### Jenkins 설치

1.  설치
    ```bash
    $ sudo yum -y install wget
    $ sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
    $ sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
    $ sudo yum install jenkins
    ```
2.  설치 확인
    ```bash
    $ rpm -qa | grep jenkins
    ~ jenkins-2.220-1.1.noarch
    ```
3.  설정
    ```bash
    $ sudo vi /etc/sysconfig/jenkins
    JENKINS_PORT="9100" # port변경
    ```
4.  실행
    ```bash
    $ sudo systemctl start jenkins.service
    # 에러 발생
    $ sudo systemctl status jenkins.service
    # 에러 확인, 자바 경로가 잘못됐다고 나옴
    ```
5.  java 경로 설정

    ```bash
    $ sudo vi /etc/init.d/jenkins

    # jdk 로 검색하면 80 라인 근처에
    /etc/alternatives/java
    /usr/lib/jvm/java-1.8.0/bin/java
    /usr/lib/jvm/jre-1.8.0/bin/java
    /usr/lib/jvm/java-1.7.0/bin/java
    /usr/lib/jvm/jre-1.7.0/bin/java
    /usr/lib/jvm/java-11.0/bin/java
    /usr/lib/jvm/jre-11.0/bin/java
    /usr/lib/jvm/java-11-openjdk-amd64
    /usr/bin/java

    /usr/local/java/bin/java # 한줄 추가
    ```

6.  다시 실행
    ```bash
    $ sudo systemctl start jenkins.service
    ```
7.  접속 및 구성
    - http://[GCP Server IP]:9100 unlock 후 "Install suggested plugins" 설치 및 관리자 계정 생성

### Jenkins 사용자 변경

젠킨스 설치시 기본사용자는 jenkins 입니다. 이걸 내 계정으로 변경하여 ssh접속이 되도록 합니다.

1.  유저명 변경

    ```bash
    $ sudo vi /etc/sysconfig/jenkins

    JENKINS_USER="jenkins" # 내계정으로 변경
    ```

2.  폴더 소유 변경
    ```bash
    $ sudo chown -R whitexozu:whitexozu /var/lib/jenkins
    $ sudo chown -R whitexozu:whitexozu /var/log/jenkins
    $ sudo chown -R whitexozu:whitexozu /var/cache/jenkins
    ```
3.  다시 실행
    ```bash
    $ sudo systemctl restart jenkins.service
    ```

### git 설치

```bash
$ sudo yum -y install git
$ git --version
```

### gcp ssh 접속 설정

1. ssh key 생성
   ```bash
   $ ssh-keygen -t rsa -f rsa-gcp-key -C "whitexozu@gmail.com"
   ```
2. GCP 사이트 > Compute Engin > 메타데이터 메뉴로 이동
3. SSH키 텝 클릭 > 수정 버튼 클릭 > pub 키 등록
4. 기존에 키를 등록한 적이 있다면 ~/.ssh/known_hosts 파일내의 GCP IP정보를 검색해서 삭제합니다.
5. ssh -i ~/.ssh/rsa-gcp-key [계정]@[GCP IP] 로 접속

```toc

```
