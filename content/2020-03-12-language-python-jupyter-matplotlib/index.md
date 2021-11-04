---
title: '[Python] Jupyter matplotlib로 내/외부 이미지 그리기 설정'
date: 2020-03-12 08:05:34
author: TMM
categories: Language
tags: Python Jupyter Matplotlib anaconda
---

Jupyter에서 Matplotlib를 활용하여 차트나 이미지를 그리는 경우가 있습니다.<br />
이때 외부, 내부 이미지, 내부 대화식 을 선택 할 수 있습니다.

## 명령어

```yaml
- %matplotlib tk: 또는 %matplotlib qt 지정된 대화식 백엔드가있는 노트북 외부에 그림을 보여줍니다.
- %matplotlib inline: 정적 png 이미지로 내부에 표시됩니다.
- %matplotlib notebook: 또는 %matplotlib nbagg는 노트북 내부의 대화식 그림을 보여줍니다.
- %matplotlib widgets: 노트북 내부의 대화 형 그림을 보여줍니다. ( jupyter-matplotlib 을 설치해야 함)
```

## 예제 소스

```python
# %matplotlib inline
%matplotlib notebook
# %matplotlib qt5

import cv2
import numpy as np
import matplotlib.pyplot as plt
import pytesseract
plt.style.use('dark_background')

img_ori = cv2.imread('1.jpg')

height, width, channel = img_ori.shape

plt.figure(figsize=(12, 10))
plt.imshow(img_ori, cmap='gray')
```

## 추가 내용

### MacOS Catalina anaconda 설치

- MacOS Catalina 로 업데이트를 했더니 기존 아나콘다가 너무 느려저서 재설치를 했습니다.
- 삭제는 anaconda nevgation application 삭제 후 ~/anaconda, ~/.conda 폴더를 삭제 하고 export 설정을 삭제 하였습니다.
- 설치 방법은 dmg파일을 다운받아서 다음다음 하면 됩니다. 별도의 export 설정은 하지 않았습니다.

> https://www.anaconda.com/how-to-restore-anaconda-after-macos-catalina-update/

### jupyter 설치

```bash
$ pip install jupyter
```

### jupyter 실행

```bash
$ jupyter notebook
```

```toc

```
