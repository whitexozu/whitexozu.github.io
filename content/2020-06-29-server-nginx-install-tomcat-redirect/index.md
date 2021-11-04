---
title: '[Nginx] Nginx 설치 및 Tomcat 연동'
date: 2020-06-29 08:05:34
author: TMM
categories: WebServier
tags: Nginx
---

Nginx란 Apache같은 웹 서버입니다.<br />
Ubuntu 16에 Eninx 설치 후 Spring boot으로 실행 된 8080 포트를 연결 해보겠습니다.<br />
방화벽이 없는 상태에서 진행 했습니다.

## 목표

- Ubuntu 16에 Eginx 설치
- 8080 포트 eginx 연결
- 옵션 설정
- 권한 변경

## Nginx 설치

### 설치

```shell
sudo apt-get install nginx
```

### 제거

```shell
sudo apt-get remove nginx
```

### 버전확인

```shell
nginx -v
nginx version: nginx/1.10.3 (Ubuntu)
```

### 기본 화면 접속

[http://localhost](http://localhost)

### 서비스 시작

```shell
sudo service nginx status
sudo service nginx restart
```

## 설정

### Nginx 설치 위치

```shell
/etc/nginx
```

### 폴더 구조

```shell
├── conf.d # (디렉토리) nginx.conf에서 불러들일 수 있는 파일을 저장
├── fastcgi.conf # (파일) FastCGI 환경설정 파일
├── fastcgi_params
├── koi-utf
├── koi-win
├── mime.types
├── nginx.conf # 접속자 수, 동작 프로세스 수 등 퍼포먼스에 관한 설정들
├── proxy_params
├── scgi_params
├── sites-available # 비활성화된 사이트들의 설정 파일들이 위치한다.
│   └── default
├── sites-enabled # 활성화된 사이트들의 설정 파일들이 위치한다. 존재하지 않은 경우에는 디렉토리를 직접 만들 수도 있다.
│   └── default -> /etc/nginx/sites-available/default
├── snippets
│   ├── fastcgi-php.conf
│   └── snakeoil.conf
├── uwsgi_params
└── win-utf
```

### 설정 파일

```shell
$ sudo vi /etc/nginx/nginx.cnf
```

### upstream 설정

```bash
upstream <업스트림 이름> {
  <로드밸런스 타입: defulat는 round-robin>
  server <host1>:<port1>
  ...
  server <host2>:<port2>
}
server {
  ...
  location <url>{
    proxy_pass http://<업스트림 이름>
  }
  ...
}
```

### upstream 방식으로 8080 포트 연결

```shell
$ sudo vi /etc/nginx/sites-enabled/tomcat.conf
```

```bash
upstream tomcat {
   ip_hash;
   server 127.0.0.1:8080;
}

server {
   listen       80;
   server_name  localhost;

   access_log   /var/log/nginx/tomcat_access.log;

   location / {
       proxy_set_header        Host $http_host;
       proxy_set_header        X-Real-IP $remote_addr;
       proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header        X-Forwarded-Proto $scheme;
       proxy_set_header        X-NginX-Proxy true;

       proxy_pass http://tomcat;
       proxy_redirect          off;
       charset utf-8;
   }
}
```

### 기본 설정 제거

- default 심볼릭링크 삭제

```shell
$ cd /etc/nginx/sites-enabled
$ rm -f default
```

### nginx reload

```shell
nginx -s reload
```

## nginx load balancer

### 기존 upstream 파일에 서버 추가

```shell
$ sudo vi /etc/nginx/sites-enabled/tomcat.conf
```

```bash
upstream tomcat {
   ip_hash;
   server 127.0.0.1:8080;
   server 127.0.0.1:8081;
}

server {
   listen       80;
   server_name  localhost;

   access_log   /var/log/nginx/tomcat_access.log;

   location / {
       proxy_set_header        Host $http_host;
       proxy_set_header        X-Real-IP $remote_addr;
       proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header        X-Forwarded-Proto $scheme;
       proxy_set_header        X-NginX-Proxy true;

       proxy_pass http://tomcat;
       proxy_redirect          off;
       charset utf-8;
   }
}
```

### Load balancing methods(부하 부산 규칙)

- round-robin(디폴트) - 그냥 돌아가면서 분배한다.
- hash - 해시한 값으로 분배한다 쓰려면 hash <키> 형태로 쓴다. ex)hash \$remote_addr <- 이는 ip_hash와 같다.
- ip_hash - 아이피로 해싱해서 분배한다.
- random - 그냥 랜덤으로 분배한다.
- least_conn - 연결수가 가장 적은 서버를 선택해서 분배, 근데 가중치를 고려함
- least_time - 연결수가 가자 적으면서 평균 응답시간이 가장 적은 쪽을 선택해서분배

### method options

- weight - 가중치를 둬서 더많이 가게 한다.
- max_conns - 최대 연결 한계를 정한다
- max_fails - 최대 실패 한계를 정한다. 최대 실패횟수에 도달하면 서버가 죽은것으로 간주한다.
- fail_timeout - 시간을 정한다. 이 시간을 넘어서도 응답하지 않으면 서버가 죽은것으로 간주한다.
- backup - 이 서버는 백업서버로 간주하고 다른 메인 서버가 죽었을때 동작한다. load balancing methods가 hash나 random일때는 무의미
- down - 표시한 서버는 사용치 않는다.

## 참고사이트

- install & description:
  - https://whatisthenext.tistory.com/123
- load balancer:
  - https://kamang-it.tistory.com/entry/WebServernginxnginx%EB%A1%9C-%EB%A1%9C%EB%93%9C%EB%B0%B8%EB%9F%B0%EC%8B%B1-%ED%95%98%EA%B8%B0
  - https://velog.io/@minholee_93/Nginx-Load-Balancer

```toc

```
