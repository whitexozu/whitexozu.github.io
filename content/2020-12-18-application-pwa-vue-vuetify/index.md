---
title: '[작성중][PWA] Vue + Vuetify 활용한 PWA 개발'
date: 2020-12-17 08:05:34
author: TMM
categories: Application
tags: PWA Javascript Vue Vuetify
---

Vue를 이용해 PWA를 만들어 보겠습니다.<br />
nvm은 설치가 돼 있고 vuetify를 사용할 수 있다는 전제로 진행하겠습니다.<br />
nvm 버전은 v13.14.0을 사용하였습니다.

---

## npm package 설치 및 실행

### serve 설치

```bash
$ npm install -g serve@11.3.2
```

### Vue cli 설치

```bash
$ npm i @vue/cli@4.5.9
```

### Vue 프로젝트 생성

```bash
$ vue create first-pwa

┌───────────────────────────┐
│  Update available: 4.5.9  │
└───────────────────────────┘
? Please pick a preset: Manually select features
? Check the features needed for your project: Babel, PWA
? Where do you prefer placing config for Babel, PostCSS, ESLint, etc.? In dedicated config files
e.json
? Save this as a preset for future projects: N
```

### Vue 프로젝트 실행

```bash
$ cd first-pwa
$ npm run serve
```

### Vuetify 설치

```bash
$ vue add vuetify

📦  Installing vue-cli-plugin-vuetify...

yarn add v1.16.0
[1/4] 🔍  Resolving packages...
[2/4] 🚚  Fetching packages...
[3/4] 🔗  Linking dependencies...
[4/4] 🔨  Building fresh packages...
success Saved lockfile.
success Saved 5 new dependencies.
info Direct dependencies
└─ vue-cli-plugin-vuetify@2.0.8
info All dependencies
├─ interpret@1.4.0
├─ null-loader@3.0.0
├─ rechoir@0.6.2
├─ shelljs@0.8.4
└─ vue-cli-plugin-vuetify@2.0.8
✨  Done in 4.34s.
✔  Successfully installed plugin: vue-cli-plugin-vuetify

? Choose a preset: (Use arrow keys)
❯ Default (recommended)
  Prototype (rapid development)
  Configure (advanced)
```

### Vue 프로젝트 재실행

```bash
$ npm run serve
```

### 매니페스트 작성

- public/manifest.json

```json
{
  "name": "반가워요! PWA by VueJS",
  "short_name": "반가워요! PWA by VueJS",
  "icons": [
    {
      "src": "./img/icons/android-chrome-192x192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "./img/icons/android-chrome-512x512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ],
  "start_url": "./index.html",
  "display": "standalone",
  "orientation": "portrait",
  "background_color": "#FFFFFF",
  "theme_color": "#FFFFFF"
}
```

### 앱 실행 화면 만들기

- public/index.html

```html
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <!-- 상태 표시줄 테마 색상을 흰색으로 변경 -->
    <meta name="theme-color" content="#ffffff" />
    <link rel="icon" href="<%= BASE_URL %>favicon.ico" />
    <title>반가워요! PWA by VueJS</title>
    <!--머티리얼 디자인 아이콘 추가-->
    <link
      href="https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900|Material+Icons"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/@mdi/font@latest/css/materialdesignicons.min.css"
    />
  </head>
  <body>
    <noscript>
      <strong
        >We're sorry but ex08 doesn't work properly without JavaScript enabled. Please enable it to
        continue.</strong
      >
    </noscript>
    <div id="app"></div>
    <!-- built files will be auto injected -->
  </body>
</html>
```

- src/App.vue

```js
<template>
    <v-app>
        <v-content>
            <!-- fill-height는 브라우저 높이를 100%, 수직으로 가운데 정렬시킴 -->
            <v-container fluid fill-height>
                <v-row>
                    <!-- text-center는 수평 가운데 정렬 -->
                    <v-col cols="12" class="text-center">
                        <!-- 타이포 스타일은 title, 글자색은 흰색으로 설정  -->
                        <h1 class="title white--text">반가워요!</h1>
                        <p class="caption">by VueJS</p>
                        <img src="./assets/logo.png" alt="" />
                    </v-col>
                </v-row>
            </v-container>
        </v-content>
    </v-app>
</template>
<script>
export default {
    name: 'App',
    created() {
        // 배경색을 다크모드로 함
        this.$vuetify.theme.dark = true
    },
}
</script>
```

### Vue 프로젝트 빌드 및 PWA 앱 실행

- 빌드 결과물 실행에서만 PWA동작 확인이 가능합니다.

```bash
$ npm run build
$ serve dist
```

### PWA 앱 동작 결과 확인

- 개발자 도구 -> Application -> Manifest -> 내용 확인
- 개발자 도구 -> Application -> Service Worker -> status 상태 확인

---

## 워크박스

### 워크박스란

구글에서 제공하는 워크박스(workbox)는 **웹앱의 오프라인 기능을 지원하는 자바스크립트 라이브러리**입니다. 워크박스는 PWA의 장점인 오프라인 퍼스트의 경험을 쉽게 구현하도록 오픈소스 모듈로 지원합니다. Vue-CLI 3부터는 PWA 지원이 강화되어 워크박스라는 체계적인 오프라인 기능을 지원하고 있습니다.

### 플러그인 모드

<!-- 286 -->

| 플러그인 모드            | 사용할 상황                                                                                                                                   | 한계                                                               |
| :----------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------- |
| GenerateSW<br />(기본값) | - 프리캐시할 파일을 빠르게 지정해야 할 때<br />- 간단한 런타임 캐시가 필요할 때                                                               | - 서비스 워커에 코드를 넣어야 할때<br />- 웹 푸시 알림을 사용할 때 |
| InjectManifest           | - 서비스 워커에 자신의 코드를 넣어야 할 때<br />- 코드로 직접 프리캐시, 런타임 캐시를 지정하고 싶을 때<br />- 웹 푸시 알림을 사용하고 싶을 때 | - 복잡해질 수 있으므로 간단할 때는 GenerateSW가 적합할 수 있음     |

_워크박스의 두 플러그인 모드를 사용하려면 vue.config.js 파일이 필요합니다._

### 프리캐시

프리캐시란 프로그램이 실행되기 전에 원하는 파일만 캐시 메모리에 미리 저장하는 것을 말합니다. 워크박스에서 제공하는 다양한 프리캐시 옵션을 사용할 수 있습니다. 하지만 Vue-CLI에서는 기본적으로 아무 옵션을 지정하지 않아도 빌드한 후에 웹팩으로 생성된 dist 폴더에 있는 index.html, _.css, _.js, robots.txt 파일을 프리캐시합니다. 그리고 index.html 파일에서 외부 HTTP 요청을 한 URL이 있다면 자동으로 프리캐시하므로 웬만한 것은 거의 다 처리할 수 있습니다.

| 옵션    | 의미                                                                                                                            | 적용 사례                        |
| :------ | :------------------------------------------------------------------------------------------------------------------------------ | :------------------------------- |
| include | 프리캐시에서 사용할 파일을 지정합니다. 이것은 파일이름을 토대로 하므로 대량으로 찾는 정규식을 함께 활용하면 유용합니다.         | include: [/\\.css$/, /\\.js$/]   |
| exclude | 프리캐시에서 제거할 파일을 지정합니다. 유의할 점은 제거할 파일이 없어도 exclude: []처럼 반드시 명시해 주어야 제대로 동작합니다. | exclude: [/\\.json$/, /\\.png$/] |

### 프리캐시 예제

- vue.config.js

```js
module.exports = {
  pwa: {
    workboxOptions: {
      // 프리캐시(pre-cache)할 파일 지정
      include: [/^index\.html$/, /\.css$/, /\.js$/, /^manifest\.json$/, /\.png$/],
      // exclude는 반드시 기입해야 정상적으로 동작함.
      exclude: [],
    },
  },
};
```

### 런타임 캐시

- 프리캐시(pre-cache)는 서비스 워커가 등록될 때 미리 원하는 파일만 지정하여 캐시하는 것을 말합니다. 이 방법은 분명히 빠르고 손쉽지만 브라우저의 HTTPS 요청처럼 프로그램 로직에 따라 앱 실행 중에 캐시해야 하는 경우드 발생합니다. 이럴 때 수행하는 방법을 **런타임 캐시(runtime-cache)**라고 합니다.
- 런타임 캐시를 사용할는 *캐시 전략*에는 5가지가 있습니다.

|       캐시 전략        |                                         방법                                         |                                      용도                                      |               캐시 대상                |
| :--------------------: | :----------------------------------------------------------------------------------: | :----------------------------------------------------------------------------: | :------------------------------------: |
|     Network-First      |                       인터넷에서 먼저 일고 실패하면 캐시 사용                        | 인터넷 기사처럼 오프라인 작업도 처리할 수 있어야 하고 데이터 업데이트가 많을때 |             HTTP 요청 URL              |
|      Cache-First       |                      캐시를 먼저 읽고 실패하면 인터넷에서 찾기                       |       오프라인 작업도 처리할 수 있어야 하고 캐시 업데이트가 필요 없을 때       |           폰트, 이미지 파일            |
| Stale-while-revalidate | 캐시를 먼저 읽고 실패하면 인터넷에서 찾으면서 동시에 캐시의 내용을 최신으로 업데이트 |                캐시를 주로 사용하면서 캐시 업데이트가 필요할 때                |         아바타 이미지, CSS, js         |
|      Network-Only      |                               인터넷에서만 데이터 읽기                               |              인터넷에만 사용해도 되고 데이터 업데이트가 빈번할때               |               캐시 없음                |
|       Cache-Only       |                                캐시에서만 데이터 읽기                                |               오프라인 작업이 빈번하고 데이터 업데이트가 없을 때               | 정적인 파일만으로도 실행되면 모든 파일 |

- 286

### 런타임 캐시 예제

#### GenerateSW 플러그인 모드에서 런타임 캐시

```js
module.exports = {
  pwa: {
    workboxOptions: {
      runtimeCaching: [
        {
          urlPattern: /\.png$/,
          handler: 'cacheFirst',
          options: {
            cacheName: 'png-cache',
            expiration: {
              maxEntries: 10, // 총 파일 10개까지 캐시
              maxAgeSeconds: 60 * 60 * 24 * 365, // 1년 캐시
            },
          },
        },
        {
          urlPattern: /\.json$/,
          handler: 'staleWhileRevalidate',
          options: {
            cacheName: 'json-cache',
            cacheableResponse: {
              statuses: [200],
            },
          },
        },
      ],
    },
  },
};
```

#### 런타임 캐시 옵션

- handler: 앞에서 설정한5가지 캐시 전략 중 한 가지 사용
- urlPattern: 정규식을 사용해서 캐시하려는 파일이나 url 경로 지정
- options
  - cacheName: 개발자 도구에 표시할 캐시 제목
  - expiration: 캐시 제약 지정
    - maxEntries: 캐시할 개수
    - maxAgeSeconds: 캐시가 유지될 총 시간(초)
  - cacheableResponse: HTTP 응답 코드를 통해 캐시 여부 결정

---

## PWA 성능 테스트

1. 크롬 확장 프로그램에 **lighthouse** 추가
1. 검사 사이트 이동
1. lighthouse 아이콘 클릭 후 `Generate report` 버튼을 누르고 기다립니다.
1. report 결과 확인

---

## 푸시 서비스

### 웹 푸시 알림 이란

<!-- 422 -->

### 프로젝트 생성

- frontend 프로젝트는 브라우저별 push endpoint 생성을 합니다.
- backend 프로젝트는 push 발송을 합니다.

```bash
$ vue create pwa-frontend
$ vue create pwa-backend
```

### 모듈 설치

```bash
$ npm run web-push
```

### package.json 수정

```bash
$ vi package.json
```

```js
...
  "scripts": {
    "serve": "vue-cli-service serve",
    "build": "vue-cli-service build",
    "web-push": "web-push"
  },
...
```

### 비대칭킹 생성

```bash
$ npm run web-push gnenrate-vapid-keys
```

- 생성된 키는 frontend endpoint 생성, backend push 요청에 사용됩니다.
- 키는 web-push-key.txt 파일을 만들어 임시로 저장해 둡니다.

### 메니페스트 작성 예제

<!-- 431 -->

### frontend 예제

### backend 예제

```toc

```
