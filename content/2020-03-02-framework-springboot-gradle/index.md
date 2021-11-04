---
title: '[Gradle] Springboot + Gradle'
date: 2020-03-02 08:05:34
author: TMM
categories: Framework
tags: Springboot Gradle
---

VSCode에서 Springboot Gradle 프로젝트를 생성 후 관련 명령어들을 실행 하도록 하겠습니다.

### 프로젝트 생성

vscode extensions 중 _Java Extension Pack (Microsoft)_, _Spring Boot Extension Pack (Pivotal)_ 를 추가하면 생성이 가능합니다.
_command + shift + p_ 를 누르고 _Spring Initalizr: Generate a Gradle Project_ 선택 후 추가 정보를 입력 및 선택합니다.
그럼 bulid.gradle, gradlew 등 관련 파일들이 생성된것을 확인 할 수 있습니다.

### tasks 실행 명령어

- 별 설명이 없어도 이해할 수 있는 명령들 입니다.
  ```bash
  $ ./gradlew clean
  $ ./gradlew compileJava
  $ ./gradlew jar
  ```

### application 실행

gradle 프로젝트 생성시 타입을 java-applicaiton 주면 자동 셋팅 되지만 그렇지 않을경우 몇가지를 추가해야 메인 클레스를 실행 할 수 있습니다. 물론 스프링 메인 함수도 실행 가능 합니다.

- build.gradle 추가

  ```liquid
  plugins {
    id 'org.springframework.boot' version '2.2.5.RELEASE'
    id 'io.spring.dependency-management' version '1.0.9.RELEASE'
    id 'java'
    id "application"
  }

  mainClassName = "com.example.test.DemoApplication"
  ```

- 실행 명령어
  ```bash
  $ ./gradlew run
  ```

### spring boot run

- 실행 명령어
  ```bash
  $ ./gradlew bootrun
  ```

### dependencies 추가

- build.gradle 추가
  ```liquid
  dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-thymeleaf'
  }
  ```

### war 파일 생성

- build.gradle 추가

  ```liquid
  plugins {
    id "war"
  }

  dependencies {
    providedCompile 'org.springframework.boot:spring-boot-starter-tomcat'
  }

  bootWar {
      baseName = 'spring-boot-war'
      archiveVersion = "0.0.0"
      // archiveFileName = '-.war'
  }
  ```

- 실행 명령어
  ```bash
  $ ./gradlew bootwar
  ```
- tomcat 서버에 추가해서 실행

### jar 파일 생성

- build.gradle 추가
  ```liquid
  bootJar {
      archiveBaseName = 'spring-boot-jar'
      // archiveFileName = '-.jar'
      archiveVersion = "0.0.0"
  }
  ```
- 실행 명령어

  ```bash
  $ ./gradlew bootjar

  $ java -jar build/libs/spring-boot-jar-0.0.0.jar
  ```

### 참고사이트

```yaml
war: https://gigas-blog.tistory.com/115
jar: https://gigas-blog.tistory.com/114
build type: http://www.devkuma.com/books/pages/1069
step-by-step test: https://yookeun.github.io/java/2015/02/09/java-gradle/
```

```toc

```
