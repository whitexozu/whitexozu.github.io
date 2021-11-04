---
title: '[JAVA] enum 데이터 타입'
date: 2020-03-06 08:05:34
author: TMM
categories: Language
tags: JAVA
---

## 클래스 설명

- 상수의 그룹을 나타낼 때 사용한다.
- 허용 가능한 값들을 제한할 수 있습니다.
- IDE의 적극적인 지원을 받을 수 있습니다.
  - 자동완성, 오타검증, 텍스트 리팩토링 등등

## 사용 방법

### 기본적인 사용

- EnumBasic.java

  ```java
  package enumeration;

  enum Color {
      RED, GREEN, BLUE;
  }

  public class EnumBasic {

      public static void main(final String[] args) throws Exception {
          // values(): 모든 상수 반환
          Color arr[] = Color.values();

          for (Color col : arr) {
              // ordinal(): 상수 인덱스 반환
              System.out.println(col + " at index " + col.ordinal());
          }

          // valueOf(String): 상수 문자값 반환
          System.out.println(Color.valueOf("RED"));

          // 일반적인 호출
          System.out.println(Color.GREEN);
      }
  }
  ```

### 좀더 다양한 사용

설명은 EnumUse.java 파일의 주석으로 대신 하겠습니다.

- EnumSocial.java

  ```java
  package enumeration;

  public enum EnumSocial {
      FACEBOOK("facebook"),
      GOOGLE("google"),
      KAKAO("kakao"),
      NAVER("naver");

      private final String ROLE_PREFIX = "ROLE_";
      private String name;

      EnumSocial(String name) { this.name = name; }

      public String getRoleType() { return ROLE_PREFIX + name.toUpperCase(); }

      public String getValue() { return name; }

      public boolean isEquals(String authority) { return this.getRoleType().equals(authority);}
  }
  ```

- EnumCalculator.java

  ```java
  package enumeration;

  import java.util.function.Function;

  public enum EnumCalculator {
      CALC_A(value -> value),
      CALC_B(value -> value * 10),
      CALC_C(value -> value * 3),
      CALC_ETC(value -> 0L);

      private Function<Long, Long> expression;

      EnumCalculator(Function<Long, Long> expression) {
          this.expression = expression;
      }

      public long calculate(long value){
          return expression.apply(value);
      }
  }
  ```

- EnumPayType.java

  ```java
  package enumeration;

  public enum EnumPayType {

      ACCOUNT_TRANSFER("계좌이체"),
          REMITTANCE("무통장입금"),
          ON_SITE_PAYMENT("현장결제"),
          TOSS("토스"),
          PAYCO("페이코"),
          CARD("신용카드"),
          KAKAO_PAY("카카오페이"),
          BAEMIN_PAY("배민페이"),
          POINT("포인트"),
          COUPON("쿠폰");

      private String title;

      EnumPayType(String title) {
          this.title = title;
      }

      public String getTitle() {
          return title;
      }
  }
  ```

- EnumPayGroup.java

  ```java
  package enumeration;

  import java.util.Arrays;
  import java.util.Collections;
  import java.util.List;

  public enum EnumPayGroup {

      CASH("현금", Arrays.asList(EnumPayType.ACCOUNT_TRANSFER, EnumPayType.REMITTANCE, EnumPayType.ON_SITE_PAYMENT, EnumPayType.TOSS)),
      CARD("카드", Arrays.asList(EnumPayType.PAYCO, EnumPayType.CARD, EnumPayType.KAKAO_PAY, EnumPayType.BAEMIN_PAY)),
      ETC("기타", Arrays.asList(EnumPayType.POINT, EnumPayType.COUPON)),
      EMPTY("없음", Collections.EMPTY_LIST);

      private String title;
      private List<EnumPayType> payList;

      EnumPayGroup(String title, List<EnumPayType> payList) {
          this.title = title;
          this.payList = payList;
      }

      public static EnumPayGroup findByEnumGroup(EnumPayType EnumPayType){
          return Arrays.stream(EnumPayGroup.values())
                  .filter(payGroup -> payGroup.hasPayCode(EnumPayType))
                  .findAny()
                  .orElse(EMPTY);
      }

      public boolean hasPayCode(EnumPayType EnumPayType){
          return payList.stream()
                  .anyMatch(pay -> pay == EnumPayType);
      }

      public String getTitle() {
          return title;
      }

  }
  ```

- EnumUse.java

  ```java
  package enumeration;

  import static enumeration.EnumSocial.*;
  import static enumeration.EnumCalculator.*;
  import static enumeration.EnumPayGroup.*;
  import static enumeration.EnumPayType.*;

  public class EnumUse {

      public static void main(final String[] args) throws Exception {

          // 일반적인 사용
          System.out.println(GOOGLE.getValue());
          System.out.println(NAVER.getRoleType());
          System.out.println(FACEBOOK.isEquals("ROLE_FACEBOOK"));



          // 소스의 간소화
          final String socialName = "KAKAO";

          // 일반적인 조건문
          if ( "KAKAO".equals(socialName) ) {
              System.out.println("ROLE_" + socialName);
          } else if ( "FACEBOOK".equals(socialName) ) {
              System.out.println("ROLE_" + socialName);
          } else if ( "GOOGLE".equals(socialName) ) {
              System.out.println("ROLE_" + socialName);
          } else {
              System.out.println("ROLE_" + socialName);
          }
          // enum 을 적용 한 조건문
          System.out.println(EnumSocial.valueOf(socialName).getRoleType());
          // 일반적인 방법을 별도의 함수로 만들어 사용한다면 큰 차이가 없어보일수 있으나 조건이 되는 키워드가 많아질수록 소스 양에 차이는 커지게 됩니다.



          // 상태와 행위의 관리
          final String calcType = "CALC_C";

          EnumCalculator enumCalculator = EnumCalculator.valueOf(calcType);
          System.out.println(enumCalculator.calculate(100000L));



          // 데이터 그룹 관리, 입력된 하위 코드의 상위 그룹 조회
          final String code = "COUPON";

          EnumPayGroup enumPayGroup = EnumPayGroup.findByEnumGroup(EnumPayType.valueOf(code));
          System.out.println(enumPayGroup.name());
          System.out.println(enumPayGroup.getTitle());
      }
  }
  ```

## 참고사이트

```
- https://velog.io/@pop8682/Enum-27k067ns4a
- https://woowabros.github.io/tools/2017/07/10/java-enum-uses.html
```

```toc

```
