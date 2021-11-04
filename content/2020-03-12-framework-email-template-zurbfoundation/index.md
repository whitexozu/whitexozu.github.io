---
title: '[Email template] ZURB Foundation'
date: 2020-03-12 08:05:34
author: TMM
categories: Framework
tags: ZURB Foundation email templdate
---

사용자에게 뉴스레터, 공지 이메일 등의 이메일을 HTML 형식으로 발송해야 할 때가 있습니다.<br />
통이미지로 보내면 편하겠지만 텍스트가 수시로 바뀌거나 다국어가 지원돼야 하는 경우 HTML로 작성해야 합니다.<br />
그럼 퍼블리셔팀에게 요청하게 되고 `템플릿 디자인`과 `이메일 클라이언트` 확인 후 단순한 페이지도 최소 2일 정도에 시간이 필요하다고 합니다.<br />
생각보다 오래 걸리네 라는 생각이 듭니다. 그리고 템플릿 코드를 받아보면 무지의 소치에서 나온 생각임을 깨닫게 됩니다.(제 이야기 입니다)<br />
<br />
결론부터 말하자면 이메일은 HTML 표준이 없습니다.<br />
이메일 클라이언트에 따라 허용되는 HTML에 대중이 없습니다. 필수 클라이언트의 종류가 많아질수록 코드는 예외 처리와 핵이 난무하게 됩니다.<br />
상황이 이러다 보니 `ZURB Foundation` 같은 웹 및 이메일 템플릿을 쉽게 디자인 할 수 있는 프레임워크를 사용하게 됩니다.<br />

## 설치 방법 및 실행

세상 간단합니다.

```bash
$ npm install --global foundation-cli

$ foundation new --framework emails

# project name 입력

$ cd [project name]

$ npm run start
```

그럼 브라우저에서 사이트가 열리는것을 확인 할 수 있습니다.

**Note:**<br />
nvm을 사용한 테스트 결과 v12에서는 프로젝트 생성이 되지 않았습니다. v10 에서 사용하기를 추천 드립니다.
{: .notice--info}

## 폴더구조

```bash
.
├── LICENSE
├── README.md
├── config.json
├── dist
├── etc
├── example.config.json
├── gulpfile.babel.js
├── node_modules
├── package.json
└── src
    ├── assets
    ├── helpers
    ├── layouts
    ├── pages
    └── partials
```

## 코딩

- pages 폴더의 예제 소스를 정리하고 코딩을 하게되면 dist폴더에 결과가 생성됩니다.

## 메일 발송 설정 및 테스트

### smtp 서버 사용을 설정합니다. 저는 네이버 smtp 서버를 사용하겠습니다.

1. 네이버 메일의 환경설정으로 이동합니다.<br />
   ![click setting button](https://whitexozu.github.io/assets/images/framework-email-template-zurbfoundation_1.PNG){: width="300" height="300"){: .center}
1. smtp 사용을 선택합니다.<br />
   ![modify setting](https://whitexozu.github.io/assets/images/framework-email-template-zurbfoundation_2.PNG){: width="500" height="500"){: .center}

### config 설정

1. example.config.json 파일을 복사하여 config.json 파일을 생성합니다.
2. smtp 서버 정보를 수정합니다.
   ```json
   "mail": {
       "to": [
           "[emailId]@naver.com",
           "[emailId]@gmail.com"
       ],
       "from": "[name] <[emailId]@naver.com>",
       "smtp": {
           "auth": {
               "user": "[emailId]",
               "pass": "[emailPassword]"
           },
           "host": "smtp.naver.com",
           "secureConnection": true,
           "port": 465
       }
   }
   ```

### 메이 발송

```bash
$ npm run mail

> foundation-emails-template@1.0.0 mail /Users/[user name]/dev/temp/email_test
> gulp mail --production

[19:06:23] Requiring external module babel-register
[19:06:42] Using gulpfile ~/dev/temp/email_coding/email_test/gulpfile.babel.js
[19:06:42] Starting 'mail'...
[19:06:42] Starting 'build'...
[19:06:42] Starting 'clean'...
[19:06:42] Finished 'clean' after 19 ms
[19:06:42] Starting 'pages'...
[19:06:43] Finished 'pages' after 1.08 s
[19:06:43] Starting 'sass'...
[19:06:49] Finished 'sass' after 5.96 s
[19:06:49] Starting 'images'...
[19:06:51] gulp-imagemin: Minified 0 images
[19:06:51] Finished 'images' after 1.52 s
[19:06:51] Starting 'inline'...
[19:06:54] Finished 'inline' after 3.14 s
[19:06:54] Finished 'build' after 12 s
[19:06:54] Starting 'creds'...
[19:06:54] Finished 'creds' after 1.58 ms
[19:06:54] Starting 'aws'...
[19:06:55] Finished 'aws' after 1.57 s
[19:06:55] Starting 'mail'...
[19:06:57] Send email [TEST] basic to [emailId]@naver.com,[emailId]@gmail.com
[19:06:57] Finished 'mail' after 1.58 s
[19:06:57] Finished 'mail' after 15 s
```

**Note:**<br />
템플릿에 이미지파일을 사용할경우 개발시에는 assets폴더에 저장후 사용이 가능하나 이메일 발송시에는 aws에 접근하려고 하여 에러가 발생합니다.
이미지 사용은 별도의 이미지 파일 서버에 업로드 후 사용 할 수 있습니다.
{: .notice--info}

## email client 종류

### 모바일 이메일 클라이언트

- Android 2.3 및 4.0
- iPhone 5 iOS 6
- iPhone 4S iOS 6
- iPhone 3GS iOS 5
- iPad 2 iOS 6
- BlackBerry OS 4 & 5
- Symbian S60
- Windows Phone 7.5

### 데스크톱 이메일 클라이언트

- Apple Mail 4, 5, 6
- Lotus Notes 8.5
- Lotus Notes 8
- Thunderbird
- Windows Live Mail
- Outlook 2013 (v15)
- Mac 용 Outlook 2011
- Outlook 2010 (v14)
- Outlook 2007 (v12)
- Outlook 2003 (v11)
- Outlook 2002 / XP (v10)
- Outlook 2000 (v9)

### 웹 메일 클라이언트

- AOL Mail (on any browser)
- Gmail (on any browser)
- Outlook.com (on any browser)
- Yahoo! (on any browser)

## 참고 사이트

```yaml
ZURB Fundation Getting Start: https://get.foundation/emails/docs/sass-guide.html
```

```toc

```
