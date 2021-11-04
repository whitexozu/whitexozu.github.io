---
title: '[ngrok] Vue 핫리로딩을 외부 단말에서'
date: 2020-12-22 08:05:34
author: TMM
categories: Package
tags: ngrok Vue
---

Vue로 Frontend를 개발하면서 편리한점중 하나는 수정한 내용을 바로바로 확인 할 수 있는 핫리로딩 입니다.<br />
그리고 핫리로딩을 모바일 기기같은 외부 단말 에서 사용할수 있게 해주는 package가 있습니다.<br />
바로 ngrok 입니다.<br />
한번 사용해보겠습니다.

### ngrok 설치

```bash
$ npm install -g ngrok
```

_window는 [ngrok 사이트](https://ngrok.com/download)에서 ngrok.exe 파일을 받아서 실행해야 합니다_

### vue.config.js 수정

```js
module.exports = {
    ...생략...
    devServer: {
        disableHostCheck: true
    }
}
```

### 실행

```bash
$ npm run serve
```

### ngork 실행

```bash
$ ngrok http 8080 #실행 포트 입력

ngrok by @inconshreveable                                                (Ctrl+C to quit)

Session Status                online
Session Expires               7 hours, 44 minutes
Version                       2.3.35
Region                        United States (us)
Web Interface                 http://127.0.0.1:4040
Forwarding                    http://6d3ec3487f97.ngrok.io -> http://localhost:8080
Forwarding                    https://6d3ec3487f97.ngrok.io -> http://localhost:8080

Connections                   ttl     opn     rt1     rt5     p50     p90
                              7       0       0.00    0.00    8.50    17.79

HTTP Requests
-------------

GET /app.ade16c2b65ed50af02aa.hot-update.js 200 OK
GET /app.ade16c2b65ed50af02aa.hot-update.js 200 OK
```

### 모바일에서 접속

- 생성된 경로 http://6d3ec3487f97.ngrok.io 또는 https://6d3ec3487f97.ngrok.io 로 접속하면 포워딩 됩니다.
- 소스 수정시 바로바로 확인이 가능한것을 볼수 있습니다.

```toc

```
