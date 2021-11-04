---
title: '[Python] Linux 18에서 selenium을 이용한 crawler'
date: 2020-11-29 08:05:34
author: TMM
categories: Language
tags: Python cralwer selenium email
---

백을 사기위해 크롤링을 해야하는 세상에 사신다면 믿으시겠습니까?<br />
루이비똥을 사기위해서 만들었고 5일만에 구매 할 수 있었습니다.

## 설치

### python 3 & pip3 설치

```bash
$ sudo apt install python3
$ sudo apt update
$ sudo apt install python3-pip
$ python3 -V
$ pip3 -V
```

### chrome 설치

```bash
$ wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
$ sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
$ sudo apt-get update
$ sudo apt-get install google-chrome-stable
$ google-chrome --version
```

### chrome driver 설치

```bash
$ wget -N https://chromedriver.storage.googleapis.com/86.0.4240.22/chromedriver_linux64.zip
$ sudo apt install unzip
$ unzip chromedriver_linux64.zip
```

### python package

```bash
$ pip3 install xlrd
$ sudo apt-get install xvfb
$ pip3 install pyvirtualdisplay
$ pip3 install selenium
$ pip3 install bs4
```

## 소스

```python
from selenium import webdriver
from pyvirtualdisplay import Display
from bs4 import BeautifulSoup
import smtplib
from email.mime.text import MIMEText
import logging

def sendMail(sendEmail, recvEmailList, password, subject, message):
    try:
        smtpName = "smtp.naver.com" #smtp 서버 주소
        smtpPort = 587 #smtp 포트 번호

        msg = MIMEText(message)

        msg['Subject'] = subject
        msg['From'] = sendEmail

        # logging.debug(msg.as_string())

        s=smtplib.SMTP( smtpName , smtpPort ) #메일 서버 연결
        s.starttls() #TLS 보안 처리
        s.login( sendEmail , password ) #로그인
        for recvEmail in recvEmailList:
            msg['To'] = recvEmail
            s.sendmail( sendEmail, recvEmail, msg.as_string() ) #메일 전송, 문자열로 변환하여 보냅니다.

    except Exception as e:
        logging.error('{}'.format(e))
    finally:
        s.close() #smtp 서버 연결을 종료합니다.

if __name__ == "__main__":

    logging.basicConfig(
        filename='~/dev/crawler/lv/crawler.log',
        format = '%(asctime)s:%(levelname)s:%(message)s',
        datefmt = '%Y-%m-%d %I:%M:%S %p',
        level = logging.INFO
    )

    try:
        display = Display(visible=0, size=(1920, 1080))
        display.start()

        # 옵션 생성
        options = webdriver.ChromeOptions()
        options.add_argument('headless')
        options.add_argument('window-size=1920x1080')
        options.add_argument("disable-gpu")
        options.add_argument('user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.22 Safari/537.36')
        # options.add_argument("--no-sandbox")
        driver = webdriver.Chrome(executable_path=crawler_path + "/chromedriver", options=options)

        driver.implicitly_wait(3)

        driver.get('[루이비똥 가방 URL]')
        html = driver.page_source

        soup = BeautifulSoup(html, 'html.parser')

        text = soup.find(class_='lv-product-purchase-button').text
        text = "".join(line.strip() for line in text.split("\n"))

        if text == '쇼핑백에 추가':
            logging.info('!!!emergency!!!!')

            sendEmail = "[your naver email address]"
            recvEmail = ["[your email address]", "[another email address]"]
            password = "[your email password]"
            subject = "[email title]"
            message = "[email message]"

            sendMail(sendEmail, recvEmail, password, subject, message)

        else:
            logging.info('next time')

    except Exception as e:
        logging.error('{}'.format(e))

    finally:
        driver.quit()   # driver 종료
        display.stop()
```

## crontab 에 등록

```bash
$ crontab -e

*/1 * * * * python3 ~/dev/crawler/lv/app.py
```

## 참고

- https://somjang.tistory.com/entry/Ubuntu-Ubuntu-%EC%84%9C%EB%B2%84%EC%97%90-Selenium-%EC%84%A4%EC%B9%98%ED%95%98%EA%B3%A0-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0
- https://medium.com/@chullino/sudo-%EC%A0%88%EB%8C%80-%EC%93%B0%EC%A7%80-%EB%A7%88%EC%84%B8%EC%9A%94-8544aa3fb0e7
- https://beomi.github.io/2017/09/28/HowToMakeWebCrawler-Headless-Chrome/

```toc

```
