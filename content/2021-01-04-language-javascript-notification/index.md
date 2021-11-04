---
title: '[Javascript] Notification API'
date: 2021-01-04 08:05:34
author: TMM
categories: Javascript
tags: Notification Vue
---

PWA Push를 개발하다 Javascript의 Notification을 정리할 필요가 있을것 같아 정리합니다.<br />
웹 페이지나 앱에서 알림(Notifications) API를 사용하면 페이지 외부에 표시되는 알림을 보낼 수 있습니다. 이것은 시스템 레벨에서 처리되는 것으로 애플리케이션이 백그라운드에 있더라도 웹이 사용자에게 정보를 보낼 수 있습니다.

## 테스트

### 환경

- vue 기반으로 테스트 했습니다.

### 예제 소스

```vue
<template>
  <v-container>
    <v-row wrap>
      <!-- 상단에 제목 표시 -->
      <v-col cols="12" class="text-center">
        <h1 class="display-1">메시지 테스트</h1>
      </v-col>
    </v-row>
  </v-container>
</template>
<script>
export default {
  data() {
    return {};
  },
  mounted() {
    this.fnNotificationTest();
  },
  methods: {
    fnNotificationTest() {
      var parameter_noti = {
        title: '[알림] Web Notification',
        icon: 'https://bit.ly/2V1ipNj',
        body: '안녕하세요 세계',
      };

      if (!('Notification' in window)) {
        console.log('이 브라우저는 알림을 지원하지 않습니다.');
      } else {
        Notification.requestPermission(function (result) {
          console.log('Notification.requestPermission result : ', result);

          if (result !== 'granted') {
            console.log('푸시알림 기능이 허용되지 않았습니다!');
          } else {
            // 사용자가 허가하면 푸시알림 서비스 설정 실행
            var notification = new Notification(parameter_noti.title, {
              icon: parameter_noti.icon,
              body: parameter_noti.body,
            });
          }
        });
      }
    },
  },
};
</script>
```

### 권한 설명

- default: 사용자에게 아직 권한을 요구하지 않았으며 따라서 알림을 표시하지 않습니다.
- granted: 사용자에게 알림 표시 권한을 요구했으며 사용자는 권한을 허용했습니다.
- denied: 사용자가 명시적으로 알림 표시 권한을 거부했습니다.

### 권한 획득

```javascript
Notification.requestPermission().then(function (result) {
  console.log(result);
});
```

### 제한

- 테스트 시에는 localhost 로 알림을 받을 수 있습니다.
- IP, Domain 으로 접속할때는 HTTPS를 사용해야 합니다.
- 브라우저 탭이 닫히면 기능도 종료됩니다. 닫힌 상태에서도 받기 위해서는 PWA를 사용해야 합니다. 브라우저가 꺼지면 PWA도 받을 수 없습니다.
- 데스크탑에서는 Chrome, Safari 사용이 가능하나 모바일에서는 Android 에서만 사용이 가능 합니다. iOS에서는 Chrome, Safari, Firefox 모두 사용 불가 합니다. 자세한 브라우저 호환성은 참고사이트에서 확인 바랍니다.

## 참고사이트

- https://developer.mozilla.org/ko/docs/WebAPI/Using_Web_Notifications

```toc

```
