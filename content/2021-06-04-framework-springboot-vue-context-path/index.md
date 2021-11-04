---
title: '[context-path] springboot + swagger2 + vue context-path 적용'
date: 2020-06-04 08:05:34
categories: Framework
tags: Springboot Vue
---

서버 한대에 한개의 Nginx와 두개의 톰켓 서버를 뛰워야 할 일이 생겼습니다.<br />
맞는 방법인지는 모르나 일단 잘 돌아가는건 확인해서 나중에 같은 작업을 할때 참고하기 위해 작성하겠습니다.

## frontend

### .env

```js
# prod path
VUE_APP_PROD_PATH=/[project_name]
```

### api/index.js

```js
...
const service = axios.create({
    baseURL: process.env.VUE_APP_PROD_PATH
})
...
```

### vue.config.js

```js
module.exports = {
	...
    publicPath: process.env.VUE_APP_PROD_PATH
	...
}
```

## backend

### applicatioln.yml

```yml
server:
  port: 8080
  servlet:
    context-path: /[project_name]
```

### OpenApiconfig.java (swagger config file)

```java
...
public Docket api() {

    ...
    String host = "[project_name]";

    return new Docket(DocumentationType.SWAGGER_2)
        .host(host)
        .useDefaultResponseMessages(false).apiInfo(apiInfo()).select()
        .apis(RequestHandlerSelectors.any()).paths(PathSelectors.any())
        .apis(Predicates.not(RequestHandlerSelectors.basePackage("org.springframework.boot")))
        .build();
    ...
}
...
```

### CommonSession.java

```java
public boolean passUri(String requestURI) {

    boolean passUriFlag = false;

    if (requestURI.indexOf("/theme/") == 0
            || requestURI.indexOf("/[project_name]/css/") == 0
            || requestURI.indexOf("/[project_name]/img/") == 0
            || requestURI.indexOf("/[project_name]/js/") == 0
            || requestURI.indexOf("/[project_name]/favicon.ico") == 0
            || requestURI.indexOf("/[project_name]/logout") == 0
            || requestURI.equals("/[project_name]/index.html/")) {

        passUriFlag = true;
    }
    return passUriFlag;
}
```

```toc

```
