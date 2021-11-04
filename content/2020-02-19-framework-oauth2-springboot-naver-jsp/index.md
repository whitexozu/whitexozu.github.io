---
title: '[OAuth2] Springboot + naver + jsp'
date: 2020-02-19 08:05:34
author: TMM
categories: Framework
tags: OAuth2 Springboot naver
---

## Naver developers > Application > Application 등록

    1.  어플리케이션 이름 입력 : naver_sign_in
    2.  사용 API 선택 : 네아로
    3.  사용 API 전부 선택
    4.  로그인 오픈 API 서비스 환경 : PC웹
    5.  서비스 URL 입력 : [http://localhost:8080/oauth/signin](http://localhost:8080/oauth/signin)
    6.  Callback URL 입력 : [http://localhost:8080/oauth/callback](http://localhost:8080/oauth/callback)
    7.  등록하기 버튼 클릭
    8.  애플리 케이션 정보 확인
        -   Client ID : **********
        -   Client Secret : **********

## 소스 작성

    1. navem project 생성
    2.  pom.xml
        ```xml
        <!-- jstl -->
        <dependency>
         <groupId>javax.servlet</groupId>
         <artifactId>jstl</artifactId>
         <version>1.2</version>
        </dependency>

        <!-- jsp -->
        <dependency>
         <groupId>org.apache.tomcat.embed</groupId>
         <artifactId>tomcat-embed-jasper</artifactId>
        </dependency>

        <!-- 제이슨 파싱 -->
        <dependency>
         <groupId>com.googlecode.json-simple</groupId>
         <artifactId>json-simple</artifactId>
         <version>1.1.1</version>
        </dependency>

        <!-- oauth -->
        <dependency>
         <groupId>com.github.scribejava</groupId>
         <artifactId>scribejava-core</artifactId>
         <version>2.8.1</version>
        </dependency>
        ```

    3.  java/com/example/oauth/config/NaverSigninApi.java
        ```java
        package com.example.oauth.config;
        import com.github.scribejava.core.builder.api.DefaultApi20;

        public class NaverSigninApi extends DefaultApi20 {
         protected NaverSigninApi() {}
         private static class InstanceHolder {
             private static final NaverSigninApi INSTANCE = new NaverSigninApi();
         }
         public static NaverSigninApi instance() {
             return InstanceHolder.INSTANCE;
         }
         @Override
         public String getAccessTokenEndpoint() {
             return "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code";
         }
         @Override
         protected String getAuthorizationBaseUrl() {
             return "https://nid.naver.com/oauth2.0/authorize";
         }
        }
        ```

    4.  java/com/example/oauth/config/NaverSigninBo.java
        ```java
        package com.example.oauth.config;

        import java.io.IOException;
        import java.util.UUID;
        import javax.servlet.http.HttpSession;
        import org.springframework.util.StringUtils;
        import com.github.scribejava.core.builder.ServiceBuilder;
        import com.github.scribejava.core.model.OAuth2AccessToken;
        import com.github.scribejava.core.model.OAuthRequest;
        import com.github.scribejava.core.model.Response;
        import com.github.scribejava.core.model.Verb;
        import com.github.scribejava.core.oauth.OAuth20Service;

        import org.springframework.stereotype.Component;

        @Component
        public class NaverSigninBO {
         /* 인증 요청문을 구성하는 파라미터 */
         //client_id: 애플리케이션 등록 후 발급받은 클라이언트 아이디
         //response_type: 인증 과정에 대한 구분값. code로 값이 고정돼 있습니다.
         //redirect_uri: 네이버 로그인 인증의 결과를 전달받을 콜백 URL(URL 인코딩). 애플리케이션을 등록할 때 Callback URL에 설정한 정보입니다.
         //state: 애플리케이션이 생성한 상태 토큰
         private final static String CLIENT_ID = "cI_EDT7R0b9SHI5xV8pp";
         private final static String CLIENT_SECRET = "xEzetWVT1b";
         private final static String REDIRECT_URI = "http://localhost:8080/oauth/naver/callback";
         private final static String SESSION_STATE = "oauth_state";
         /* 프로필 조회 API URL */
         private final static String PROFILE_API_URL = "https://openapi.naver.com/v1/nid/me";
         /* 네이버 아이디로 인증 URL 생성 Method */
         public String getAuthorizationUrl(HttpSession session) {
             /* 세션 유효성 검증을 위하여 난수를 생성 */
             String state = generateRandomString();
             /* 생성한 난수 값을 session에 저장 */
             setSession(session, state);
             /* Scribe에서 제공하는 인증 URL 생성 기능을 이용하여 네아로 인증 URL 생성 */
             OAuth20Service oauthService = new ServiceBuilder()
                 .apiKey(CLIENT_ID)
                 .apiSecret(CLIENT_SECRET)
                 .callback(REDIRECT_URI)
                 .state(state) //앞서 생성한 난수값을 인증 URL생성시 사용함
                 .build(NaverSigninApi.instance());
             return oauthService.getAuthorizationUrl();
         }
         /* 네이버아이디로 Callback 처리 및 AccessToken 획득 Method */
         public OAuth2AccessToken getAccessToken(HttpSession session, String code, String state) throws IOException {
             /* Callback으로 전달받은 세선검증용 난수값과 세션에 저장되어있는 값이 일치하는지 확인 */
             String sessionState = getSession(session);
             if (StringUtils.pathEquals(sessionState, state)) {
                 OAuth20Service oauthService = new ServiceBuilder()
                     .apiKey(CLIENT_ID)
                     .apiSecret(CLIENT_SECRET)
                     .callback(REDIRECT_URI)
                     .state(state)
                     .build(NaverSigninApi.instance());
                 /* Scribe에서 제공하는 AccessToken 획득 기능으로 네아로 Access Token을 획득 */
                 OAuth2AccessToken accessToken = oauthService.getAccessToken(code);
                 return accessToken;
             }
             return null;
         }
         /* 세션 유효성 검증을 위한 난수 생성기 */
         private String generateRandomString() {
             return UUID.randomUUID().toString();
         }
         /* http session에 데이터 저장 */
         private void setSession(HttpSession session, String state) {
             session.setAttribute(SESSION_STATE, state);
         }
         /* http session에서 데이터 가져오기 */
         private String getSession(HttpSession session) {
             return (String) session.getAttribute(SESSION_STATE);
         }
         /* Access Token을 이용하여 네이버 사용자 프로필 API를 호출 */
         public String getUserProfile(OAuth2AccessToken oauthToken) throws IOException {
             OAuth20Service oauthService = new ServiceBuilder()
                 .apiKey(CLIENT_ID)
                 .apiSecret(CLIENT_SECRET)
                 .callback(REDIRECT_URI).build(NaverSigninApi.instance());
             OAuthRequest request = new OAuthRequest(Verb.GET, PROFILE_API_URL, oauthService);
             oauthService.signRequest(oauthToken, request);
             Response response = request.send();
             return response.getBody();
         }
        }
        ```

    5.  java/com/example/oauth/sign/SignController.java
        ```java
        package com.example.oauth.sign;

        import java.io.IOException;
        import javax.servlet.http.HttpSession;
        import org.json.simple.JSONObject;
        import org.json.simple.parser.JSONParser;
        import org.json.simple.parser.ParseException;
        import org.springframework.beans.factory.annotation.Autowired;
        import org.springframework.stereotype.Controller;
        import org.springframework.ui.Model;
        import org.springframework.web.bind.annotation.RequestMapping;
        import org.springframework.web.bind.annotation.RequestMethod;
        import org.springframework.web.bind.annotation.RequestParam;
        import com.github.scribejava.core.model.OAuth2AccessToken;

        import com.example.oauth.config.NaverSigninBO;

        /**
        * Handles requests for the application home page.
        */
        @Controller
        public class SigninController {

         @Autowired
         private NaverSigninBO naverSigninBO;
         private String apiResult = null;

         //로그인 첫 화면 요청 메소드
         @RequestMapping(value = "/oauth/signin", method = {
             RequestMethod.GET,
             RequestMethod.POST
         })
         public String signin(Model model, HttpSession session) {
             /* 네이버아이디로 인증 URL을 생성하기 위하여 naverSigninBO클래스의 getAuthorizationUrl메소드 호출 */
             String naverAuthUrl = naverSigninBO.getAuthorizationUrl(session);
             //https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=sE***************&
             //redirect_uri=http%3A%2F%2F211.63.89.90%3A8090%2Fsignin_project%2Fcallback&state=e68c269c-5ba9-4c31-85da-54c16c658125
             System.out.println("네이버:" + naverAuthUrl);
             //네이버
             model.addAttribute("url", naverAuthUrl);
             return "signin";
         }
         //네이버 로그인 성공시 callback호출 메소드
         @RequestMapping(value = "/oauth/naver/callback", method = {
             RequestMethod.GET,
             RequestMethod.POST
         })
         public String callback(Model model, @RequestParam String code, @RequestParam String state, HttpSession session) throws IOException, ParseException {
             System.out.println("여기는 callback");
             OAuth2AccessToken oauthToken;
             oauthToken = naverSigninBO.getAccessToken(session, code, state);
             System.out.println("oauthToken : " + oauthToken);
             //1. 로그인 사용자 정보를 읽어온다.
             apiResult = naverSigninBO.getUserProfile(oauthToken); //String형식의 json데이터
             System.out.println("apiResult : " + apiResult);
             /** apiResult json 구조
             {"resultcode":"00",
             "message":"success",
             "response":{"id":"33666449","nickname":"shinn****","age":"20-29","gender":"M","email":"sh@naver.com","name":"\uc2e0\ubc94\ud638"}}
             **/
             //2. String형식인 apiResult를 json형태로 바꿈
             JSONParser parser = new JSONParser();
             Object obj = parser.parse(apiResult);
             JSONObject jsonObj = (JSONObject) obj;
             //3. 데이터 파싱
             //Top레벨 단계 _response 파싱
             JSONObject response_obj = (JSONObject) jsonObj.get("response");
             //response의 nickname값 파싱
             String nickname = (String) response_obj.get("nickname");
             System.out.println(nickname);
             //4.파싱 닉네임 세션으로 저장
             session.setAttribute("sessionId", nickname); //세션 생성
             model.addAttribute("result", apiResult);
             return "signin";
         }
         //로그아웃
         @RequestMapping(value = "/oauth/logout", method = {
             RequestMethod.GET,
             RequestMethod.POST
         })
         public String logout(HttpSession session) throws IOException {
             System.out.println("여기는 logout");
             session.invalidate();
             return "redirect:/";
         }
        }
        ```

    6.  webapp/WEB-INF/views/index.jsp
        ```jsp
        <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
        <html>

        <head>
         <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
         <title>NAVER LOGIN TEST</title>
        </head>

        <body>
         <h1>메인 페이지 입니다.</h1>
         <hr>
         <br>
         <a href="/oauth/signin">로그인 하러 가기 </a>
         <hr>
        </body>

        </html>
        ```

    7.  webapp/WEB-INF/views/signin.jsp
        ```jsp
        <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
        <html>

        <head>
         <title>NAVER LOGIN TEST</title>
        </head>

        <body>
         <h1>Login Form</h1>
         <hr>
         <br>
         <center>
             <c:choose>
                 <c:when test="${sessionId != null}">
                     <h2> 네이버 아이디 로그인 성공하셨습니다!! </h2>
                     <h3>'${sessionId}' 님 환영합니다! </h3>
                     <h3><a href="/oauth/logout">로그아웃</a></h3>
                 </c:when>
                 <c:otherwise>
                     <form action="login.userdo" method="post" name="frm" style="width:470px;">
                         <h2>로그인</h2>
                         <input type="text" name="id" id="id" class="w3-input w3-border" placeholder="아이디" value="${id}">
                         <br>
                         <input type="password" id="pwd" name="pwd" class="w3-input w3-border" placeholder="비밀번호"> <br>
                         <input type="submit" value="로그인" onclick="#"> <br>
                     </form>
                     <br>
                     <!-- 네이버 로그인 창으로 이동 -->
                     <div id="naver_id_login" style="text-align:center"><a href="${url}">
                             <img width="223"
                                 src="https://developers.naver.com/doc/review_201802/CK_bEFnWMeEBjXpQ5o8N_20180202_7aot50.png" /></a>
                     </div>
                     <br>
                 </c:otherwise>
             </c:choose>
         </center>
        </body>

        </html>
        ```

    8.  application.properties
        ```
        server.port=8080

        spring.mvc.view.prefix=/WEB-INF/views/
        spring.mvc.view.suffix=.jsp
        ```

> [https://developers.naver.com/main/](https://developers.naver.com/main/)  
> [https://bumcrush.tistory.com/151](https://bumcrush.tistory.com/151)  
> [https://4urdev.tistory.com/47](https://4urdev.tistory.com/47)

```toc

```
