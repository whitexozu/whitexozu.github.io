---
title: '[google apps script] 사용 방법 조사'
date: 2020-05-11 08:05:34
author: TMM
categories: OpenAPI
tags:
  - Google Apps Script
---

google spreadsheet가 수정되면 자동 알림 기능을 개발해야 합니다. apps script를 등록하면 바로바로 알람을 받을 수 있다고 해서 신기해서 찾아보기로 했습니다.

## 목표

- 지정 열/행을 기준으로 수정시 전체 데이터 확인
- 지정 열/행을 기준으로 수정시 수정된 데이터만 확인
- REST API 전달

## 스크립트 작성

### 함수 생성

1. _spreadsheet > 도구 > 스크립트 편집기_ 편집 화면으로 이동합니다.
1. 초기 화면입니다.

```javascript
function myFunction() {}
```

1. push 함수를 추가합니다.

```javascript
function push() {}
```

### 트리거 추가

- _스크립트 편집기 > 수정 > 모든 트리거 보기_ 설정 화면으로 이동합니다. 발생 주기와 발생 함수를 선택합니다.
- 발생 주기: 수정시, 발생 함수: push
- 이벤트 유형 선택
  - 열릴 시: 파일이 열린 경우
  - 수정 시: 데이터가 수정된 경우
  - 변경 시: 데이터가 수정된 경우
  - 양식 제출 시: 설문지 전달 후 설문 내용을 제출한 경우 발생

### 수정된 내용 확인

1. 스크립트 편집 화면으로 이동합니다.
1. push 함수를 수정해 범위 지정 후 수정된 부분을 확인 할 수 있도록 작성해 보겠습니다. ECMA6 문법으로 작성합니다.

```javascript
function push() {
  var sheet_name = 'apps_script_test_sheet';
  var range_value = 'B5:E15';
  var start_row_index, start_column_index, end_row_index, end_column_index;

  // 활성화 된 sheet name을 구합니다.
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sheet = ss.getActiveSheet();
  Logger.log('activate sheet name: ', sheet.getSheetName());

  // sheet name을 비교합니다.
  // 비교하지 않으면 모든 sheet의 range 데이터를 출력합니다.
  if (sheet != null && sheet.getSheetName() == sheet_name) {
    // get update range index
    var range = sheet.getRange(range_value);
    Logger.log('range: ', range.getA1Notation());

    // range 값을 사용자 편의상 알파벳과 숫자로 입력했지만 비교는 index값으로 해야하기 때문에 index값으로 변환을 해줍니다.
    start_column_index = range.getColumn();
    start_row_index = range.getRow();
    end_column_index = start_column_index + range.getValues()[0].length - 1;
    end_row_index = start_row_index + range.getValues().length - 1;

    // 입력한 cell의 정보를 구합니다.
    var ac = sheet.getActiveCell();
    Logger.log(ac.getColumn(), ac.getRow());

    // range index와 수정한 cell정보를 비교합니다.
    if (
      ac.getRow() >= start_row_index &&
      ac.getRow() <= end_row_index &&
      ac.getColumn() >= start_column_index &&
      ac.getColumn() <= end_column_index
    ) {
      // get update data
      Logger.log('>>>>', ac.getValue());
      // get range datas
      Logger.log('>>>>', range.getValues());
    } else {
      Logger.log('>>>>not in range');
    }
  } else {
    Logger.log('other the sheet');
  }
}
```

### Logger 확인

- Browser.msgBox로 alert과 비슷한 방식으로 로그를 찍을 수 있습니다. 그러나 여러 줄을 한번에 찍고 로그 관리를 할 수 있는 Logger class를 사용 합니다.
- 편집화면에 log 추가
  ```javascript
  Logger.log('log message');
  ```
- _스크립트 편집기 > 보기 > Stackdriver 로깅_ 로깅 확인 화면으로 이동 하여 로그 목록을 확인 합니다.

### REST API Call

- UrlFetchApp class를 활용합니다.

  ```javascript
  // get method api request
  var baseUrl = 'http://[ip]:8081/feed/?feedId=3';
  UrlFetchApp.fetch(baseUrl);

  // post method api request
  var baseUrl = 'http://[ip]:8081/feed/?feedId=2';
  var parameters = {
    arg1: 'a1',
    arg2: sheet.getRange('A3:D7').getDisplayValues(),
  };
  var options = {
    method: 'POST',
    payload: parameters,
  };
  UrlFetchApp.fetch(baseUrl, options);
  ```

## 참고사이트

```yaml
site: https://developers.google.com/apps-script
```

```toc

```
