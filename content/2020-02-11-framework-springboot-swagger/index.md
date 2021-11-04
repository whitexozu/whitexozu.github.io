---
title: '[Swagger] Springboot + swagger'
date: 2020-02-11 08:05:34
author: TMM
categories: Framework
tags: swagger Springboot
---

스웨거 참 좋은것 같습니다.

## maven dependency 추가

```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.9.2</version>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.9.2</version>
</dependency>
```

## javacofnig 생성

- /src/main/java/com/example/swagger/config/SwaggerConfig.java

```java
package com.example.swagger.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
public class SwaggerConfig {

    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2)
            .select()
            .apis(RequestHandlerSelectors.any())
            // .apis(RequestHandlerSelectors.basePackage("java.com.example.swagger.controller"))
            .paths(PathSelectors.any())
            .build();
    }
}
```

## test controller 생성

- /src/main/java/com/example/swagger/controller/BoardController.java

```java
package com.example.swagger.controller;

import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.HashMap;
import java.util.List;

@RestController
@RequestMapping("/api")
public class BoardController {

    @ApiOperation(value = "전체 게시판 조회")
    @RequestMapping(value = "/board", method = RequestMethod.GET)
    public Map < String, Object > selectListBoard() {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("key", "value 1234");
        return result;
    }

    @ApiOperation(value = "해당 게시판 조회")
    @ApiImplicitParams({
        @ApiImplicitParam(name = "id", value = "게시판 고유키", required = true, dataType = "string", paramType = "path", defaultValue = ""),
    })
    @RequestMapping(value = "/board/{id}", method = RequestMethod.GET)
    public Map < String, Object > selectOneBoard(@PathVariable("id") Integer id) {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("id", id);
        return result;
    }

}
```

## 확인

[http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)

## annotation 설명

- @Api : 컨트롤러에 설명을 추가
- @ApiOperation : API에 설명을 추가
- @ApiParam : API의 파라미터에 설명을 추가
- @ApiModel : 모델에 설명을 추가
- @ApiModelProperty : 모델의 요소에 설명을 추가

```toc

```
