---
title: '[Python] Mac tesseract 설치 및 실행'
date: 2020-03-26 08:05:34
author: TMM
categories: language
tags: Python tesseract
---

이미지를 택스트로 변경 할 수 있는 테슬렉트를 설치후 실행해 보겠습니다.

## 환경

```
OS : MacOS Catalina 10.15.3
Tesseract : 4.1.1
Python: 3.5
pytesseract: 0.3.3
```

## 설치

### tesseract 설치

- 테서렉트를 활용하기 위해서는 테서렉트 먼저 설치해야합니다. <br />
  homebrew를 통해서 설치가 가능하며 파이선은 pip를 통해서 pytesseract를 설치하면 설치된 테서렉트를 랩핑하여 사용하는 방식입니다.

      ```bash
      $ brew install tesseract

      $ brew install tesseract-lang

      $ tesseract --version
      tesseract 4.1.1
      leptonica-1.79.0
      libgif 5.2.1 : libjpeg 9d : libpng 1.6.37 : libtiff 4.1.0 : zlib 1.2.11 : libwebp 1.1.0 : libopenjp2 2.3.1
      Found AVX2
      Found AVX
      Found FMA
      Found SSE

      $ pip install pytesseract

      $ pip show pytesseract
      Name: pytesseract
      Version: 0.3.3
      Summary: Python-tesseract is a python wrapper for Google\'s Tesseract-OCR
      Home-page: https://github.com/madmaze/pytesseract
      Author: Samuel Hoffstaetter
      Author-email: samuel@hoffstaetter.com
      License: Apache License 2.0
      Location: /Users/whitexozu/opt/anaconda3/envs/py35/lib/python3.5/site-packages
      Requires: Pillow
      ```

### tessdata 다운로드

- `https://github.com/tesseract-ocr/tessdata`에서 tessdata를 다운받은후 `/usr/local/Cellar/tesseract/4.1.1/share/tessdata`에 kor.tessdata를 복사합니다.

**Note:**<br />
tesseract 4.1.1을 설치했는데 trainedata를 기본 경로가<br />
*/usr/local/Cellar/tesseract-lang/4.0.0/share/tessdata*를 바라보고 있습니다.<br />
그리고 당연하게 파일을 못 읽는다는 오류가 납니다. 오류 메시지는 아래과 같습니다.<br />
<br />
`"Error: Tesseract (legacy) engine requested, but components are not present in /usr/local/share/tessdata/kor.traineddata!! Failed loading language 'kor' Tesseract couldn't load any languages! Could not initialize tesseract."`<br />
<br />
_tessdata 다운로드_ 를 참고하여 파일을 받았다면 경로를 변경하면 됩니다. 경로를 설정하는 방법은 두가지가 있습니다. 첫번째는 `--tessdata-dir` 옵션을 사용하는 것이고 두번째는 `.bash_profile` 또는 `.zprofile`에 경로 정보를 export 하면 됩니다.<br />
export TESSDATA_PREFIX="/usr/local/Cellar/tesseract/4.1.1/share/tessdata"
{: .notice--info}

## 실행

두가지 방식으로 실행이 가능합니다.

### 명렁어 입력 실행

- 설치된 텍서렉트에 명령어를 직접 입력하여 실행하는 방식

  ```bash
  $ tesseract ~/Pictures/text_image/itemText.png stdout -l kor --oem 1 --psm 3
  ```

### pytesseract 실행

- python 에서 실행

  ```python
  import cv2
  import sys
  import pytesseract

  if __name__ == '__main__':

  imPath = 'itemText.png'

  config = ('-l eng --oem 1 --psm 3')

  # Read image from disk
  im = cv2.imread(imPath, cv2.IMREAD_COLOR)

  # Run tesseract OCR on image
  text = pytesseract.image_to_string(im, config=config)

  # Print recognized text
  print(text)
  ```

  ```bash
  $ python tesseract_test.py
  ```

## 옵션 설명

- `-stdout / output` : 화면 출력, 파일 출력
- `-L` : 언어 선택
- `--oem` : OCR Engine Mode
  - 0: Legacy engine only.
  - 1: Neural nets LSTM engine only.
  - 2: Legacy + LSTM engines.
  - 3: Default, based on what is available.
- `--psm` : PSM은 텍스트 구조에 대한 추가 정보 선택
- `--tessdata-dir` : tessdata file path 지정

## 참고 사이트

```yaml
https://github.com/tesseract-ocr/tessdata
https://tariat.tistory.com/703
https://m.blog.naver.com/tommybee/221307497468
```

```toc

```
