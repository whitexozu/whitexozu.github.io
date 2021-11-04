---
title: '[NVM] Window10에 NVM 설치'
date: 2020-07-16 08:05:34
author: TMM
categories: VM
tags: nvm
---

프로젝트에 따라 nodejs 버전이 다른 경우가 왕왕 있습니다. 그래서 NVM은 필수인거 같습니다.

## 목표

- Window10에 NVM 설치
- nodejs, npm 설치 및 버전 변경

## NVM 설치

1.  https://github.com/coreybutler/nvm-windows/releases 에서 nvm-setup.zip 파일을 다운로드 받습니다.
2.  압출을 풀고 설치를 시작합니다.
3.  버전 확인

```bash
$ nvm version
v12.1.0
```

## nodejs, npm 설치 및 버전 변경

### nodejs 버전 확인

- [https://nodejs.org/ko/download/releases/](https://nodejs.org/ko/download/releases/)

### nodejs, npm 설치

```bash
$ nvm help
$ nvm install v12.18.0
```

### nodejs, npm 설치 확인 및 사용

```bash
$ nvm install v12.18.0
$ nvm use v12.18.0
$ nvm list
        v8.16.0
       v10.15.3
        v12.1.0
->     v12.18.0
       v13.14.0
default -> node (-> v13.14.0)
node -> stable (-> v13.14.0) (default)
stable -> 13.14 (-> v13.14.0) (default)
iojs -> N/A (default)
lts/* -> lts/erbium (-> N/A)
lts/argon -> v4.9.1 (-> N/A)
lts/boron -> v6.17.1 (-> N/A)
lts/carbon -> v8.17.0 (-> N/A)
lts/dubnium -> v10.21.0 (-> N/A)
lts/erbium -> v12.18.2 (-> N/A)

$ node -v
v12.18.0
$ npm -v
6.14.4
```

## 참고사이트

- [https://seunghyun90.tistory.com/52](https://seunghyun90.tistory.com/52)

```toc

```
