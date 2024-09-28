---
title: '[Redis] 설치 및 명령어'
date: 2022-02-20 08:05:34
author: TMM
categories: Application
tags: Redis
---

Redis는 메모리 기반의 key-value 구조의 데이터 관리 시스템이다. 쓸곳이 많죠.

## Redis 장점

- 다양한 구조의 데이터 처리에 유용
- 빠른 읽기/쓰기 속도
- 영속적인 데이터 보존

## Redis 특징

- 영속성을 지원하는 In-memory 데이터 저장소
- Master/slave 서버 복제 지원
- 샤딩 지원

## Redis의 기능

- In-Memory 캐싱
- Pub/Sub 메세지 큐
- 세션 스토어

## Redis가 지원하는 데이터 형식

- String
- Set
- Sorted Set
- Hash
- List

## Window 설치 및 실행

1. https://github.com/MSOpenTech/redis/releases
1. 원하는 버전 클릭, 저는 "3.2.100"을 선택 했습니다.
1. Redis-x64-3.2.100.zip 클릭해 다운로드 후 적당한 위치에 압축을 풀어 줍니다.
1. redis.windows-service.conf를 복사해 redis.conf를 생성합니다.
1. 패스워드 사용을 위해 _requirepass foobared_ 검색해 *requirepass password*를 추가 후 패스워드를 설정해 줍니다.
1. CMD에서 해당 폴더로 이동합니다.
1. _redis-server --service-install redis.conf --service-name redis_ 실행
1. _redis-server --service-start --service-name redis_ 실행
1. _redis-cli_ 실행
1. _auth [password]_ 입력
1. _redis-server --service-stop --service-name redis_ 실행
1. _redis-server --service-uninstall --service-name redis_ 실행

   _msi 버전을 다운받아서 설치 할 수 있지만 윈도우 서비스에 직접 등록 및 삭제를 위해 zpi으로 다운 받았습니다._

## Linux 설치

## 명령어

- keys
- set
- get
- del
- flushall
- list
  - lpush : 지정된 모든 값을 키에 저장된 목록의 처음에 넣습니다. 키가 없으면 조작을 수행하기 전에 키가 빈 목록으로 작성
  - rpush : 지정된 모든 값을 키에 저장된 목록의 끝에 넣습니다. 키가 없으면 조작을 수행하기 전에 키가 빈 목록으로 작성
  - lrange : list형식으로 저장된 키의 값을 개수를 인덱스를 지정하여 가져올 수 있음. 음수의 경우일 경우는 마지막 값을 의미
  - lpop : 리스트 키에 저장된 목록의 첫 번째 요소를 제거하고 반환
  - rpop : 리스트 키에 저장된 목록의 마지막 요소를 제거하고 반환
  - lpushx : 키가 이미 있고 목록을 보유하고 있는 경우에만 목록의 첫 번째에 값을 삽입합니다.
  - rpushx : 키가 이미 있고 목록을 보유하고 있는 경우에만 목록의 마지막에 값을 삽입합니다.
  - lindex : 리스트 키에 지정된 인덱스 요소를 반환합니다. 0은 첫 번째, 1은 두 번쨰, -1 뒤에서 첫번째, -2 뒤에서 두번째
- hash
  - hset
  - hget
  - hmset
  - hmget
  - hexists
  - hsetnx
  - hkeys
  - hvals
  - hdel
- Pub/Sub
  - pubsub
  - subscribe
  - publish
  - plusbscribe

## Spring-boot 연동

1. pom.xml

   ```xml
   ...
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-data-redis</artifactId>
   </dependency>
   ...
   ```

1. application.yml

   ```yml
   spring:
     redis:
       lettuce:
         pool:
           max-active: 10
           max-idle: 10
           min-idle: 2
       port: 6379
       host: 127.0.0.1
       password: p@ssWord
   ```

1. RedisConfig.java

   ```java

   package com.example.websocket.config;

   import org.springframework.beans.factory.annotation.Value;
   import org.springframework.context.annotation.Bean;
   import org.springframework.context.annotation.Configuration;
   import org.springframework.data.redis.connection.RedisConnectionFactory;
   import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
   import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
   import org.springframework.data.redis.core.RedisTemplate;
   import org.springframework.data.redis.serializer.StringRedisSerializer;

   @Configuration
   public class RedisConfig {
       @Value("${spring.redis.host}")
       private String redisHost;
       @Value("${spring.redis.port}")
       private String redisPort;
       @Value("${spring.redis.password}")
       private String redisPassword;

       @Bean
       public RedisConnectionFactory redisConnectionFactory() {
           RedisStandaloneConfiguration redisStandaloneConfiguration = new RedisStandaloneConfiguration();
           redisStandaloneConfiguration.setHostName(redisHost);
           redisStandaloneConfiguration.setPort(Integer.parseInt(redisPort));
           redisStandaloneConfiguration.setPassword(redisPassword);
           LettuceConnectionFactory lettuceConnectionFactory = new LettuceConnectionFactory(redisStandaloneConfiguration);
           return lettuceConnectionFactory;
       }

       @Bean
       public RedisTemplate<String, Object> redisTemplate() {
           RedisTemplate<String, Object> redisTemplate = new RedisTemplate<>();
           redisTemplate.setConnectionFactory(redisConnectionFactory());
           redisTemplate.setKeySerializer(new StringRedisSerializer());
           redisTemplate.setValueSerializer(new StringRedisSerializer());
           return redisTemplate;
       }
   }

   ```

1. RedisDTO.java

```java
package com.example.websocket.redis.domain;

import lombok.Data;

@Data
public class RedisDTO {
    private String key;
    private String value;
}
```

1. RedisController.java

```java
package com.example.websocket.redis.controller;

import com.example.websocket.redis.domain.RedisDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/redis")
public class RedisController {
    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    @PostMapping()
    public ResponseEntity<?> set(@RequestBody RedisDTO dto) {
        ValueOperations<String, String> vop = redisTemplate.opsForValue();
        vop.set(dto.getKey(), dto.getValue());
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @GetMapping("/{key}")
    public ResponseEntity<?> get(@PathVariable String key) {
        ValueOperations<String, String> vop = redisTemplate.opsForValue();
        String value = vop.get(key);
        return new ResponseEntity<>(value, HttpStatus.OK);
    }
}
```

1. curl

```bash
$ curl -d '{"key":"red", "value":"apple"}' \
-H "Content-Type: application/json" \
-X POST http://localhost:8881/redis

$ curl -X GET http://localhost:8881/redis/red | jq ''
```

1. RedisControllerTest.java

```java

```

## 참고

- Window 설치: https://gerger.tistory.com/143
- Redis 설명: https://n1tjrgns.tistory.com/282
- List: https://realmojo.tistory.com/169
- Hash: https://luran.me/376
- Pub/Sub: https://luran.me/385
- Spring-boot: https://bcp0109.tistory.com/328
- Spring-boot: https://oingdaddy.tistory.com/239
- Spring-boot: https://velog.io/@devsh/Redis-8-Spring-Boot-Redis-%EC%82%AC%EC%9A%A9%ED%95%B4%EB%B3%B4%EA%B8%B0
