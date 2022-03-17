---
title: '[Ubuntu 16] Initial install package + nginx + gunicorn + flask + pm2 + nodejs + certbot'
date: 2021-01-08 08:05:34
author: TMM
categories: SERVER
tags: ubuntu 16 nginx gunicorn flask pm2 nodejs certbot
---

ubuntu 16을 개인 노트북에 설치 후 ssh와 mysql 설치 그리고 gunicorn + flask와 pm2 + nodejs 조합으로 웹서비스를 구성 해보겠습니다. 추가로 nginx + certbot 조합으로 https서비스도 구성하겠습니다.

### apt

1. source list 변경

   ```bash
   $ sudo vi /etc/apt/source.list
   ```

   ```bash
   deb http://kr.archive.ubuntu.com/ubuntu xenial main restricted universe multiverse
   deb http://kr.archive.ubuntu.com/ubuntu xenial-updates main restricted universe multiverse
   deb http://kr.archive.ubuntu.com/ubuntu xenial-backports main restricted universe multiverse
   deb http://kr.archive.ubuntu.com/ubuntu xenial-proposed main restricted universe multiverse
   deb http://kr.archive.ubuntu.com/ubuntu xenial-security main restricted universe multiverse

   deb-src http://kr.archive.ubuntu.com/ubuntu xenial main restricted universe multiverse
   deb-src http://kr.archive.ubuntu.com/ubuntu xenial-updates main restricted universe multiverse
   deb-src http://kr.archive.ubuntu.com/ubuntu xenial-backports main restricted universe multiverse
   ```

### openssh-server

1. 설치

   ```bash
   $ sudo apt-get update
   $ sudo apt-get upgrade
   $ sudo apt-get install openssh-server
   ```

### 노트북 전원 유지

1. 설정

   ```bash
   $ sudo vi /etc/systemd/logind.conf
   ```

   ```vim
   ...
   #HandleLidSwitch=suspend
   # 위 내용을 아래 내용으로 변경
   HandleLidSwitch=ignore
   ...
   ```

1. 서비스 재실행
   ```bash
   $ systemctl restart systemd-logind
   ```

### git 설치

1. 설치
   ```bash
   $ sudo apt-get install git
   ```

### python3.6

1. 설치

   ```bash
   $ sudo add-apt-repository ppa:deadsnakes/ppa
   $ sudo apt-get update
   $ sudo apt-get install python3.6
   $ sudo apt-get install python3.6-gdbm
   ```

1. 파이선 버젼 변경 등록

   ```bash
   $ sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1
   $ sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 2
   ```

1. 파이선 버젼 변경

   ```bash
   $ sudo update-alternatives --config python3
   ```

1. 확인
   ```bash
   $ cd /usr/bin
   $ ll | grep python3
   ```

### pip3

1. 설치

   ```bash
   $ sudo apt-get install python3-pip
   $ python3 -m pip install --upgrade pip
   ```

1. 확인

   ```bash
   $ cd /usr/bin
   $ ll | gerp pip3
   ```

### python3.7

- 2022년 3월 기준 Ubuntu16에 apt를 이용한 Python3.7 설치가 안되는 이슈가 있어 수동으로 다운 받은 후 설치 해야 합니다.

1. 설치

   ```bash
   $ sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev
   $ cd /opt
   $ sudo wget https://www.python.org/ftp/python/3.7.12/Python-3.7.12.tgz
   $ sudo tar xzf Python-3.7.12.tgz
   $ cd Python-3.7.12/
   $ sudo ./configure --enable-optimizations
   $ sudo make altinstall
   $ sudo update-alternatives --install /usr/bin/python python /usr/local/bin/python3.7 1 #python3.7 1순위 지정

   $ sudo apt-get install python3-pip
   $ python -m pip install --upgrade pip
   ```

### mysql 8

1. 설치

   ```bash
   $ mkdir ~/download
   $ cd ~/download
   $ wget https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb
   $ sudo dpkg -i mysql-apt-config_0.8.12-1_all.deb
       > MySQL Server & Cluster 선택
       > MySQL 8 선택
       > OK 선택
   $ sudo apt update
   $ sudo apt install mysql-server
       > root 비밀번호 입력
       > root 비밀번호 재입력
       > Use Strong Pasword Encryption 암호방식 선택
   $ mysql --version
   $ sudo service mysql start
   $ mysql -u root -p
   ```

1. db 생성

   ```bash
   mysql> create database nlp;
   mysql> create user 'admin'@'%' identified by 'password';
   mysql> grant all on nlp.* to 'admin'@'%';
   mysql> flush privileges;
   ```

1. 삭제

   ```bash
   $ sudo service mysql stop

   $ sudo apt-get remove --purge mysql-server -y
   $ sudo apt-get remove --purge mysql-server* -y
   $ sudo apt-get remove --purge mysql-common -y
   $ sudo apt-get autoremove

   $ sudo rm -rf /var/log/mysql
   $ sudo rm -rf /var/log/mysql.*
   $ sudo rm -rf /var/lib/mysql
   $ sudo rm -rf /etc/mysql
   ```

### flask

1. 설치

   ```bash
   $ pip3 install Flask==1.1.2
   ```

1. flask app 생성

   ```bash
   $ mkdir ~/dev
   $ mkdir ~/dev/project
   $ mkdir ~/dev/project/thesaurus
   $ vi ~/dev/project/thesaurus/app.py
   ```

   ```python
   from flask import *
   app = Flask(__name__)

   @app.route("/")
   def hello():
       return "<h1 style='color:blue'>Hello Thesaurus</h1>"

   if __name__ == "__main__":
       app.run(host='0.0.0.0', port=5000, debug=True)
   ```

1. 실행

   ```bash
   $ python3 ~/dev/project/thesaurus/app.py
   ```

1. 테스트
   - 해당 서버 **IP:5000**로 브라우저 접속 테스트
   - _ctrl + c_ 로 종료

### gunicorn

1. 설치
   ```bash
   $ pip3 install gunicorn
   ```
1. flask 연결 설정

   ```bash
   $ vi ~/dev/project/thesaurus/wsgi.py
   ```

   ```python
   from app import app

   if __name__ == "__main__":
       app.run()
   ```

1. 테스트

   ```bash
   $ cd ~/dev/project/thesaurus/
   $ gunicorn --bind 0.0.0.0:5000 wsgi:app
   ```

   - 해당 서버 **IP:5000**로 브라우저 접속 테스트
   - _ctrl + c_ 로 종료

1. 데몬 서비스 등록

   ```bash
   sudo vi /etc/systemd/system/thesaurus.service
   ```

   ```vim
   [Unit]
   Description=Gunicorn instance to serve thesaurus
   After=network.target

   [Service]
   User=sin
   Group=www-data
   WorkingDirectory=/home/sin/dev/project/thesaurus
   ExecStart=/home/sin/.local/bin/gunicorn --workers 1 --timeout 300 --bind unix:thesaurus.sock --error-logfile /var/log/gunicorn/error.log --access-logfile /var/log/gunicorn/access.log --capture-output --log-level debug -m 007 wsgi:app
   Environment=PYTHONUNBUFFERED=1

   [Install]
   WantedBy=multi-user.target
   ```

   _ExecStart의 gunicorn 경로는 which 명령으로 확인_

1. 로그 폴더 생성

   ```bash
   $ sudo mkdir /var/log/gunicorn
   $ sudo chmod 777 /var/log/gunicorn
   ```

1. 서비스 실행

   ```bash
   $ sudo systemctl start thesaurus
   $ sudo systemctl enable thesaurus
   $ sudo systemctl status thesaurus
   ```

1. 확인
   ```bash
   $ ll /home/sin/dev/project/thesaurus/thesaurus.sock
   ```

### nginx

1. 설치

   ```bash
   $ sudo apt-get install nginx
   $ nginx -v
   ```

1. 설치 확인

   - 해당 서버 **IP**로 브라우저 접속 테스트

1. sites-available에 wsgi 등록

   ```bash
   sudo rm /etc/nginx/sites-available/default
   sudo vi /etc/nginx/sites-available/default
   ```

   ```vim
   server {
       listen 80;
       server_name localhost;

       location / {
           include proxy_params;
           proxy_pass http://unix:/home/sin/dev/project/thesaurus/thesaurus.sock;
       }
   }
   ```

1. sites-enabled에 링크 생성

   ```bash
   sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled
   ```

1. nginx 테스트

   ```bash
   sudo nginx -t
   ```

1. nginx reload

   ```bash
   sudo nginx -s reload
   ```

1. 테스트
   - 해당 서버 **IP**로 브라우저 접속 테스트

### curl 설치

1. 설치
   ```bash
   $ sudo apt install curl
   ```

### nvm 설치

1. 설치

   ```bash
   $ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

   $ source ~/.bashrc
   ```

1. 명령어 참고
   - nvm ls-remote : nvm이 지원하는 버전 확인
   - nvm install [버전] : nvm에서 지원 버전 install
     - ex) $ nvm install v13
   - nvm ls => 설치된 node 버전 확인
   - nvm use v12.18.2 => v12.18.2 버전의 node를 사용
   - nvm alias default [버전] => default 버전을 변경 및 유지

_32bit 에서는 nvm install 이 안돼요_

### koa

1. 설치

   생략

1. koa app 생성

   생략

1. 실행

   ```bash
   $ node src
   ```

1. 테스트
   - 해당 서버 **IP:4000**로 브라우저 접속 테스트
   - _ctrl + c_ 로 종료

### pm2

1. 설치

   ```bash
   $ npm install pm2 -g
   $ pm2 -v
   ```

1. 실행

   ```bash
   $ pm2 start src
   ```

   or

   ```bash
   $ vi ecosystem.config.js

   module.exports = {
   apps: [
           {
               name: 'app',
               script: './src',
               instances: 1,
               exec_mode: 'cluster',
           },
       ],
   };

   $ pm2 start ecosystem.config.js
   ```

1. 종료

   ```bash
   $ pm2 kill
   ```

1. 명령어 참고
   - 목록 : pm2 list
   - 중지 : pm2 stop 0, pm2 stop all
   - 삭제 : pm2 delete 0
   - 모니터 : pm2 monit
   - 아이디 저장 : pm2 start server.js --name "API"
   - 상세 보기 : pm2 show API
   - 로그 : pm2 log
     - 파일 위치 : ~/.pm2/logs
   - stdout : pm2 delete API && pm2 start server.js --name "API" -o ./api.log
   - stderr : pm2 delete API && pm2 start server.js --name "API" -o ./api.log -e ./api.log --merge-logs
   - 스케일 조정 : pm2 scale API 5

### 무료 도메인 생성

1. 회원 가입
   1. [프리놈](https://www.freenom.com/en/index.html?lang=en) 이동
   1. Sign in > Google login
   1. Services > Register New Domain
   1. 도메인 키워드 입력 후 검색 > 선택
   1. Services > My Domains > Manage Domain > Manage Freenom DNS > IP 등록 > 서비스 기간 선택
      - 등록이 완료되면 5분정도 후에 사용 가능 합니다. 만약 오래 기다려도 사용이 안되면 재등록을 추천 합니다.

### nginx 수정

1. pm2 추가

   ```bash
   $ sodu vi /etc/nginx/sites-available/default
   ```

   ```vim
   server {
       listen 80;
       server_name  [도메인];

       location /thesaurus/ {
           add_header Access-Control-Allow-Origin *;

           proxy_set_header X-Real-IP $remote_addr;

           rewrite ^/thesaurus(/.*)$ $1 break;
           proxy_pass http://thesaurus;
           proxy_redirect off;
       }

       location /pwapush/ {
           add_header Access-Control-Allow-Origin *;

           proxy_set_header X-Real-IP $remote_addr;

           rewrite ^/pwapush(/.*)$ $1 break;
           proxy_pass http://pwapush;
           proxy_redirect off;
       }
   }

   upstream thesaurus {
       server unix:/home/sin/dev/project/Flask-Scaffold/thesaurus/thesaurus.sock;
   }

   upstream pwapush {
       server localhost:4000;
   }
   ```

### certbot

1. 설치

   ```bash
   $ sudo snap install core; sudo snap refresh core
   $ sudo snap install --classic certbot
   $ sudo ln -s /snap/bin/certbot /usr/bin/certbot
   ```

1. 실행

   ```bash
   $ sudo certbot --nginx
   ```

1. 확인
   ```bash
   $ sudo certbot certificates
   ```
1. 갱신 테스트

   ```
   $ sudo certbot renew --dry-run
   ```

1. 자동 갱신 등록

   1. root 비밀번호 설정

      ```bash
      $ sudo passwd
      ```

   1. root 권한으로 crontab 등록

      ```
      $ su
      $ crontab -e

      15 3 * * 0 certbot renew
      ```

1. 결과 확인 및 자동 https 변경 설정

   ```vim
   server {
       listen 443 ssl; # managed by Certbot
       server_name  [domain name];

       location /thesaurus/ {
           add_header Access-Control-Allow-Origin *;

           proxy_set_header X-Real-IP $remote_addr;

           rewrite ^/thesaurus(/.*)$ $1 break;
           proxy_pass http://thesaurus;
           proxy_redirect off;
       }

       location /pwapush/ {
           add_header Access-Control-Allow-Origin *;

           proxy_set_header X-Real-IP $remote_addr;

           rewrite ^/pwapush(/.*)$ $1 break;
           proxy_pass http://pwapush;
           proxy_redirect off;
       }

       ssl_certificate /etc/letsencrypt/live/[도메인]/fullchain.pem; # managed by Certbot
       ssl_certificate_key /etc/letsencrypt/live/[도메인]/privkey.pem; # managed by Certbot
       include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
       ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

   }

   upstream thesaurus {
       server unix:/home/sin/dev/project/Flask-Scaffold/thesaurus/thesaurus.sock;
   }

   upstream pwapush {
       server localhost:4000;
   }

   server {
       #if ($host = [도메인]) {
       #    return 301 https://$host$request_uri;
       #}

       listen       80;
       server_name  [도메인];
       #return 404; # managed by Certbot

       location / {
           return 301 https://$server_name$request_uri;
       }

   }
   ```

```toc

```
