---
title: '[작성중][Flutter] Flutter 앱 제작'
date: 2023-03-19 08:05:34
author: TMM
categories: Framework
tags: Flutter
---

## 설치  (Mac Silicon 기준)

1. flutter 다운로드

    - https://docs.flutter.dev/get-started/install/macos

1. PATH 추가

    ```bash
    $ vi ~/.zshrc
    $ export PATH="$PATH:/Users/jhk/dev/application/flutter/bin"
    ```

1. Xcode 설치
    
    1. 앱스토어에서 Xcode 검색 후 설치 (시간이 많이 걸림)
    1. 설치된 Xcode 버전을 시스템에서 사용할 Xcode 버전으로 설정
        ```bash
        $ sudo sh -c 'xcode-select -s /Applications/Xcode.app/Contents/Developer && xcodebuild -runFirstLaunch'
        ```

1. Android Studio 설치

    1. Android Studio 다운로드
        - https://developer.android.com/studio
    1. Android Studio 실행 후 Plugins에서 flutter 검색 후 Install, Restart IDE
    1. Android SDK Command-line Tools설치

        1. Android Studio 실행 후 Customize 클릭
        1. 하단의 All settings... 클릭
        1. Android SDK 검색
        1. Android SDK Command-line Tools (latest) 채크
        1. 하단의 Apply 클릭
        1. Confirm 창에서 OK 클릭
        1. 하단의 OK 클릭

    1. Android Studio 라이센스 동의

        ```bash
        $ flutter doctor --android-licenses
        ... 모두 y 입력 ...
        ```

1. CocoaPods 설치

    1. Homebrew 설치
        ```bash
        $ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ```
    1. .zshrc 추가
        ```bash
        $ vi ~/.zshrc

        eval $(/opt/homebrew/bin/brew shellenv)
        ```
    1. brew 설치 확인
        ```bash
        $ brew --version
        ```
    1. rbenv 를 설치하여 ruby 버전 변경
        ```bash
        $ brew install rbenv
        $ rbenv install --list
        $ rbenv install 2.7.6
        $ rbenv global 2.7.6
        $ ruby --version
        ruby 2.6.10p210 (2022-04-12 revision 67958) 
        ```
    1. ruby 버전 변경이 안된 경우 .zshrc에 rbenv init추가
        ```bash
        $ vi ~/.zshrc
        eval "$(rbenv init - zsh)"
        
        $ source ~/.zshrc
        $ ruby --version
        ```
    1. cocoapods 설치
        ```bash
        $ sudo gem install cocoapods
        $ sudo gem uninstall ffi && sudo gem install ffi -- --enable-libffi-alloc
        ```
    
    1. Xcode 시뮬레이터 설치
        ```bash
        $ xcodebuild -downloadPlatform iOS
        ```

        - Xcode > Window > Device and Simulators 에서 Simulators 탭에서 설치 결과 확인 가능
1. 확인

    ```bash
    $ flutter doctor

    Doctor summary (to see all details, run flutter doctor -v):
    [✓] Flutter (Channel stable, 3.22.2, on macOS 14.5 23F79 darwin-arm64, locale ko-KR)
    [✓] Android toolchain - develop for Android devices (Android SDK version 35.0.0)
    [✓] Xcode - develop for iOS and macOS (Xcode 15.4)
    [✓] Chrome - develop for the web
    [✓] Android Studio (version 2024.1)
    [✓] VS Code (version 1.90.2)
    [✓] Connected device (4 available)
    [✓] Network resources

    • No issues found!
    ```

    - java version 이 낮은 경우 경고 발생. 17로 버전 업 필요

## 테스트 APP 실행

1. flutter create my_app
1. cd my_app
1. flutter run

## pubspec.yml 수정

- pubspec.yaml은 플러터 프로젝트의 모든 설정이 담긴 파일입니다.
- 파일이 수정되었을 때 에디터위의 **Pub get**을 클릭해 실행합니다.

1. dependencies 추가

    ```yaml
    dependencies:
        flutter:
            sdk: flutter

        cupertino_icons: ^1.0.2
        webview_flutter: 2.3.1 // webview 추가
    ```

1. image 추가

    ```yaml
    flutter:
        uses-material-design: true

        assets:
            - assets/
    ```

1. Pub get 실행

    - 안드로이드 스튜디오에서는 우측 상단의 Pub get 버튼 클릭
    - cli에서는 $**flutter pub get** 명령어 실행

1. 주요 pub 명령어

    |명령어|설명|
    |----|---|
    |flutter pub get|pubspec.yaml 파일에 등록한 플러그인들을 내려받습니다.|
    |flutter pub add [플러그인 이름]|pubspec.yaml에 플러그인을 추가합니다. 명령어의 끝에 플러그인 이름을 추가하면 됩니다.|
    |flutter pub upgrade|pubspec.yaml에 등록된 플러그인들을 모두 최신 버전으로 업데이트합니다.|
    |flutter pub run|현재 프로젝트를 실행합니다. 명령어를 실행하면 어떤 플렛폼에서 실앵할지 선택 할 수 있습니다.|

## main.dart wegeit 추가

## simulator 추가

## 내 아이폰에 앱 추가

1. 프로젝트 디렉토리로 이동
1. 명령어 실행
    ```bash
    $ open ios/Runner.xcworkspace
    ```
1. Xcode 실행 확인
1. 좌측 프로젝트 트리메뉴에서 Runner 클릭
1. TARGETS 트리 메뉴에서  Runner 클릭
1. 탭 메뉴에서 Signing & Capabilities 클릭
1. Team에서 Add Acount... 클릭 후 로그인
1. Team에서 로그인한 계정 선택
1. 아이폰에서 개발자 모드 켬으로 변경 및 신뢰할 수 있는 개발자 등록
    > https://code-boki.tistory.com/110
1. Android Studio 에서 Run -> Flutter Run 'main.dart' in Releasse Mode로 실행

## 네이티브 설정

- android
    ```xml
    <manifest xmlns:android="http://schemas.android.com/apk/res/android"
        package="com.example.app">
        <uses-permission android:name="android.permission.INTERNET" />
        ...
    </manifest>
    ```
- 자주 사용하는 안드로이드 권한 코드
    - INTERNET : 인터넷 사용 권한
    - CAMERA : 카메라 사용 권한
    - WRITE_EXTERNAL_STORAGE : 앱 외부에 파일을 저장할 수 있는 권한
    - READ_EXTERNAL_STORAGE : 앱 외부의 파일을 읽을 수 있는 권한
    - VIBRATE : 진동을 일으킬 수 있는 권한
    - ACCESS_FINE_LOCATION : GPS와 네트워크를 모두 사용해서 정확한 현재 위치 정보를 가져올 수 있는 권한
    - ACCESS_COARSE_LOCATION : 네트워크만 사용해서 대략적인 위치 정보를 가져올 수 있는 권한
    - ACCESS_BACKGROUND_LOCATION : 앱이 배경에 있을 때 위치 정보를 얻을 수 있는 권한
    - BILLING : 인앱 결제를 할 수 있는 권한
    - CALL_PHONE : 전화기 앱을 사용하지 않고 전화를 할 수 있는 권한
    - NETWORK_STATE : 네트워크 상태를 가져올 수 있는 권한
    - RECORD_AUDIO : 음성을 녹음할 수 이쓴 권한

## Firebase Cloud Messaging 설정

1. Firebase 사이트에서 프로젝트 생성
    - https://console.firebase.google.com/?hl=ko

1. SDK 안내에 따라 실행
    1. 앱 등록
        1. Android 패키지 이름
            - 
        1. 앱 닉네임 (선택사항)
            - 대충 입력
        1. 디버그 서명 인증서 SHA-1(선택사항)
            ```bash
            flutter-project/andorid$ gradlew signingReport

            Variant: debug
            Config: debug
            Store: /Users/jhk/.android/debug.keystore
            Alias: AndroidDebugKey
            MD5: D3:AB:***8F:60
            SHA1: 5E:3C:***A2:D9
            SHA-256: 94:CD:***B1:E2
            ```
    1. google-service.json 파일 다운로드 후 추가
    1. <project_name>/build.gradle 설정
    1. <project_name>/app/build.gradle 설정

1. Flutter앱에 Firebase추가
    - https://firebase.google.com/docs/flutter/setup?hl=ko&authuser=0&platform=ios
    1. firebase cli 설치 (npm)
        - https://firebase.google.com/docs/cli?authuser=0&hl=ko#setup_update_cli
        ```base
        $ npm install -g firebase-tools
        ```
    1. Firebase에 로그인
        ```bash
        $ firebase login
        ```

    1. FlutterFire CLI를 설치
        ```bash
        $ dart pub global activate flutterfire_cli
        ```
    
    1. FlutterFire CLI를 사용하여 Firebase에 연결하도록 Flutter 앱 구성 워크플로를 시작
        ```bash
        flutter-project$ flutterfire configure
        ```
        _flutterfire configure워크플로: Flutter 앱의 Firebase 구성이 최신 상태로 유지되고 Android의 경우 필요한 Gradle 플러그인이 앱에 자동으로 추가_

    1. core 플러그인을 설치
        ```bash
        flutter-project$ flutter pub add firebase_core
        ```

    1. Flutter 앱 구성 워크플로를 시작
        ```bash
        flutter-project$ flutterfire configure
        ```

    1. main.dart 수정

    1. Firebase console에서 "새 캠패인"으로 발송 테스트
        - 토큰 입력


https://firebase.google.com/docs/cloud-messaging/flutter/first-message?hl=ko



> 코트팩토리 플러터 책 소계: https://goldenrabbit.co.kr/product/must-have-codefactory-flutter/

> 코트팩토리 플러터 책 예제: https://github.com/codefactory-co/golden-rabbit-flutter-novice

> dart 소스 실행: https://dartpad.dev/

> vscode 에서 실행: https://velog.io/@jiyeah3108/Flutter-%EC%84%A4%EC%B9%98-%EB%B0%8F-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EC%83%9D%EC%84%B1