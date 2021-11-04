---
title: '[PWA] PWA란? 순수 자바스크립트로 PWA 만들기'
date: 2020-12-16 08:05:34
author: TMM
categories: Application
tags: PWA Javascript
---

스타벅스는 소비자 주문 경험을 더 빠르게 개선하고자 PWA로 갈아탔습다. 특히 인터넷 접속이 원할하지 않은 신흥 시장의 만족도를 높이고 모든 플랫폼에서 실행되는 범용적인 시스템 구축을 위해 PWA가 그 역할을 훌륭히 수행하고 있습니다.<br />
가장 매력적인 부분은 iOS 기준으로 네이티브 앱에 비해 용량이 99%이상 가볍고 매우 빠른 반응 속도를 자랑합니다.

## PWA란

프로그레시브 웹앱은 2015년 구글 크롬 엔지니어인 알렉스 러셀(Alex Russell)이 고안한 개념입니다. 이후 발전을 거듭해 전 세계로부터 네이티브 앱의 강력한 기능성과 웹의 뛰어난 접근성을 모두 갖춘 가장 이상적인 형태의 웹앱이라는 평가를 받고 있습니다.

즉, 프로그레시브 웹앱은 네이티브 앱의 원활한 사용자 경험과 웹의 쉽고 편리한 접근성을 모두 가지고 있습니다.

- PWA를 가능하게 하는 웹앱 기술

  - 오프라인에서 실행되는 캐시
  - 보안성이 높은 HTTPS
  - SPA의 빠른 UI

- PWA 장점

  - 이미 익숙한 웹 기술을 그대로 이용할 수 있다.
  - 개발 시간을 단축할 수 있다
  - 푸시 알림, 오프라인 캐시, HTTPS를 사용할 수 있다.
  - 웹 브라우저만 있다면 어디든 배포할 수 있다.
  - '홈 화면 설치' 기능을 통해 운영체제의 응용프로그램으로 설치할 수 있다.
  - 실시간으로 유지 보수 할 수 있다.
  - 빠른 실행 속도로 네이티브 앱과 유사한 사용자 경험을 제공한다.

- PWA 단점

  - 하드웨어 사용은 웹 API를 통하므로 웹 표준을 지원한느 브라우저가 필요하다.
  - 앱 스토어, 플레이 스토어를 이용할 수 없지만 코르도바를 사용하면 같은 기반으로 배포할 수 있다.
  - 안드로이드, 윈도우 운영체제는 PWA의 모든 기능을 사용할 수 있으나 iOS는 현재 일부만 사용할 수 있다.

- PWA 제공하는 사용자 경험 9가지

  - 오프라인과 온라인에서도 걱정 없는 **신뢰성**
  - 네이티브 앱보다 간단히 설치할 수 있는 **편리성**
  - 훨씬 강력해진 **보안성**
  - 단골 손님을 늘리는 **구독자 고객 관리**
  - 모든 곳에서 실행된는 **멀티 플랫폼** 지원
  - 검색에서 잘 노출되고 잘 퍼지는 **확장성**
  - 항상 새것 같은 **최신성**
  - 네이티브 앱도 부럽지 않은 **사용성**
  - 네이티브 앱보다 빠른 **배포, 실행, 반응 속도**

## PWA를 대표하는 6가지 기술

### 24시간 실행되는 PWA의 심장 _서비스 워커_

PWA의 핵심은 단연 서비스 워커 입니다. 서비스 워카란, 웹 브라우저 안에 있지만 **웹 페이지와는 분리되어 항상 실행되는 백그라운드 프로그램**을 말합니다. 서비스 워커는 브라우저와 서버 사이에서 상태값의 변경을 감시하고 푸시 알림으로 사용자에게 특정 메시지와 댓글 알림을 보냅니다. 심지어 오프라인 상태에서도 작동합니다. 이로써 PWA는 기존의 웹앱, 웹사이트와는 달리 인터넷 연결 여부가 중요하지 않습니다.<br />

- 웹 페이지 <-> 서비스 워커 <-> 서버

### PWA의 여권, _웹앱 매니페스트_

웹앱 매니페스트란, 앱 소개 정보와 기본 설정을 담은 JSON파일을 말합니다. PWA는 반드시 manifest.json이라는 파일을 포함해야 합나다.

### 보안을 강화한 _HTTPS_

PWA를 배포할 때는 반드시 HTTPS 프로토콜을 사용해야 합니다. 왜냐하면 HTTPS 프로토콜은 라이트하우스라는 PWA 성능 평가 프로그램에서 인증을 받기 위한 의무 사항인 데다가 **홈 화면 추가** 기능은 HTTPS에서만 지원하기 때문입니다.

### 사용자에게 먼저 가가가는 _푸시 알림_

PWA의 등장으로 푸시 알림은 이제 네이티브 앱만의 소유가 아니게 되었습니다.<br />
PWA에서는 푸시 알림에 동의만 했다면 웹 사이트에 한 번 방문하고 떠난 사용자에게도 알림을 보낼 수 있습니다. 심지어 PWA가 실행되지 않은 백그라운드 상태에서도 알림 메시지를 보낼 수 있습니다.

### 터치 한 번으로 접속하게 하는 _홈 화면에 추가 기능_

PWA로 개발된 웹에 접속하면 웹 브라우저는 사용자에게 PWA를 설치하라고 홈화면에추가/옴니박스 와 같은 제안을 합니다.<br />
일종의 즐겨찾기나 바로가기 아이콘 기능으로 오해할 수 있으나 사실은 운영체제에 **설치**되는 기능 입니다. 따라서 운영체제는 진짜 앱처럼 인식합니다.

### 네이티브 앱도 부럽지 않은 _웹 API_

PWA는 API를 활용해 네이티브 앱처럼 위치 정보를 받거나 스마트폰의 카메라도 작동할 수 있습니다.

|   분류    |               항목                |
| :-------: | :-------------------------------: |
| 필수 요소 |  서비스 워커, 매니페스트, HTTPS   |
| 중요 기능 | 푸시 알림, 홈 화면에 추가, 웹 API |

## 순수 자바스크립트로 PWA 만들기

자바스크립트 프레임워크를 사용하면 PWA 개발이 한결 수월해집니다. 하지만 PWA는 이런 프레임워크의 힘을 빌리지 않고도 충분히 만들 수 있습니다.

- [전체 소스 (ex03)](http://www.easyspub.co.kr/71_Menu/SearchList/PUB 'DO IT! 프로그레시브 웹앱 만들기')

### 매니페스트 작성

```json
{
  "name": "안녕하세요! PWA by JS",
  "short_name": "PWA by JS",
  "description": "PWA start program",
  "scope": ".",
  "start_url": "./",
  "display": "fullscreen",
  "orientation": "portrait",
  "theme_color": "#ffffff",
  "background_color": "#ffffff",
  "icons": [
    {
      "src": "images/icons/android-chrome-512x512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

### 매니페스트 옵션

|       key        | description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| :--------------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|       name       | 바로가기 아이콘 설치를 권장하는 팝업 배너와 스플래시 스크린에 표시되는 제목입니다.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
|    short_name    | 바탕화면 바로가기 아이콘 아래 표시되는 제목입니다.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
|   description    | 애플리케이션의 간단한 자기소개입니다.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
|      scope       | 매니페스트에 정의된 내용이 적용될 수 이쓴 파일들의 범위를 지정합니다. '.'은 현재 위치를 의미하고 './'은 현재 위치를 중심으로 시작하는 하위 폴더를 의미합니다.                                                                                                                                                                                                                                                                                                                                                                                                     |
|    start_url     | 프로그램을 실행하면 시작될 URL을 루트경로(./)로 설정합니다.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|     display      | PWA를 실행하면 나타나는 화면의 형태를 설정하는 속성입니다.<br />- fullscreen: 기기의 최대 화면으로 보여 준다. 만약 기기의 운영체제가 fullscreen을 지원하지 않으면 standalone으로 자동 설정된다.<br />- standalone: 웹 브라우저의 주소, 상태 표시줄 등을 모두 제거한 화면을 보여준다. 즉, 웹 브라우저처럼 보이지 않도록 실행할 수 있다. 일반적으로 가장 많이 사용한다.<br />- minimal-ui: 상단의 주소 표시줄만 추가한다. 만약 기기의 운영체제가 minimal-ui를 지원하지 않으면 standalone으로 자동 설정된다.<br />- browser: 웹 브라우저와 똑같은 모습으로 실행된다. |
|   orientation    | 화면의 방향을 결정하는 옵션이다.<br />- portrait: 초상화 처럼 세로로 실행<br />- landscape: 풍경화처러럼 가로로 실행                                                                                                                                                                                                                                                                                                                                                                                                                                              |
|   theme_color    | 상태 표시줄의 색상을 설정합니다.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| background_color | 스플래시 스크린의 배경색을 설정합니다.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
|      icons       | 스플래시 스크린에 사용할 아이콘 이미지 중에서 128dpi에 가장 가까운 이미지를 찾아 화면에 표시합니다. <br />- src: 이미지의 절대 주소 또는 상재 주소<br />- sizes: 이미지의 픽셀 크기<br />- type: 이미지의 파일 유형                                                                                                                                                                                                                                                                                                                                               |

### 메인 화면 작성하기

```html
<!DOCTYPE html>
<!-- 언어를 한글로 설정함-->
<html lang="ko">

<head>
  <meta charset="utf-8">
  <!-- PWA 매너페스트 파일 연결, 상태바 테마색상을 흰색으로 변경 -->
  <link rel="manifest" href="manifest.json">
  <meta name="theme-color" content="#ffffff">

  <!-- 모바일 기기 뷰포트, 브라우저 주소줄 파비콘 설정-->
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="shortcut icon" href="images/icons/favicon.ico">
  <link rel="icon" type="image/png" sizes="16x16" href="images/icons/favicon-16x16.png">
  <link rel="icon" type="image/png" sizes="32x32" href="images/icons/favicon-32x32.png">

  <title>안녕하세요! PWA by JS</title>
  <style>
    html,
    body {
      /* html, body 모두 높이를 100%로 고정시켜야 flexbox 동작 */
      height: 100%;
      background-color: #F3A530;
      color: #ffffff;
    }

    .container {
      height: 100%;
      /* 높이를 100%로 고정시킴 */
      display: flex;
      /* 컨테이너를 flexbox 스타일로 변경 */
      align-items: center;
      /* 상하 가운데 정렬 */
      justify-content: center;
      /* 좌우 가운데 정렬*/
    }
  </style>
</head>

<body>
  <div class="container">
    <h1>안녕하세요!</h1>
    <img src="./images/hello-pwa.png" alt=""></img>
    <p>by JS</p>
  </div>
  <!-- 1. 서비스 워커 등록 -->
  <script>
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker
        .register('./service_worker.js')
        .then(function () {
          console.log('서비스 워커가 등록됨!');
        })
    }
  </script>
</body>

</html>
```

### 서비스 워커 만들고 실행하기

```js
const sCacheName = 'hello-pwa'; // 캐시제목 선언
const aFilesToCache = [
  // 캐시할 파일 선언
  './',
  './index.html',
  './manifest.json',
  './images/hello-pwa.png',
  './images/icons/android-chrome-512x512.png',
];

// 2.서비스워커를 설치하고 캐시를 저장함
self.addEventListener('install', (pEvent) => {
  console.log('서비스워커 설치함!');
  pEvent.waitUntil(
    caches.open(sCacheName).then((pCache) => {
      console.log('파일을 캐시에 저장함!');
      return pCache.addAll(aFilesToCache);
    }),
  );
});

// 3. 고유번호 할당받은 서비스 워커 동작 시작
self.addEventListener('activate', (pEvent) => {
  console.log('서비스워커 동작 시작됨!');
});

// 4.데이터 요청시 네트워크 또는 캐시에서 찾아 반환
self.addEventListener('fetch', (pEvent) => {
  pEvent.respondWith(
    caches
      .match(pEvent.request)
      .then((response) => {
        if (!response) {
          console.log('네트워크에서 데이터 요청!', pEvent.request);
          return fetch(pEvent.request);
        }
        console.log('캐시에서 데이터 요청!', pEvent.request);
        return response;
      })
      .catch((err) => console.log(err)),
  );
});
```

### 서비스 워커의 생애 주기

서비스 워커는 생애 주기에 따라 [install -> activate -> fetch] 순서로 이벤트를 발생시킵니다.<br />
그리고 이벤트의 세부 단계에 따라 서비스 워커 상태 정보가 [installing -> waiting -> active] 순서로 변경됩니다.

1. install 이벤트

   - install은 단어의 의미처럼 PWA를 설치하는 단계입니다.

   1. installing: 캐시 파일을 저장하려면 event.waitUntil() 사용, 서비스 워커 상태 **installing**
   1. installed: 설치 완료 후 대기 상태, 서비스 워커 상태 **waiting**

1. activate 이벤트

   - 서비스 워커가 고유한 ID를 발급받아 브라우저에 성공적으로 등록되면 동작합니다.
   - 앱을 업데이트하면 서비스 워커도 새로운 내용으로 교체해야 합니다. 이럴 때 호출되는 것이 바로 activate 이벤트입니다.
   - 서비스 워커의 내용을 업데이트하려면 먼저 캐시 제목과 프리 캐시 파일을 변경해 새로 운 서비스 워커 ID로 새로운 캐시 내용이 설치되도록 해야 합니다. 그리고 activating 상태에서 waitUntil() 함수를 사용해서 기존 캐시를 제거하는 코드를 넣습니다.

   1. activating: 캐시 파일을 업데이트하려면 event.waitUntil() 사용, 서비스 워커 상태 **active**
   1. activatied: 업데이트 완료 후 대기 상태, 서비스 워커 상태 **active**

1. fetch 이벤트

   - fetch 이벤트가 발생하는 대표적인 예는 브라우저에서 `새로 고침`을 누른 때입니다. 그러면 온라인 상태에서는 필요한 파일을 서버에서 가져오고, 오프라인 상태에서는 캐시에서 가져옵니다.

### 매니페스트 동작 확인

- 개발자 도구 -> Application -> Manifest -> 내용 확인

### 서비스 워커 동작 확인

- 개발자 도구 -> Application -> Service Worker -> status 상태 확인

### 서비스 워커 삭제하고 프로그램 종료

- 개발자 도구 -> Application -> Clear storage -> Clear site data 클릭

### 서비스 워커 새로고침시 업데이트

- 테스트시 매번 캐시 제목을 변경해 새로운 서비스 우커를 등록하는 번거로움을 해결하기 위해 테스트할때 쓴느 방법입니다.
- 개발자 도구 -> Application -> Service Worker -> Update on reload 체크

### 브라우저 서비스 워커 지원 확인

- https://mobilehtml5.org/tests/sw/

### 서비스 워커의 세가지 주요 이벤트

|  이벤트  | 설명                                                                        | 용도                                                                  |
| :------: | :-------------------------------------------------------------------------- | :-------------------------------------------------------------------- |
| install  | 서비스 워커가 처음 설치될 때 실행한다. (앱 설치시 실행)                     | 캐시 파일 저장                                                        |
| activate | 서비스 워커 설치가 끝나면 실행한다. 서비스 워커의 업데이트 작업을 담당한다. | 캐시 파일 제거                                                        |
|  fetch   | 서비스 워커가 설치된 다음 실행될 때 실행 작업할 내용을 여기에 작성한다.     | 브라우저가 서버에 HTTP를 요청했을 때 오프라인 상태면 캐시 파일을 읽음 |

## 참고

- http://www.easyspub.co.kr/71_Menu/SearchList/PUB

```toc

```
