---
title: '[JAVA] Optional class'
date: 2020-03-04 08:05:34
author: TMM
categories: Language
tags: JAVA
---

## 클래스 설명

- 1.8 이상부터 추가된 java.util.Optional Class
- 복잡한 조건문 없이도 런타임에 널(null) 값으로 인해 발생하는 NullPointerException을 처리합니다.
- 제네릭을 제공해주는 래퍼 클래스(Wrapper class)입니다.
- Stream 클래스와 사용 방법이나 기본 사상이 매우 유사합니다.

## 자주쓰이는 메소드

### ofNullable(value)

null이 넘어올 경우, NPE를 던지지 않고 Optional.empty()와 동일하게 비어 있는 Optional 객체를 얻어옵니다.

```java
package optional;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public class OptionalTest {

  public static void main(final String[] args) throws Exception {
    final Map <Integer, String> cities = new HashMap <> ();
    cities.put(1, "Seoul");
    cities.put(2, "Busan");
    cities.put(3, "Daejeon");

    /*
      cities 의 4번째 값이 null이면 Optional.empty 반환, null이 아니면 Optional.[value] 반환
      값이 있으면 length 반환, 없으면 0 반환
    */
    final Optional < String > maybeCity = Optional.ofNullable(cities.get(4)); // Optional
    final int length = maybeCity.map(String::length).orElse(0); // null-safe
    System.out.println("length: " + length);

  }
}
```

### orElse(T other)

비어있는 Optional 객체에 대해서, 넘어온 인자를 반환합니다.

```java
final int length = maybeCity.map(String::length).orElse(0); // null-safe
```

### get()

비어있는 Optional 객체에 대해서, NoSuchElementException을 던집니다.

```java
MemberEntity userEntity = userEntityWrapper.get();
```

### ifPresent(Consumer<? super T> consumer)

이 메소드는 특정 결과를 반환하는 대신에 Optional 객체가 감싸고 있는 값이 존재할 경우에만 실행될 로직을 함수형 인자로 넘길 수 있습니다.

```java
maybeFood.ifPresent(city -> {
  System.out.println("length: " + city.length());
});
```

## 참고사이트

> [https://www.daleseo.com/java8-optional-after/](https://www.daleseo.com/java8-optional-after/)

```toc

```
