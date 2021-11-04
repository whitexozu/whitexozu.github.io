---
title: '[Python] window10에 KoNLPy 설치 및 테스트'
date: 2020-12-05 08:05:34
author: TMM
categories: Language
tags: Python konlpy
---

window10에서 토큰화를 위해 KoNLPy를 설치했습니다.<br />
mecab은 설치 실패 했습니다.<br />

## 설치

### JPype1 설치

1. https://www.lfd.uci.edu/~gohlke/pythonlibs/#jpype
1. 운영체제 bit와 파이썬 버전에 맞는 whl 파일을 다운 받습니다.
   - 저는 파이썬 3.5, 64bit 이기 때문에 `JPype1‑0.7.1‑cp35‑cp35m‑win_amd64.whl` 를 받았습나다.
1. whl 파일 설치
   ```bash
   $ pip install JPype1‑0.7.1‑cp35‑cp35m‑win_amd64.whl
   ```

### koNLPy 설치

```bash
$ pip install konlpy
```

## 테스트

### jupyter 실행

```bash
$ jupyter notebook
```

### KoNLPy 실행

```python

import re
from konlpy.tag import Hannanum
from konlpy.tag import Kkma
from konlpy.tag import Komoran
from konlpy.tag import Okt
from konlpy.tag import Twitter

hannanum = Hannanum()
kkma = Kkma()
komoran =Komoran()
okt = Okt()
twitter = Twitter()

titleList = [
    '❤ 💜  테스트 데이터 💚 💛 이모지 포함 \U0001f970',
    'ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ',
    '이미지 이름.jpg',
    '💙🎁 공유가능 💙🎁 문의👌',
    '●▅▇█▇▆▅▄산 모양의 텍스트'
    ]


emoji_pattern = re.compile('[\U00010000-\U0010ffff]', flags=re.UNICODE)

for v in titleList:

    # kkma, kororan의 경우 이모지 입력시 오류가 발생해 이모지 필터 처리
    v = re.sub(emoji_pattern, '', v)

    print(' title: {}'.format(v))
    print('''
        hannanum: {}
        kkma: {}
        komoran: {}
        okt: {}
        ''' .format(
            hannanum.pos(v),
            kkma.pos(v),
            komoran.pos(v),
            okt.pos(v))
    )

```

## 참고

- https://webnautes.tistory.com/1394
- https://cleancode-ws.tistory.com/97

```toc

```
