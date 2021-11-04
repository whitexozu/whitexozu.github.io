---
title: '[Security] Springboot + Security + MySQL'
date: 2020-03-04 08:05:34
author: TMM
categories: Framework
tags: Springboot Security
---

## Spring Security 장점

- 프로그램 로직보다 설정으로 페이지나 리소스 접근 제어
- JDBC, LDAP 등 호환되는 인증 커넥터 다수
- CSRF 등 강력한 보안 인증

## 폴더구조

```bash
.
├── build.gradle
├── gradlew
├── gradlew.bat
├── settings.gradle
└── src
    ├── main
    │   ├── java
    │   │   └── com
    │   │       └── example
    │   │           └── test
    │   │               ├── Application.java
    │   │               ├── config
    │   │               │   └── SecurityConfig.java
    │   │               ├── controller
    │   │               │   └── MemberController.java
    │   │               ├── domain
    │   │               │   ├── Role.java
    │   │               │   ├── entity
    │   │               │   │   └── MemberEntity.java
    │   │               │   └── repository
    │   │               │       └── MemberRepository.java
    │   │               ├── dto
    │   │               │   └── MemberDto.java
    │   │               ├── handler
    │   │               │   └── CustomAuthenticationFailureHandler.java
    │   │               └── service
    │   │                   └── MemberService.java
    │   └── resources
    │       ├── application.yml
    │       └── templates
    │           ├── admin.html
    │           ├── denied.html
    │           ├── index.html
    │           ├── login.html
    │           ├── loginSuccess.html
    │           ├── logout.html
    │           ├── myinfo.html
    │           └── signup.html
    └── test
        └── java
            └── com
                └── example
                    └── test
                        └── ApplicationTests.java
```

## 의존성 추가

```
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'org.springframework.boot:spring-boot-starter-thymeleaf'
    implementation 'org.thymeleaf.extras:thymeleaf-extras-springsecurity5'
}
```

## Spring Security 설정

### SecurityConfig.java

```java
package com.example.test.config;

import com.example.test.handler.CustomAuthenticationFailureHandler;
import com.example.test.service.MemberService;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import lombok.AllArgsConstructor;

@Configuration
@EnableWebSecurity
@AllArgsConstructor
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    private MemberService memberService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Override
    public void configure(WebSecurity web) throws Exception
    {
        // static 디렉터리의 하위 파일 목록은 인증 무시 ( = 항상통과 )
        web.ignoring().antMatchers("/css/**", "/js/**", "/img/**", "/lib/**");
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
                // 페이지 권한 설정
                .antMatchers("/admin/**").hasRole("ADMIN")
                .antMatchers("/user/myinfo").hasRole("MEMBER")
                .antMatchers("/**").permitAll()
            .and() // 로그인 설정
                .formLogin()
                .loginPage("/user/login")
                .defaultSuccessUrl("/user/login/result")
                .failureHandler(customAuthenticationFailureHandler())
                // .successHandler(authSuccessHandler)
                .permitAll()
            .and() // 로그아웃 설정
                .logout()
                .logoutRequestMatcher(new AntPathRequestMatcher("/user/logout"))
                .logoutSuccessUrl("/user/logout/result")
                .invalidateHttpSession(true)
            .and()
                // 403 예외처리 핸들링
                .exceptionHandling().accessDeniedPage("/user/denied");
    }

    @Override
    public void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(memberService).passwordEncoder(passwordEncoder());
    }

    @Bean
    public AuthenticationFailureHandler customAuthenticationFailureHandler() {
        return new CustomAuthenticationFailureHandler();
    }
}
```

- @EnableWebSecurity
  - @Configuration 클래스에 @EnableWebSecurity 어노테이션을 추가하여 Spring Security 설정할 클래스라고 정의합니다.
  - 설정은 WebSebSecurityConfigurerAdapter 클래스를 상속받아 메서드를 구현하는 것이 일반적인 방법입니다.
- WebSecurityConfigurerAdapter 클래스
  - WebSecurityConfigurer 인스턴스를 편리하게 생성하기 위한 클래스입니다.
- passwordEncoder()
  - BCryptPasswordEncoder는 Spring Security에서 제공하는 비밀번호 암호화 객체입니다.
  - Service에서 비밀번호를 암호화할 수 있도록 Bean으로 등록합니다.

다음으로 configure() 메서드를 오버라이딩하여, Security 설정을 잡아줍니다.

- configure(WebSecurity web)
  - WebSecurity는 FilterChainProxy를 생성하는 필터입니다.
  - web.ignoring().antMatchers("/css/**", "/js/**", "/img/**", "/lib/**");
    - 해당 경로의 파일들은 Spring Security가 무시할 수 있도록 설정합니다.
    - 즉, 이 파일들은 무조건 통과하며, 파일 기준은 resources/static 디렉터리입니다. ( css, js 등의 디렉터리를 추가하진 않았습니다. )
- configure(HttpSecurity http)
  - HttpSecurity를 통해 HTTP 요청에 대한 웹 기반 보안을 구성할 수 있습니다.
  - authorizeRequests()
    - HttpServletRequest에 따라 접근(access)을 제한합니다.
    - antMatchers() 메서드로 특정 경로를 지정하며, permitAll(), hasRole() 메서드로 역할(Role)에 따른 접근 설정을 잡아줍니다. 여기서 롤은 권한을 의미합니다. 즉 어떤 페이지는 관리지만 접근해야 하고, 어떤 페이지는 회원만 접근해야할 때 그 권한을 부여하기 위해 역할을 설정하는 것입니다. 예를 들어,
      - .antMatchers("/admin/\*\*").hasRole("ADMIN")
        - /admin 으로 시작하는 경로는 ADMIN 롤을 가진 사용자만 접근 가능합니다.
      - .antMatchers("/user/myinfo").hasRole("MEMBER")
        - /user/myinfo 경로는 MEMBER 롤을 가진 사용자만 접근 가능합니다.
      - .antMatchers("/\*\*").permitAll()
        - 모든 경로에 대해서는 권한없이 접근 가능합니다.
      - .anyRequest().authenticated()
        - 모든 요청에 대해, 인증된 사용자만 접근하도록 설정할 수도 있습니다. ( 예제에는 적용 안함 )
  - formlogin()
    - form 기반으로 인증을 하도록 합니다. 로그인 정보는 기본적으로 HttpSession을 이용합니다.
    - /login 경로로 접근하면, Spring Security에서 제공하는 로그인 form을 사용할 수 있습니다.
    - .loginPage("/user/login")
      - 기본 제공되는 form 말고, 커스텀 로그인 폼을 사용하고 싶으면 loginPage() 메서드를 사용합니다.
      - 이 때 커스텀 로그인 form의 action 경로와 loginPage()의 파라미터 경로가 일치해야 인증을 처리할 수 있습니다. ( login.html에서 확인 )
    - .defaultSuccessUrl("/user/login/result")
      - 로그인이 성공했을 때 이동되는 페이지이며, 마찬가지로 컨트롤러에서 URL 매핑이 되어 있어야 합니다.
    - .usernameParameter("파라미터명")
      - 로그인 form에서 아이디는 name=username인 input을 기본으로 인식하는데, usernameParameter() 메서드를 통해 파라미터명을 변경할 수 있습니다. ( 예제에는 적용 안함 )
  - logout()
    - 로그아웃을 지원하는 메서드이며, WebSecurityConfigurerAdapter를 사용할 때 자동으로 적용됩니다.
    - 기본적으로 "/logout"에 접근하면 HTTP 세션을 제거합니다.
    - .logoutRequestMatcher(new AntPathRequestMatcher("/user/logout"))
      - 로그아웃의 기본 URL(/logout) 이 아닌 다른 URL로 재정의합니다.
    - .invalidateHttpSession(true)
      - HTTP 세션을 초기화하는 작업입니다.
    - deleteCookies("KEY명")
      - 로그아웃 시, 특정 쿠기를 제거하고 싶을 때 사용하는 메서드입니다. ( 예제에는 적용안함 )
  - .exceptionHandling().accessDeniedPage("/user/denied"); - 예외가 발생했을 때 exceptionHandling() 메서드로 핸들링할 수 있습니다. - 예제에서는 접근권한이 없을 때, 로그인 페이지로 이동하도록 명시해줬습니다
- configure(AuthenticationManagerBuilder auth)
  - Spring Security에서 모든 인증은 AuthenticationManager를 통해 이루어지며 AuthenticationManager를 생성하기 위해서는 AuthenticationManagerBuilder를 사용합니다.
    - 로그인 처리 즉, 인증을 위해서는 UserDetailService를 통해서 필요한 정보들을 가져오는데, 예제에서는 서비스 클래스(memberService)에서 이를 처리합니다.
    - 서비스 클래스에서는 UserDetailsService 인터페이스를 implements하여, loadUserByUsername() 메서드를 구현하면 됩니다.
  - 비밀번호 암호화를 위해, passwordEncoder를 사용하고 있습니다.

### MemberService.java

```java
package com.example.test.service;

import com.example.test.domain.Role;
import com.example.test.domain.entity.MemberEntity;
import com.example.test.domain.repository.MemberRepository;
import com.example.test.dto.MemberDto;
import lombok.AllArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class MemberService implements UserDetailsService {
    private MemberRepository memberRepository;

    @Transactional
    public Long joinUser(MemberDto memberDto) {
        // 비밀번호 암호화
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        memberDto.setPassword(passwordEncoder.encode(memberDto.getPassword()));

        return memberRepository.save(memberDto.toEntity()).getId();
    }

    @Override
    public UserDetails loadUserByUsername(String userEmail) throws UsernameNotFoundException {
        Optional<MemberEntity> userEntityWrapper = memberRepository.findByEmail(userEmail);
        MemberEntity userEntity = userEntityWrapper.get();

        List<GrantedAuthority> authorities = new ArrayList<>();

        if (("admin@example.com").equals(userEmail)) {
            authorities.add(new SimpleGrantedAuthority(Role.ADMIN.getValue()));
        } else {
            authorities.add(new SimpleGrantedAuthority(Role.MEMBER.getValue()));
        }

        return new User(userEntity.getEmail(), userEntity.getPassword(), authorities);
    }
}
```

- joinUser()
  - 회원가입을 처리하는 메서드이며, 비밀번호를 암호화하여 저장합니다.
- loadUserByUsername()
  - 상세 정보를 조회하는 메서드이며, 사용자의 계정정보와 권한을 갖는 UserDetails 인터페이스를 반환해야 합니다.
  - 매개변수는 로그인 시 입력한 아이디인데, 엔티티의 PK를 뜻하는게 아니고 유저를 식별할 수 있는 어떤 값을 의미합니다. Spring Security에서는 username라는 이름으로 사용합니다.
    - 예제에서는 아이디가 이메일이며, 로그인을 하는 form에서 name="username"으로 요청해야 합니다.
  - authorities.add(new SimpleGrantedAuthority());
    - 롤을 부여하는 코드입니다. 롤 부여 방식에는 여러가지가 있겠지만, 회원가입할 때 Role을 정할 수 있도록 Role Entity를 만들어서 매핑해주는 것이 좋은 방법인것 같습니다. ( 참고 )
    - 예제에서는 복잡성을 줄이기 위해, 아이디가 "admin@example.com"일 경우에 ADMIN 롤을 부여했습니다.
  - new User()
    - return은 SpringSecurity에서 제공하는 UserDetails를 구현한 User를 반환합니다. ( org.springframework.security.core.userdetails.User )
    - 생성자의 각 매개변수는 순서대로 아이디, 비밀번호, 권한리스트입니다.

### CustomAuthenticationFailureHandler.java

```java
package com.example.test.handler;

import java.io.IOException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import lombok.extern.java.Log;

@Log
public class CustomAuthenticationFailureHandler
  implements AuthenticationFailureHandler {

    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void onAuthenticationFailure(
      HttpServletRequest request,
      HttpServletResponse response,
      AuthenticationException exception)
      throws IOException, ServletException {
        log.info("exception message: " + exception.getMessage());
        log.info("username" + request.getParameter("username"));
        log.info("password" + request.getParameter("password"));

        response.setStatus(HttpStatus.UNAUTHORIZED.value());
        response.sendRedirect("/user/login?errorMsg=" + exception.getMessage());
    }
}
```

- onAuthenticationFailure()

  - 로그인 실패 처리를 합니다.
  - request 에서 로그인 요청 정보를 확인 할 수 있습니다.

- Login fail Exception 설명

  | Exception                                 | 설명                                    |
  | ----------------------------------------- | --------------------------------------- |
  | BadCredentialException                    | 비밀번호가 일치하지 않을 때 던지는 예외 |
  | InternalAuthenticationServiceException    | 존재하지 않는 아이디일 때 던지는 예외   |
  | AuthenticationCredentialNotFoundException | 인증 요구가 거부됐을 때 던지는 예외     |
  | LockedException                           | 인증 거부 - 잠긴 계정                   |
  | DisabledException                         | 인증 거부 - 계정 비활성화               |
  | AccountExpiredException                   | 인증 거부 - 계정 유효기간 만료          |
  | CredentialExpiredException                | 인증 거부 - 비밀번호 유효기간 만료      |

### index.html

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.w3.org/1999/xhtml" xmlns:sec="http://www.w3.org/1999/xhtml">
  <head>
    <meta charset="UTF-8" />
    <title>메인</title>
  </head>
  <body>
    <h1>메인 페이지</h1>
    <hr />
    <a sec:authorize="isAnonymous()" th:href="@{/user/login}">로그인</a>
    <a sec:authorize="isAuthenticated()" th:href="@{/user/logout}">로그아웃</a>
    <a sec:authorize="isAnonymous()" th:href="@{/user/signup}">회원가입</a>
    <a sec:authorize="hasRole('ROLE_MEMBER')" th:href="@{/user/info}">내정보</a>
    <a sec:authorize="hasRole('ROLE_ADMIN')" th:href="@{/admin}">어드민</a>
  </body>
</html>
```

- sec:authorize를 사용하여, 사용자의 Role에 따라 보이는 메뉴를 다르게 합니다.
  - isAnonymous()
    - 익명의 사용자일 경우, 로그인, 회원가입 버튼을 노출합니다.
  - isAuthenticated()
    - 인증된 사용자일 경우, 로그아웃 버튼을 노출줍니다.
  - hasRole()
    - 특정 롤을 가진 사용자에 대해, 메뉴를 노출합니다.

### login.html

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.w3.org/1999/xhtml">
  <head>
    <meta charset="UTF-8" />
    <title>로그인 페이지</title>
  </head>
  <body>
    <h1>로그인</h1>
    <hr />

    <form th:action="@{/user/login}" method="post">
      <!-- <form action="/user/login" method="post"> -->
      <!-- <input type="hidden" th:name="${_csrf.parameterName}" th:value="${_csrf.token}" /> -->

      <input type="text" name="username" placeholder="이메일 입력해주세요" />
      <input type="password" name="password" placeholder="비밀번호" />
      <button type="submit">로그인</button>
    </form>

    <span th:text="${errorMsg}"></span>
  </body>
</html>
```

- `<input type="hidden" th:name="${_csrf.parameterName}" th:value="${_csrf.token}" />`
  - form에 히든 타입으로 csrf 토큰 값을 넘겨줍니다.
  - input hidden 타입으로 csrf 토큰 값을 넘겨주지 않고 있는데요, th:action을 사용하면 Thymeleaf가 csrf 토큰 값을 자동으로 추가해주므로 편리합니다.
- `<input type="text" name="username" placeholder="이메일 입력해주세요">`
  - 로그인 시 아이디의 name 애트리뷰트 값은 username이어야 합니다.

### loginSuccess.html

```html
<!DOCTYPE html>
<html lang="en" xmlns:sec="" xmlns:th="http://www.w3.org/1999/xhtml">
  <head>
    <meta charset="UTF-8" />
    <title>로그인 성공</title>
  </head>
  <body>
    <h1>로그인 성공!!</h1>
    <hr />
    <p><span sec:authentication="name"></span>님 환영합니다~</p>
    <a th:href="@{'/'}">메인으로 이동</a>
  </body>
</html>
```

- sec:authentication="name"
  - useranme 값을 가져옵니다.

## 추가해야할 내용

- 회원정보 수정
- 다양한 권한 추가

## 참고사이트

```yaml
설정 설명:
  - https://victorydntmd.tistory.com/328
login fail 처리:
  - https://javadeveloperzone.com/spring-boot/spring-security-custom-success-or-fail-handler/
  - https://www.baeldung.com/spring-security-custom-authentication-failure-handler
  - https://wedul.site/170
```

## 소스

[https://github.com/whitexozu/Springboot-Example](https://github.com/whitexozu/Springboot-Example)

```toc

```
