---
title: '[Python] Design pattern'
date: 2020-04-27 08:05:34
author: TMM
categories: Language
tags: Python Design pattern
---

디자인 패턴은 GoF (Gang of Four)가 문제 해결책으로 처음 제시한 개념입니다. GoF 란 `GOF의 디자인 패턴`을 집필한 네 명의 저자를 지칭합니다.

## 디자인 패턴의 장점

- 여러 프로젝트에서 재사용될 수 있습니다.
- 실계 문제를 해결할 수 있습니다.
- 오랜 시간에 걸쳐 유효성이 입증됐습니다.
- 신뢰할 수 있는 솔류션입니다.

## 디자인 패턴의 분류

디자인 패턴을 다음 3가지 범주로 분류합니다.

- 생성 패턴
  - 객체가 생성되는 방식을 중시합니다.
  - 객체 생성 관련 상세 로직을 숨깁니다.
  - 코드는 생성하려는 객체형과는 독립적입니다.
  - 싱글톰 패턴(The Singleton Pattern)은 생성 패턴의 한 종류입니다.
- 구조 패턴
  - 클래스와 객체를 더 큰 결과물로 합칠 수 있는 구조로 설계합니다.
  - 구조를 간결화하고 클래스와 객체 간의 상호관계를 파악할 수 있습니다.
  - 클래스 상속과 커포지션을 중시합니다.
  - 어댑터 패턴(The Adapter Pattern)은 구조 패턴의 한 종류입니다.
- 행위 패턴
  - 객체 간의 상호작용과 책이을 중시합니다.
  - 객체는 상호작용하지만 느슨하게 결합돼야 합니다.
  - 옵서버 패턴(The Observer Pattern)은 행위 패턴의 한 종류입니다.

## 개발 환경

- Python 3.5

## 사전 지식

### 객체지향 프로그래밍의 이해

객체지향 맥락에서 객체는(Object) 속성과(Data Members) 함수로 구성됩니다. 함수는 객체의 속성을 조작합니다.

- 객체
  - 프로그램 내의 개체를 나타냅니다.
- 클래스
  - 클래스를 사용해 특정 개체를 표현합니다.
- 메소드
  - 객체의 행위를 나타냅니다.

### 객체지향 프로그래밍의 주요 기능

- 캡슐화
  - 객체의 기능과 상태 정보를 외부로부터 은닉합니다.
  - get과 set 같은 특수 함수를 사용해 내부 상태를 변경합니다.
- 타형성
  - 객체는 함수 인자에 따라 다른 기능을 합니다.
- 상속
- 추상화
- 컴포지션
  - 객체나 클래스를 더 복잡한 자료 구조나 모듈로 묶는 행위
  - 상속 없이 외부 기능을 사용할 수 있습니다.

### 객체지향 디자인의 기본 원칙

- 개방-폐쇄 원칙
  - 클래스와 객체, 메소드 모두 확장엔 개방적이고 수정엔 패쇄적이어야 한다는 원칙
- 제어 반전 원칙
  - 상위 모듈은 하위 모듈에 의존적이지 않아야 한다는 원칙
- 인터페이스 분리 원칙
  - 클라이언트는 불필요한 인터페이스에 의존하지 않아야 한다는 원칙
- 단일 책임 원칙
  - 클래스는 하나의 책임만을 가져야 한다는 원칙
- 치환 원칙
  - 파생된 클래스는 기본 클래스를 완전히 확장해야 한다는 원칙

## 싱글톤 디자인 패턴

- 글로벌하게 접근 가능한 단 한 개의 객체만을 허용하는 패턴
- 로깅, 데이터베이스 관리, 프린터 스풀러 등의 애플리케이션에 사용
- 동일한 리소스에 대한 동시 요청의 충돌을 막기 위해 한 개의 인스턴스만 필요한 경우에 주로 쓰입니다.

### 싱글톤과 메타클래스

메타클래스는 클래스의 클래스 입니다. 메타클래스를 사용하면 이미 정의된 파이썬 클래스를 통해 새로운 형식으 클래스를 생성할 수 있습니다.

### 싱글톤 패턴 사용 사례

- 데이터베이스 관리

### 싱글톤 패턴 예제

```python
import sqlite3

class MetaSingleton(type):

    _instances = {}
    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(MetaSingleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


class Database(metaclass=MetaSingleton):
    connection = None
    def connect(self):
        if self.connection is None:
            self.connection = sqlite3.connect("db.sqlite3")
            self.cursorobj = self.connection.cursor()
        return self.cursorobj

db1 = Database().connect()
db2 = Database().connect()

print ("Database Objects DB1", db1)
print ("Database Objects DB2", db2)
```

- 데이터베이스의 동기화가 보장됩니다. 리소스를 적게 사용해 메모리와 CPU 사용량을 최적화할 수 있습니다.

### 싱글톤 패턴의 단점

- 전역 변수의 값이 실수로 변경된 것을 모르고 애플리케이션에서 사용될 수 있습니다.

## 팩토리 패턴

객체지향 프로그래밍에서 팩토리란 다른 클래스의 객체를 생성하는 클래스를 일컫는 말입니다.

### 팩토리가 필요한 이유

- 객체 생성과 클래스 구현은 나눠 상호 의존도를 줄입니다.
- 클라이언트는 생성하려는 객체 클래스 구현과 상관없이 사용할 수 있습니다.
- 코드를 수정하지 안혹 간단하게 팩토리에 새로운 클래스를 추가할 수 있습니다.

### 팩토리 패턴의 종류

- 심플 팩토리 패턴
- 팩토리 메소드 패턴
- 추상 팩토리 패턴

**Note:**
이글에서는 _팩토리 메소드 패턴_ 에 대해서만 언급하겠습니다.
{: .notice--info}

### 팩토리 메소드 패턴의 장점

- 객체를 생성하는 코드와 활용하는 코드를 분리해 의존성이 줄어듭니다. 새로운 클래스 추가 등의 유지보수가 쉽습니다.

### 팩토리 메소드 패턴 사용 사례

- 웨딩플레너

### 팩토리 메소드 패턴 예제

```python
from abc import ABCMeta, abstractmethod

class Section(metaclass=ABCMeta):
    @abstractmethod
    def describe(self):
        pass

class PersonalSection(Section):
    def describe(self):
        print("Personal Section")

class AlbumSection(Section):
    def describe(self):
        print("Album Section")

class PatentSection(Section):
    def describe(self):
        print("Patent Section")

class PublicationSection(Section):
    def describe(self):
        print("Publication Section")

class Profile(metaclass=ABCMeta):
    def __init__(self):
        self.sections = []
        self.createProfile()

    @abstractmethod
    def createProfile(self):
        pass

    def getSections(self):
        return self.sections

    def addSections(self, section):
        self.sections.append(section)

class linkedin(Profile):
    def createProfile(self):
        self.addSections(PersonalSection())
        self.addSections(PatentSection())
        self.addSections(PublicationSection())

class facebook(Profile):
    def createProfile(self):
        self.addSections(PersonalSection())
        self.addSections(AlbumSection())

if __name__ == '__main__':
    profile_type = input("Which Profile you'd like to create? [LinkedIn or FaceBook]")
    profile = eval(profile_type.lower())()
    print("Creating Profile..", type(profile).__name__)
    print("Profile has sections --", profile.getSections())
```

## 퍼사드 디자인 패턴

퍼사드(Facode)란 건물의 정면을 의미합니다. 복잡한 내부 시스템 로직을 감추고 클라이언트가 쉽게 시스템에 접근할 수 있는 인터페이스를 제공합니다.

### 퍼사드 디자인 패턴의 구성원

- 퍼사드
  - 어떤 서브시스템이 요청에 맞는지 알고 있는 인터페이스
  - 컴포지션을 통해 클라이언트의 요청을 적합한 서스시스템 객체에 전달합니다.
- 시스템
  - 서브시스템의 기능을 구현하는 클래스입니다.
  - 퍼사드의 존재도 모르며 참고하지도 않습니다.
- 클라이언트
  - 퍼사드를 인스턴스화하는 클래스 입니다.

### 퍼사드 패턴 예제

```python
class Hotelier(object):
    def __init__(self):
        print("Arranging the Hotel for Marriage? --")
    def __isAvailable(self):
        print("Is the Hotel free for the event on given day?")
        return True
    def bookHotel(self):
        if self.__isAvailable():
            print("Registered the Booking\n\n")

class Florist(object):
    def __init__(self):
        print("Flower Decorations for the Event? --")
    def setFlowerRequirements(self):
        print("Carnations, Roses and Lilies would be used for Decorations\n\n")

class Caterer(object):
    def __init__(self):
        print("Food Arrangements for the Event --")
    def setCuisine(self):
        print("Chinese & Continental Cuisine to be served\n\n")

class Musician(object):
    def __init__(self):
        print("Musical Arrangements for the Marriage --")
    def setMusicType(self):
        print("Jazz and Classical will be played\n\n")

class EventManager(object):
    def __init__(self):
        print("Event Manager:: Let me talk to the folks\n")
    def arrange(self):
        self.hotelier = Hotelier()
        self.hotelier.bookHotel()

        self.florist = Florist()
        self.florist.setFlowerRequirements()

        self.caterer = Caterer()
        self.caterer.setCuisine()

        self.musician = Musician()
        self.musician.setMusicType()

class You(object):
    def __init__(self):
        print("You:: Whoa! Marriage Arrangements??!!!")
    def askEventManager(self):
        print("You:: Let's Contact the Event Manager\n\n")
        em = EventManager()
        em.arrange()
    def __del__(self):
        print("You:: Thanks to Event Manager, all preparations done! Phew!")

you = You()
you.askEventManager()
```

> 최소 지식 원칙: 퍼사드 패턴은 최쇠 지식원칙을 기반으로 합니다. 지나치게 서로 얽혀있는 클래스를 만드는것을 지양합니다.

## 옵서버 디자인 패턴

객체(서브젝트)는 자식(옵서버)의 목록을 유지하며 서브젝트가 옵서버에 정의된 메소드를 호출할 때마다 옵서버에 이를 알립니다.

### 옵서버 패턴의 목적

- 객체 간 일대다(1:N) 관계를 형성하고 객체의 상태를 다른 종속 객체에 자동으로 알립니다.
- 서브젝트의 핵심 부분을 캡술화합니다.

### 옵서버 패터 사용 사례

- 뉴스 에이전시를 옵서버 패턴으로 구현하여 새로운 뉴스등록시 이메일, 문자, 음성 메시지 등 다양한 방식으로 뉴스를 저달합니다. 추후에 새로운 알림도 추가 지원할 수 있도록 설계합니다.

### 옵서버 패턴 예제

```python
class NewsPublisher:
    def __init__(self):
        self.__subscribers = []
        self.__latestNews = None
    def attach(self, subscriber):
        self.__subscribers.append(subscriber)
    def detach(self):
        return self.__subscribers.pop()
    def subscribers(self):
        return [type(x).__name__ for x in self.__subscribers]
    def notifySubscribers(self):
        for sub in self.__subscribers:
            sub.update()
    def addNews(self, news):
        self.__latestNews = news
    def getNews(self):
        return "Got News:", self.__latestNews

from abc import ABCMeta, abstractmethod

class Subscriber(metaclass=ABCMeta):
    @abstractmethod
    def update(self):
        pass

class SMSSubscriber:
    def __init__(self, publisher):
        self.publisher = publisher
        self.publisher.attach(self)
    def update(self):
        print(type(self).__name__, self.publisher.getNews())

class EmailSubscriber:
    def __init__(self, publisher):
        self.publisher = publisher
        self.publisher.attach(self)
    def update(self):
        print(type(self).__name__, self.publisher.getNews())

class AnyOtherSubscriber:
    def __init__(self, publisher):
        self.publisher = publisher
        self.publisher.attach(self)
    def update(self):
        print(type(self).__name__, self.publisher.getNews())

if __name__ == '__main__':
    news_publisher = NewsPublisher()

    for Subscribers in [SMSSubscriber, EmailSubscriber, AnyOtherSubscriber]:
        Subscribers(news_publisher)
        print("\nSubscribers:", news_publisher.subscribers())

        news_publisher.addNews('Hello World!')
        news_publisher.notifySubscribers()

        print("\nDetached:", type(news_publisher.detach()).__name__)
        print("\nSubscribers:", news_publisher.subscribers())

        news_publisher.addNews('My second news!')
        news_publisher.notifySubscribers()
```

> 느슨한 결합: 느슨한 결합은 중요한 소프트웨어 애플리케이션 설계 원칙입니다. 상호 작용하는 객체 간의 관계를 최대한 느슨하게 구성하는 것이 목적입니다. 여기서 결합이란 객체가 상호 작용하는 다른 객체에 대해 알고 있는 정도를 의미합니다. 느슨한 결합을 추구한 설계는 객체 간의 의존도를 줄여 유연한 객체지향 시스템을 만들 수 있습니다.

## 참고사이트

```yaml
http://acornpub.co.kr/book/python-design-patterns-2e
```

```toc

```
