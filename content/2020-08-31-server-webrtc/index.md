---
title: '[WebRTC] gitsi 분석 및 설치'
date: 2020-08-23 08:05:34
author: TMM
categories: SERVER
tags: jitsi
---

비대면 서비스가 보편화 되고 있습니다.<br />
그래서 비대면 서비스를 개발 하려고 합니다.

## 확인사항

- janus 설치도 만만치 않다. 많은 라이브러리를쓰믄 만큼 설치시 오류가 많이 난다.
  - MinesNicaicai 님에 docker 를 수정하면서 설치할지
  - 인터넷에 있는 실치방법을 따라가면서 설치할지 고민이 된다
- gcp 트래픽 분석

## memo

- dolphin
- phinwave
- http://34.64.172.90/
- http://phinwave.duckdns.org/
- 34.64.172.90 phinwave.duckdns.org phinwave
- ping phinwave

## OS & Application

- Ubuntu 18.04.5 LTS
- Janus
- Jitsi Meet
  - jitsi-meet:
  - jicofo: Conferences Management
  - jitsi-videobridge2: MediaServer(SFU)
  - jigasi: SIP
  - jibri: 녹화 및 스트리밍 도구
- prosody: 상용 메시징 및 채팅 제공 업체에 대한 개방형 무료 XMPP 통신 서버
- Nginx: Web 서버
- docker
- gnupg2

## 사전지식

- WebRTC
- Signaling
- 브로드캐스트용 미디어서버
- FQDN: 전체 주소 도메인 네임은 호스트 이름과 도메인 이름을 포함한 전체 도메인 이름을 일컫는 용어이다. 절대 도메인 네임이라고도 한다. (개발 완료 후 설정)
- DSN
  - A Recode
  - CNAME Recode
- DDSN: DDNS, Dynamic DNS 또는 DynDNS는 실시간으로 DNS를 갱신하는 방식이다. 주로 도메인의 IP가 유동적인 경우 사용된다.
- SSL/TSL (Encrypt)
  - CRL (Certificate Revocation List)
  - OCSP (Online Certificate Status Protocol)
  - OCSP Stapling (Online Certificate Status Protocol Stapling)
  - 인증서 갱신
  - 인증서 폐기
- XMPP
- MQTT
- SIP
  - SIP는 RFC 3261로 권고되었으며, 하나 또는 그 이상의 참가자와 멀티미디어 세션의 생성, 변경, 종료에 대한 응용 계층의 프로토콜입니다.
- STUN, TURN, ICE, NAT, SDP
- MediaServer(MCU/SFU)
  - MCU: 들어오는 Traffic을 Server에서 Mixing 해서 내보내는 MCU(Multipoint Control Unit)
  - SFU: Mixing 하지 않고 Traffic을 선별적으로 배분해서 보내주는 SFU(Selective Forwarding Unit) 방식
- libnice
- gunpg2 사용 방법
- deb

## Janus Manul Install

## Janus Docker Install

- https://blog.remotemonster.com/janus-%EC%B4%88%EC%95%88-c11db5b59e26
- https://jomuljomul.tistory.com/entry/Janus-media-server-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0?category=871957
- https://github.com/cjsjyh/janus_server
- MinesNicaicai
  - janus docker: https://github.com/MinesNicaicai/janus-demo-docker
  - react-native git: https://github.com/MinesNicaicai/janus-webrtc-react-native

## Jitsi Manual Install

### GCP에 Ubuntu instance 생성

**Note:**<br />
ubunto에 생성되는 계정은 다음과 같습니다.<br />
`uuidd`<br />
`jvb`<br />
`jicofo`<br />
`prosody`<br />
`turnserver`<br />
{: .notice--info}

### java, maven 설치

sudo apt-get install openjdk-8-jre maven

### nvm 설치

sudo apt-get install build-essential libssl-dev
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source ~/.bashrc
nvm ls-remote
nvm install v12.18.3
nvm use v12.18.3

### DNS 등록

- https://www.duckdns.org/domains

### Nginx 설치

\$ sudo apt install nginx

**Note:**<br />
수동 설치시 Nginx 설치 후 설정정보를 직접 입력하기 보단 자동 설치에 사용된 설정 정보를 복사하는게 좋습니다. 메뉴얼의 설정 내용과 자동 설치시의 설정 내용이 많이 다릅니다.<br />
{: .notice--info}

### prosody 설치

\$ sudo apt-get install prosody

**Note:**<br />
수동 설치시 prosody 설치 후 설정정보를 직접 입력하기 보단 자동 설치에 사용된 설정 정보를 복사하는게 좋습니다. 메뉴얼의 설정 내용과 자동 설치시의 설정 내용이 많이 다릅니다.<br />
{: .notice--info}

### SSL/TLS 인증서 받기

- sudo apt-get install certbot python-certbot-nginx
- sudo certbot certonly --nginx (인증서만 받고 싶을때)
  1. 이메일 입력
  2. 서비스 동의
  3. 이메일 구독 서비스 동의
  4. 도메인 입력
- 인증서 생성 위치
  - sudo ls -l /etc/letsencrypt/live/\${YOUR_DOMAIN}
  - 예) sudo ls -l /etc/letsencrypt/live/phinwave.duckdns.org
- 인증서 갱싱
  - sudo crontab -e
  - 0 0 1 \* \* /usr/bin/certbot renew --renew-hook "systemctl reload nginx"
- 인증서 폐기
  - certbot revoke --cert-path /etc/letsencrypt/archive/\${YOUR_DOMAIN}/cert1.pem
  - certbot revoke --cert-path /etc/letsencrypt/archive/phinwave.duckdns.org/cert1.pem

### hostname 변경

- sudo vi /etc/hosts
  - 127.0.0.1 localhost
  - 127.0.0.1 meetphin.duckdns.org meetphin

### jitsi-meet 설치

### jitsi-vidodbridge2 설치

### meet 재실행 방법

    ```bash
    /etc/init.d/jicofo restart && /etc/init.d/jitsi-videobridge2 restart && /etc/init.d/prosody restart
    ```

## Quick Install

### GCP에 Ubuntu instance 생성

```bash
sudo apt update

dpkg --get-selections gnupg2
sudo apt install gnupg2
dpkg --get-selections apt-transport-https
sudo apt install apt-transport-https
sudo apt update
sudo hostnamectl set-hostname phinwave

sudo apt-get install openjdk-8-jre maven

sudo apt-get install vim
sudo vim /etc/hosts
127.0.0.1 localhost
34.64.172.90 phinwave.duckdns.org phinwave
or
sudo echo "127.0.0.1 localhost" >> /etc/hosts
sudo echo "34.64.172.90 phinwave.duckdns.org phinwave" >> /etc/hosts

curl https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | sudo tee /etc/apt/sources.list.d/jitsi-stable.list > /dev/null

sudo apt update
sudo apt install jitsi-meet

```

- [GUI 방식의 hostname 입력]
- [TSL 생성 여부 선택]
- [JAVA 설치 후 Lisence 동의]

```bash
sudo /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
[email 입력]
```

- [perperties 편집]

```bash
sudo vi /etc/jitsi/videobridge/sip-communicator.properties
org.ice4j.ice.harvest.NAT_HARVESTER_LOCAL_ADDRESS=${INNER_IP}
org.ice4j.ice.harvest.NAT_HARVESTER_PUBLIC_ADDRESS=34.64.172.90
```

- 재실행

```bash
sudo systemctl restart jitsi-videobridge2
```

## Uninstall

sudo apt-get purge nginx nginx-common
sudo certbot revoke --cert-path /etc/letsencrypt/archive/phinwave.duckdns.org/cert1.pem
or
sudo /

## 참고사이트

- WebRTC 설명:
  - https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API/Signaling_and_video_calling
  - https://dksshddl.tistory.com/entry/webRTC-%EC%9B%B9RTC-%EC%98%88%EC%A0%9C%EB%A1%9C-%ED%99%94%EC%83%81-%EC%B1%84%ED%8C%85-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0
  - https://juneyr.dev/webrtc-basics
  - https://www.aetherit.io/post/%EA%BC%AD-%EC%95%8C%EC%95%84%EC%95%BC%EB%A7%8C-%ED%95%98%EB%8A%94-webrtc-signaling-%EC%84%9C%EB%B2%84
- STUN, TURN, ICE, NAT, SDP: https://developer.mozilla.org/ko/docs/Web/API/WebRTC_API/Protocols
- Signaling: https://www.html5rocks.com/ko/tutorials/webrtc/infrastructure/
- Janus
  - site: https://janus.conf.meetecho.com/docs/rest.html
  - git: https://github.com/meetecho/janus-gateway
  - Docker
    - https://jomuljomul.tistory.com/entry/Janus-media-server-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0?category=871957
- jitsi 설치 공식 사이트: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-manual
- jitsi 국내 설치 블로그: http://blog.daum.net/sakwon/268?category=1926138
- hostnamectl: https://stackframe.tistory.com/15
- SSL/TLS (ngins, let's encrypt) 설치: https://engineering.linecorp.combest-practices-to-secure-your-ssl-tls/
- SSL/TLS 폐기 확인 Protocol 설명: https://rsec.kr/?p=386
- SSL/TLS 폐기: https://letsencrypt.org/ko/docs/revoking/
- SSL/TLS 인증서 갱신: https://devlog.jwgo.kr/2019/04/16/how-to-lets-encrypt-ssl-renew/
- DNS Type: https://win100.tistory.com/360
- GnuPG 사용방법: http://egloos.zum.com/mcchae/v/11264181
- deb 파일 생성: https://devanix.tistory.com/314
- sources.list 파일 설치: https://wnw1005.tistory.com/374
- MediaServer:
  - https://alnova2.tistory.com/1118
  - https://blog.xenomity.com/P2P-vs-SFU-vs-MCU/
- docker:
  - history & install: https://www.44bits.io/ko/post/easy-deploy-with-docker
  - command: https://rampart81.github.io/post/docker_commands/
  - netstat: https://aidanbae.github.io/code/docker/docker-netstat/
- docker & docker-compose: http://raccoonyy.github.io/docker-usages-for-dev-environment-setup/

## Apply theme

1. GitHub 에 Repository 생성 및 Clone
   1. github 에서 New Repository 클릭
   2. Repository name : [username].github.source
   3. git clone https://github.com/[username]/[username].github.source.git
2. GitHub 에서 테마 다운로드
   - Jekyll theme 중 가장 많이 다운받는 [minimal-mistakes](https://github.com/mmistakes/minimal-mistakes) 에서 압축파일을 다운받아 풀고 \*\*[username].github.
3. 중요 폴더 복사
   - `docs/_pages` 폴더를 최상위 폴더로 복사합니다. 그럼 게시글들을 year, categorise, tags 단위로 그룹지어서 볼수있습니다.
   - `docs/_posts` 에 글들을 참고하여 최상위 폴더인 `_posts` 에 파일을 생성합니다. 파일 생성시에는 규칙이 있으며 생성된 파일들이 블로그의 게시글들이 됩니다. 자세한 내용은 링크를 참고바랍니다. 설명할게 너무 많아요.

**Note:**<br />
`git filter-branch --subdirectory-filter _site/ -f` 명령어로 하나의 Repository 에서 관리를 할 수 있다고하는데 저는 잘 적용되지 않았습니다.<br />
혹시 이글을 보시는 분이 있다면 한번 도전해 보시기 바랍니다.<br />
참고했던 링크는 [여기](https://rainsound-k.github.io/jekyll-blog/2018/05/02/apply-custom-plugin.html)입니다.
{: .notice--info}

```toc

```
