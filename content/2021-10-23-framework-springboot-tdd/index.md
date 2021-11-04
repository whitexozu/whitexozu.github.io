---
title: '[TDD] Springboot tdd'
date: 2021-10-23 08:05:34
author: TMM
categories: Framework
tags: TDD
---

JUnit 사용을 습관화 하기위해 정리 하려 합니다.

## TDD 장점

- 톰캣을 계속내렸다 올릴 필요가 없습니다.
- 자동검증이 가능합니다.
- 유지보수/디버깅이 쉽습니다.

## TDD 개발 순서

1. 빈 실행코드 작성
2. 테스트 코드 작성
3. 실행코드 리팩토링

## 실습

1. 프로젝트 생성

   ```txt
   Spring boot Version : 2.5.4
   Language : Java
   Group Id : com.example.tdd
   Artifact Id : practice
   Packaging Type : war
   Java version : 8
   dependencies : Lombok
   ```

### 응답 코드 확인

1. MemoController.java 생성

   ```java
   package com.example.tdd.practice.memo.controller;

   import com.example.tdd.practice.memo.dto.MemoResponseDto;

   import org.springframework.web.bind.annotation.GetMapping;
   import org.springframework.web.bind.annotation.RequestParam;
   import org.springframework.web.bind.annotation.RestController;

   @RestController
   public class MemoController {

       @GetMapping("/memo")
       public String memo() {
           return "get memo";
       }
   }
   ```

1. MemoControllerTest.java 생성

   ```java
   package com.example.tdd.practice.memo.controller;

   import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
   import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
   import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

   import org.junit.jupiter.api.Test;
   import org.junit.jupiter.api.extension.ExtendWith;
   import org.springframework.beans.factory.annotation.Autowired;
   import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
   import org.springframework.test.context.junit.jupiter.SpringExtension;
   import org.springframework.test.web.servlet.MockMvc;

   import static org.hamcrest.Matchers.is;
   import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

   @ExtendWith(SpringExtension.class)
   @WebMvcTest(controllers = MemoController.class)
   public class MemoControllerTest {

       @Autowired
       private MockMvc mvc;

       @Test
       public void getMemo() throws Exception {
           String getMemo = "get memo";

           mvc.perform(get("/memo")).andExpect(status().isOk()).andExpect(content().string(getMemo));
       }

   }
   ```

### 응답 데이터 확인

1. MemoController.java 수정

   ```java
   @RestController
   public class MemoController {

       ...
       @GetMapping("/memo/dto")
       public MemoResponseDto memoDto(@RequestParam("name") String name, @RequestParam("amount") int amount) {
           return new MemoResponseDto(name, amount);
       }
       ...
   }
   ```

1. MemoControllerTest.java 수정

   ```java
   public class MemoControllerTest {

       ...
       @Test
       public void getMemoResponseDto() throws Exception {
           String name = "apple";
           int amount = 1000;

           mvc.perform(get("/memo/dto").param("name", name).param("amount", String.valueOf(amount)))
                   .andExpect(status().isOk()).andExpect(jsonPath("$.name", is(name)))
                   .andExpect(jsonPath("$.amount", is(amount)));
       }
       ...

   }
   ```

### DTO 테스트

1. MemoResponseDto.java 생성

   ```java
   package com.example.tdd.practice.memo.dto;

   import lombok.Getter;
   import lombok.RequiredArgsConstructor;

   @Getter
   @RequiredArgsConstructor
   public class MemoResponseDto {

       private final String name;
       private final int amount;

   }
   ```

1. MemoResponseDtoTest.java 생성

   ```java
   package com.example.tdd.practice.memo.dto;

   import org.junit.jupiter.api.Test;

   import static org.assertj.core.api.Assertions.assertThat;

   public class MemoResponseDtoTest {

       @Test
       public void memoResponseDto() {
           // given
           String name = "test";
           int amount = 1000;

           // when
           MemoResponseDto dto = new MemoResponseDto(name, amount);

           // then
           assertThat(dto.getName()).isEqualTo(name);
           assertThat(dto.getAmount()).isEqualTo(amount);
       }
   }
   ```

## vscode에서 test 실행

- 클래스 전체 테스트: 클래스명 위의 _Run Test_ 클릭
- 메소드 테스트: 메소드명 위의 _Run Test_ 클릭

```toc

```
