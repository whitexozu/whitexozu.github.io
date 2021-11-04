---
title: '[Python] 이미지를 판단 후 자동 실행하는 메크로'
date: 2020-03-26 08:05:34
author: TMM
categories: language
tags: Python Macro
---

사내메신저로 MS Temas를 쓰는데 모든 채팅방을 공유하라는 지시가 내려왔습니다.<br />
윗분 칭찬한 내용들이 많은데 보여드리면 어색해 질까봐 다 지우려고 합니다.<br />
팀즈는 방파 기능이 없는거 같아 채팅 내용을 하나하나 지우는 메크로를 만들었습니다.<br />
<br />
순서는 간단합니다.<br />

## 순서

1. 커서를 이동시켜 본인 채팅내용 찾기
1. 채팅내용에 마우스 오버시 나오는 옵션 버튼 클릭
1. 옵션 버튼 클릭시 생기는 삭제 버튼 클릭

## 환경

```yaml
OS: MacOS Catalina 10.15.3
Python: 3.5
pyautogui: 0.9.48
mss: 5.0.0
cv2: 4.1.1.26
pyobjc-framework-Quartz: 5.3
numpy: 1.18.1
```

## 설치

### pyaotugui 설치

```bash
$ pip install pyaotugui
```

### pyobjc-framework-Quartz 설치

```bash
$ pip install pyobjc-framework-Quartz
```

### 스크린샷 패키지 mss 설치

```bash
$ pip install mss
```

### opencv-python 설치

```bash
$ pip install opencv-python==4.1.1.26
```

### numpy

```bash
$ pip install numpuy
```

## 주요 기능

### 마우스 이동 및 클릭, 스크롤

```python
# position 확인
x, y = pag.position()
position_str = 'X : ' + str(x) + ' Y : ' + str(y)
print(position_str)
# 이동
pag.moveTo(100, 200)
# 클릭
pag.mouseDown()
pag.mouseUp()
# 스크롤
pag.scroll(17)
```

- 직관적인 내용들 입니다. 아쉬운 부분은 스크롤을 미세하게 할 수 없습니다. 보다 다양한 기능은 참고사이트를 확인 바랍니다.

### 이미지 캡처 후 출력

```python
with mss.mss() as sct:
    point_button_img_pos = {'left': 100, 'top': 100, 'width': 15, 'height': 15}
    point_button_img = np.array(sct.grab(point_button_img_pos))[:,:,:3]
    cv2.imshow('point_button_img', point_button_img)
    cv2.waitKey(0)
```

- 포지션 정보의 이미지를 캡처하고 cv2를 이용하여 윈도우 창으로 출력합니다. 버튼의 위치를 찾는데 사용합니다.

### 캡처된 이미지 RGB값 확인

```python
mean = np.mean(img, axis=(0, 1))

print('delete mean[0]: ' + str(mean[0]))
print('delete mean[1]: ' + str(mean[1]))
print('delete mean[2]: ' + str(mean[2]))
```

- 이미지를 캡처해도 이미지를 비교 할 수 없죠. 그래서 이미지의 평균 RGB값을 이용해서 비슷한 값이면 같은 이미지라고 판단합니다.
- 어쩌다 색감이 비슷한 영역을 캡처 하게되면 버튼이 아닌데 버튼으로 인식할 수도 있는 오류가 많이 발생되는 부분이기도 합니다.
- 태마가 바뀌면 값을 모두 다시 세팅해 줘야 하는 문제도 생길수 있겠네요.

## 전체 소스

제 소스보단 참고 사이트의 *빵형의 개발도상국 - 집행검키우기*의 유투브 시청을 추천 드립니다.

```python
import pyautogui as pag
import mss, cv2
import numpy as np
import time

# delay after click
pag.PAUSE = 0.08
coord_mouse = 13
wait_time = 0.2

# icon position
point_init = {'left': 657, 'top': 928}
point_top = {'top': 200}
chat_purple = {'left': 640, 'top': 920}
point_button = {'left': -23, 'top': -60, 'width': 22, 'height': 26}
up_delete_button = {'left': -103, 'top': -176, 'width': 15, 'height': 15}
down_delete_button = {'left': -103, 'top': 94, 'width': 15, 'height': 15}


def compute_point_icon_type(img):
    mean = np.mean(img, axis=(0, 1))

    # print('point mean[0]: ' + str(mean[0]))
    # print('point mean[1]: ' + str(mean[1]))
    # print('point mean[2]: ' + str(mean[2]))

    if mean[0] > 244 and mean[0] < 250 and mean[1] > 244 and mean[1] < 250 and mean[2] > 244 and mean[2] < 250:
        result = 'ICON'
    else:
        result = 'OTHER'

    return result

def compute_delete_icon_type(img):
    mean = np.mean(img, axis=(0, 1))

    print('delete mean[0]: ' + str(mean[0]))
    print('delete mean[1]: ' + str(mean[1]))
    print('delete mean[2]: ' + str(mean[2]))

    if mean[0] > 209 and mean[0] < 211 and mean[1] > 209 and mean[1] < 211 and mean[2] > 210 and mean[2] < 212:
        result = 'ICON'
    else:
        result = 'OTHER'

    return result

def click(coords):
    pag.moveTo(x=coords[0], y=coords[1], duration=0.0)
    time.sleep(wait_time)
    pag.mouseDown()
    pag.mouseUp()

def mouse_move_scroll(coords):
    pag.moveTo(coords[0], coords[1] - coord_mouse)

    if ( coords[1] - 15 < point_top['top'] ):
        pag.scroll(17)
        pag.moveTo(chat_purple['left'], chat_purple['top'])

def main():
    # 앱 활성화
    pag.moveTo(point_init['left'], point_init['top'])
    pag.mouseDown()
    pag.mouseUp()
    pag.moveTo(chat_purple['left'], chat_purple['top'])


    # while True:
    #     x, y = pag.position()
    #     position_str = 'X : ' + str(x) + ' Y : ' + str(y)
    #     print(position_str)

    while True:

        # point icon 이미지 캡쳐
        time.sleep(wait_time)
        with mss.mss() as sct:
            x, y = pag.position()
            point_button_img_pos = {'left': x + point_button['left'], 'top': y + point_button['top'], 'width': point_button['width'], 'height': point_button['height']}

            point_button_img = np.array(sct.grab(point_button_img_pos))[:,:,:3]
            long_point_icon_type = compute_point_icon_type(point_button_img)

            point_button_img_pos = {'left': x + point_button['left'], 'top': y + point_button['top'] + 20, 'width': point_button['width'], 'height': point_button['height']}

            point_button_img = np.array(sct.grab(point_button_img_pos))[:,:,:3]
            short_point_icon_type = compute_point_icon_type(point_button_img)

            # cv2.imshow('point_button', point_button_img)
            # cv2.waitKey(0)

            plus_top = 0
            if short_point_icon_type == 'ICON':
                plus_top = 20

            if long_point_icon_type == 'ICON' or short_point_icon_type == 'ICON':
                print('icon click')

                # cv2.imshow('point_button', point_button_img)
                # cv2.waitKey(0)

                # move point button
                # click point button
                click([x + point_button['left'] + point_button['width'] / 2, y + point_button['top'] + point_button['height'] / 2 + plus_top])

                time.sleep(wait_time)

                # delete icon 이미지 캡쳐
                up_delete_button_pos = {'left': x + point_button['left'] + point_button['width'] / 2 + up_delete_button['left'], 'top': y + point_button['top'] + point_button['height'] / 2 + up_delete_button['top'] + plus_top, 'width': up_delete_button['width'], 'height': up_delete_button['height']}

                up_delete_button_img = np.array(sct.grab(up_delete_button_pos))[:,:,:3]
                up_delete_icon_type = compute_delete_icon_type(up_delete_button_img)

                if up_delete_icon_type == 'ICON':
                    print('up delete icon click')

                    # move delete button
                    # click delete button
                    click([x + point_button['left'] + point_button['width'] / 2, y + point_button['top'] + point_button['height'] / 2 + up_delete_button['top'] + plus_top])

                down_delete_button_pos = {'left': x + point_button['left'] + point_button['width'] / 2 + down_delete_button['left'], 'top': y + point_button['top'] + point_button['height'] / 2 + down_delete_button['top'] + plus_top, 'width': down_delete_button['width'], 'height': down_delete_button['height']}

                down_delete_button_img = np.array(sct.grab(down_delete_button_pos))[:,:,:3]
                down_delete_icon_type = compute_delete_icon_type(down_delete_button_img)

                # cv2.imshow('up_delete_button_img', up_delete_button_img)
                # cv2.imshow('down_delete_button_img', down_delete_button_img)
                # cv2.waitKey(0)

                if down_delete_icon_type == 'ICON':
                    print('down delete icon click')

                    # move delete button
                    # click delete button
                    click([x + point_button['left'] + point_button['width'] / 2, y + point_button['top'] + point_button['height'] / 2 + down_delete_button['top'] + plus_top])

                # move mouse & scroll
                mouse_move_scroll([x, y])

            else:
                print('move mouse')

                # move mouse & scroll
                mouse_move_scroll([x, y])

if __name__ == "__main__":
    main()
```

## 참고 사이트

- 빵형의 개발도상국 - 집행검키우기: [https://www.youtube.com/watch?v=1jePlDVw2rQ](https://www.youtube.com/watch?v=1jePlDVw2rQ)
- pyautogui: [https://pyautogui.readthedocs.io/en/latest/](https://pyautogui.readthedocs.io/en/latest/)

```toc

```
