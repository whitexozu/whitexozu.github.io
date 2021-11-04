---
title: '[google sheets api] get, update, replace 사용 방법 조사'
date: 2020-05-07 08:05:34
author: TMM
categories: OpenAPI
tags: Google Sheets API
---

자동화를 지향하다보니 chatbot에게 요청을 통해 정보 조회, 외부 API연동 등을 하고 싶어하는 사용자가 생겼습니다. 유행이될지 혁신이 된지 사용해봐야 알거 같습니다.<br />
이번 포스팅에서는 google spreadsheet api를 여러 방법으로 활용해 보겠습니다.

## 목표

1. 지정 열/행을 기준으로 키워드 검색 후 해당 키워드가 몇개가 있는지 카운트 후 결과 값 출력
1. 지정 열/행을 기준으로 키워드 검색 후 해당 키워드가 있는 행/열의 지정 위치의 값을 입력받은 값으로 변경

## 개발 환경

- Python 3.5

## oauth2

- [console developers](https://console.developers.google.com/projectselector/permissions/serviceaccounts)에 접속후 [참고사이트](http://hleecaster.com/python-google-drive-spreadsheet-api/)를 참고하여 `사용자 인증 정보 > 서비스 계정 관리`에서 `서비스 계정 생성`하여 json 파일을 다운 받습니다.

## 파일 권한 주기

- 생성된 서비스 계정의 이메일 주소를 공유할 Spreadsheet의 공유 계정에 추가합니다.

## 개발

### requirements.txt

```python
google-api-python-client==1.7.9
google-auth-httplib2==0.0.3
google-auth-oauthlib==0.4.0
oauth2client==4.1.3
```

### get.py

```python
from __future__ import print_function
import pickle
import os.path
from httplib2 import Http
from googleapiclient.discovery import build
from google.auth.transport.requests import Request
from oauth2client.service_account import ServiceAccountCredentials

scope = ['https://www.googleapis.com/auth/spreadsheets']
credentials = 'application_credentials.json'  # 서비스 생성 계정으로 다운받은 json 파일

spreadsheet_id = '1ZrF6mT4EWwCgWL0JpLjitA7rmO3tb9LqnXDcPw3Wuo8' # spread sheet id
range_name = 'class data!A3:E7' # sheet name, range
search_keyword = 'Female' # search keyword

def main():
    creds = None

    # Create credentials
    creds = ServiceAccountCredentials.from_json_keyfile_name(credentials, scope)
    http_auth = creds.authorize(Http())
    service = build('sheets', 'v4', http=http_auth)

    # Call get
    result = service.spreadsheets().values().get(
        spreadsheetId=spreadsheet_id,
        range=range_name).execute()
    rows = result.get('values', [])
    print(rows)
    print('{0} rows retrieved.'.format(len(rows)))

    cnt = 0
    for ri, row in enumerate(rows):
        for ci, col in enumerate(row):
            if (col == search_keyword):
                print('{}, {}, {}'.format(ri, ci, col))
                cnt = cnt + 1
    print('cnt: {}'.format(cnt))

if __name__ == '__main__':
    main()
```

### batch_get.py

```python
from __future__ import print_function
import pickle
import os.path
from httplib2 import Http
from googleapiclient.discovery import build
from google.auth.transport.requests import Request
from oauth2client.service_account import ServiceAccountCredentials

scope = ['https://www.googleapis.com/auth/spreadsheets']
credentials = 'application_credentials.json'

spreadsheet_id = '1ZrF6mT4EWwCgWL0JpLjitA7rmO3tb9LqnXDcPw3Wuo8'
range_name = 'class data!A3:E7'
search_keyword = 'Female'

def main():
    creds = None

    # Create credentials
    creds = ServiceAccountCredentials.from_json_keyfile_name(credentials, scope)
    http_auth = creds.authorize(Http())
    service = build('sheets', 'v4', http=http_auth)

    # Call batch get
    result = service.spreadsheets().values().batchGet(
        spreadsheetId=spreadsheet_id, ranges=range_name).execute()
    ranges = result.get('valueRanges', [])
    print(ranges)
    print('{0} ranges retrieved.'.format(len(ranges)))

if __name__ == '__main__':
    main()
```

### update.py

```python
from __future__ import print_function
import pickle
import os.path
from httplib2 import Http
from googleapiclient.discovery import build
from google.auth.transport.requests import Request
from oauth2client.service_account import ServiceAccountCredentials

scope = ['https://www.googleapis.com/auth/spreadsheets']
credentials = 'application_credentials.json'

spreadsheet_id = '1ZrF6mT4EWwCgWL0JpLjitA7rmO3tb9LqnXDcPw3Wuo8'
range_name = 'class data!B7'

def main():
    creds = None

    # Create credentials
    creds = ServiceAccountCredentials.from_json_keyfile_name(credentials, scope)
    http_auth = creds.authorize(Http())
    service = build('sheets', 'v4', http=http_auth)

    sheet = service.spreadsheets()

    # Call values
    result = sheet.values().get(spreadsheetId=spreadsheet_id,
        range=range_name).execute()
    values = result.get('values', [])
    print(values)


    # Call update
    value_input_option = 'USER_ENTERED'
    body = {
        'values': [['Female']]
    }
    result = sheet.values().update(
        spreadsheetId=spreadsheet_id,
        range=range_name,
        valueInputOption=value_input_option,
        body=body).execute()

    print(result)
    print('{0} cells updated.'.format(result.get('updatedCells')))


if __name__ == '__main__':
    main()
```

### replace.py

```python
from __future__ import print_function
import pickle
import os.path
from httplib2 import Http
from googleapiclient.discovery import build
from google.auth.transport.requests import Request
from oauth2client.service_account import ServiceAccountCredentials

scope = ['https://www.googleapis.com/auth/spreadsheets']
credentials = 'application_credentials.json'

spreadsheet_id = '1ZrF6mT4EWwCgWL0JpLjitA7rmO3tb9LqnXDcPw3Wuo8'
range_name = 'class data!B7'

title = 'sheet api test'
find = 'hi123'
replacement = 'hi1234'

range_name = {
  "sheetId": 0,
  "startRowIndex": 9,
  "endRowIndex": 20,
  "startColumnIndex": 6,
  "endColumnIndex": 7
}
def main():
    creds = None

    # Create credentials
    creds = ServiceAccountCredentials.from_json_keyfile_name(credentials, scope)
    http_auth = creds.authorize(Http())
    service = build('sheets', 'v4', http=http_auth)

    requests = []
    # Change the spreadsheet's title.
    requests.append({
        'updateSpreadsheetProperties': {
            'properties': {
                'title': title
            },
            'fields': 'title'
        }
    })
    # Find and replace text
    requests.append({
        'findReplace': {
            'find': find,
            'replacement': replacement,
            'range': range_name
            # 'allSheets': True
        }
    })
    # Add additional requests (operations) ...

    body = {
        'requests': requests
    }

    # Call batchUpdate for replace
    response = service.spreadsheets().batchUpdate(
        spreadsheetId=spreadsheet_id,
        body=body).execute()
    find_replace_response = response.get('replies')[1].get('findReplace')

    print(find_replace_response)
    print('{0} replacements made.'.format(
        find_replace_response.get('occurrencesChanged')))


if __name__ == '__main__':
    main()
```

### value input option

- RAW: 사용자가 입력 한 값은 구문 분석되지 않으며 그대로 저장됩니다.
- USER_ENTERED: 사용자가 UI에 입력 한 것처럼 값이 구문 분석됩니다. 숫자는 숫자로 유지되지만 Google 스프레드 시트 UI를 통해 셀에 텍스트를 입력 할 때 적용되는 것과 동일한 규칙에 따라 문자열이 숫자, 날짜 등으로 변환 될 수 있습니다.

## 결론

- 예제 소스가 직관적이여서 따로 설명도 필요 없어 보입니다.
- 검색 키워드와 일치하는 데이터 위치를 자세하게 알려주는 API는 없어 보이네요. Range 시작점과 검색 결과의 배열 Index 정보를 어찌어찌 해서 해결 하겠습니다.

## 참고사이트

```yaml
Google Sheet API v4: https://developers.google.com/sheets/api/guides/concepts
Python3.5 구글 드라이브/스프레드시트 API 활용: http://hleecaster.com/python-google-drive-spreadsheet-api/
OAuth2: https://yuda.dev/267
```

```toc

```
