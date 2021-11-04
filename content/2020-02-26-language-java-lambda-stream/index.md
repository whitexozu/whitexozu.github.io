---
title: '[JAVA] Lambda + Stream API '
date: 2020-02-26 08:05:34
author: TMM
categories: Language
tags: JAVA Lambda Stream API anonymous class
---

### 정의

- 식별자 없이 실행 가능한 함수 표현식입니다.
- 익명 클래스와 비슷합니다.
- 자바로 함수형 프로그래밍 개발을 할 수 있습니다.

### 관련 지식

- 함수형 인터페이스: 하나의 메소드만 선언되어 있는 인터페이스를 함수형 인터페이스라고 부릅니다.
- 익명 클래스: 이름이 없는 객체입니다. 인터페이스를 구현하기 위해 해당 인터페이스를 구현한 클래스를 생성해야 하는데 일회성이고 재사용할 필요가 없다면 굳이 클래스 파일을 만들 필요가 없습니다.

### 기본 예제

- Calculator.java

  ```java
  package lambda;

  @FunctionalInterface
  public interface Calculator {
      public void add(int num1, int num2);
  }
  ```

- BasicUsage.java

  ```java
  package lambda;

  public class BasicUsage
  {
      public static void main(final String[] args) {
          final Calculator cal = (num1, num2) -> { System.out.println(num1 + num2); };
          cal.add(1, 3);
      }
  }
  ```

### 어노테이션

- 어노테이션 `@FunctionalInterface` 을 사용하면 이 인터페이스는 함수형 인터페이스이며 메소드가 두개 이상 만들면 문법 오류가 나게되어 이후에 수정을 방지할 수 있습니다.

### Lambda의 다양한 함수형 인터페이스

> https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html

- LambdaTest.java

  ```java
  package lambda;

  import java.util.Arrays;
  import java.util.List;

  import java.util.function.Predicate;
  import java.util.function.Consumer;

  public class LambdaTest {

      public static void main(String[] args) {
          /*
          * Predicate
          * 문자열을 받아서 해당 문자열이 빈 문자열인지를 반환
          */
          String str = "asd";
          System.out.println(lambdaIsEqual(p->p.isEmpty(), str));
      }

      /**
      * boolean Predicate<T>
      */
      public static <T> boolean lambdaIsEqual(Predicate<T> predicate,T t) {
          return predicate.test(t);
      }
  }
  ```

### Stream API

- Lambda 를 소개할때 *Stream API*는 필수인거 같습니다. _Stream API_ 이란 컬렉션, 배열등의 저장 요소를 하나씩 참조하며 함수형 인터페이스(람다식)를 적용하며 반복적으로 처리할 수 있도록 해주는 기능입니다.
- 꼭 알아둘 사항입니다.
  - Stream 은 재사용 불가
  - 병렬 스트림으로 멀티 쓰레드 사용이 가능
  - 중개 연산이 아닌 지연 연산 사용
- 연산자 설명은 하기 링크로 대처하겠습니다. 너무 많아요.
  > https://jeong-pro.tistory.com/165

### anonymous class

- AnonymousClassTest.java

  ```java
  package anonymous;

  interface Test{
      public void go(String name);
  }

  public class AnonymousClassTest {

      public static void main(String[] args) {
          Test test = new Test(){
              public void go(String name){
                  System.out.println(name + " GO! GO!");
              }
          };
          test.go("aaa");
      }
  }
  ```

### 참고 사이트

```yaml
lambda: https://coding-factory.tistory.com/265
  https://jdm.kr/blog/181
  http://tcpschool.com/java/java_lambda_concept
  https://coding-start.tistory.com/131

anonymous class: https://yulsfamily.tistory.com/112

stream: https://jeong-pro.tistory.com/165
```

```toc

```
