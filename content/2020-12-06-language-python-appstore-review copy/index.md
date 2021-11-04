---
title: '[Python] app store review parsing'
date: 2020-12-06 08:05:34
author: TMM
categories: Language
tags: Python app store
---

google play store는 개발자 키파일이 있어야 리뷰 조회가 가능하지만<br />
app store 는 RSS 방식으로 제공을 해줍니다.<br />
json과 xml 방식을 제공하는데 xml 방식에서 입력 및 수정날짜를 얻을 수 있어 xml을 선택할 수밖게 없습니다.
ip 차단 조건은 다음에 확인해보도록 하겠습니다.<br />

## rss

### url

- https://itunes.apple.com/kr/rss/customerreviews/page=1/id=909319292/sortby=mostrecent/xml?urlDesc=/customerreviews/id=1037778235/sortBy=mostRecent/xml

### param

- id: app store의 app id 입니다.
- page: 1-10까지 선택가능하면 페이지당 50개씩 노출되기 때문에 최대 500개까지 조회가 가능합니다.

### id 확인 방법

- app store에서 app을 검색하면 url이 나오는데 그중 id 부분의 정보입니다.
- https://apps.apple.com/us/app/google-calendar-get-organized/id`909319292`

## xml parsing

### xmltodict 설치

```bash
pip install xmltodict
```

### 테스트

```python
from urllib.request import urlopen
import xmltodict
import json

url = "https://itunes.apple.com/kr/rss/customerreviews/page=1/id=909319292/sortby=mostrecent/xml?urlDesc=/customerreviews/id=1037778235/sortBy=mostRecent/xml"
response = urlopen(url).read()

app_store_review_dick = xmltodict.parse(response)
app_store_review_json = json.loads(json.dumps(app_store_review_dick))

print(len(app_store_review_json['feed']['entry']))
```

## 참고

- https://signing.tistory.com/51

```toc

```
