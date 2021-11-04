---
title: '[작성중][VSCode] Frontend 개발을 위한 확장 프로그램'
date: 2020-07-13 08:05:34
author: TMM
categories: Tool
tags: vscode
---

Vue로 개발하는데 저장만 눌러도 포맷을 맞춰주는 기능이 있다고해서 적용했습니다.
Vue 파일은 JS 파일과 포맷이 조금 다른 부분도 있고해서 팀원들간에 소스 정형화에 도움이 될거 같습니다.

## 목표

- Perttier 설치 및 설정
- ESlint 설치

## Prettier

### 설치

- VSCode Extensions 메뉴에서 "Prettier - Code formatter" 를 검색 해서 설치합니다.

### 설정

- 설정 화면으로 이동해서 UI로 설정이 가능하지만 settings.json 파일을 열어 한번에 입력합니다.

```json
"editor.formatOnSave": true,
"editor.formatOnType": true,
"prettier.tabWidth": 4,
"prettier.printWidth": 160,
"prettier.singleQuote": true,
"prettier.semi": false
```

## Eslint 설치

## 참고사이트

```yaml
site:
  prettier options: https://ux.stories.pe.kr/150
```

```toc

```
