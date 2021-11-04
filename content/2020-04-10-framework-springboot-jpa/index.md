---
title: '[JPA] Springboot + JPA + MySql'
date: 2020-04-10 08:05:34
author: TMM
categories: Framework
tags: Springboot JPA
---

많이 늦었지만 JPA를 써볼려고 합니다.

### 개발 환경

gradle + lombok + mysql + jpa

### dependency 추가

dependencies {
implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
implementation 'org.springframework.boot:spring-boot-starter-oauth2-client'
implementation 'org.springframework.boot:spring-boot-starter-security'
implementation 'org.springframework.boot:spring-boot-starter-thymeleaf'
implementation 'org.springframework.boot:spring-boot-starter-web'
compileOnly 'org.projectlombok:lombok'
developmentOnly 'org.springframework.boot:spring-boot-devtools'
runtimeOnly 'mysql:mysql-connector-java'
annotationProcessor 'org.projectlombok:lombok'
testImplementation 'org.springframework.boot:spring-boot-starter-test'
testImplementation 'org.springframework.security:spring-security-test'
}

### application.yml 수정

### Entity 생성

### Repository 생성

### Contorller, Service 생성

### Column 옵션

### 참고사이트

```yaml
https://velog.io/@junwoo4690/Spring-Boot-JPA-%EC%82%AC%EC%9A%A9%ED%95%B4%EB%B3%B4%EA%B8%B0-erjpw41nl7
https://blog.woniper.net/255?category=531455
https://joont92.github.io/jpa/%EC%97%94%ED%8B%B0%ED%8B%B0-%EA%B0%92%EC%9D%84-%EB%B3%80%ED%99%98%ED%95%B4%EC%84%9C-%EC%A0%80%EC%9E%A5%ED%95%98%EA%B8%B0-Converter/
언더바: https://sunpil.tistory.com/302

https://galid1.tistory.com/531
https://goddaehee.tistory.com/95
```

```toc

```
