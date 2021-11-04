---
title: '[RabbitMQ] Install RabbitMQ on windows and linux'
date: 2021-03-25 08:05:34
author: TMM
categories: Message Queue
tags: rabbitmq mac window 10 ubuntu 16 erlang
---

spring-boot으로 서비스 중인 서버에 대량의 메시지 발송 API 연동이 필요하게 되었습니다. 그래서 RabbitMQ를 사용해 보기로 했습니다.
<br />
최종 목적은 spring-boot으로 메시지 큐에 등록 후 python daemon으로 처리되도록 하겠습니다.

## install

### window

1. 설치

   1. https://www.rabbitmq.com/install-windows.html 이동
   1. Direct Download 에 있는 링크를 클릭하여 다운로드
      - 저는 _rabbitmq-server-3.8.14.exe_ 으로 받았습니다.
   1. 다운받은 파일을 실행하면 **Erlang could not be detected** 라는 메시지가 나옵니다. PC에 Erlang을 설치해야 합니다. "예(Y)" 를 눌러줍니다.
   1. Erlang 다운로드 페이지에서 *OTP 23.1 windowns 64-bit Binary Fil*을 다운받아 설치합니다.
   1. 다시 RabbitMQ Install File을 눌러 설치합니다.

1. 시스템 변수 확인

   - ERLANG_HOME: :\Program Files\erl-23.3

1. 시스템 변수 등록

   - 환경 변수 등록 창의 사용자 변수 Path에 _C:\Program Files\RabbitMQ Server\rabbitmq_server-3.8.14\sbin_ 추가합니다.

1. 명령어

   - 상태 확인
     - `rabbitmqctl status`
   - Port 확인
     - `netstat -ano | findstr 5672`
   - 플러그인 설치
     - `rabbitmq-plugins enable rabbitmq_management`
   - 플러그인 설치 확인
     - `rabbitmq-plugins list`
   - 사용자 추가
     - `rabbitmqctl add_user admin p@ssWord`
   - 사용자 태그 설정
     - `rabbitmqctl set_user_tags admin administrator`
   - 사용자 목록 확인
     - `rabbitmqctl list_users`
   - 사용자 삭제
     - `rabbitmqctl delete_user rabbitmq`
   - 사용자 권한 설정
     - `rabbitmqctl set_permissions [-p <vhostpath>] <user> <conf> <write> <read>`
     - `rabbitmqctl set_permissions -p / "admin" ".*" ".*" ".*"`
   - 사용자 권한 목록 확인
     - `rabbitmqctl list_permissions`

1. 관리 페이지 접속

   - http://localhost:15672/
   - admin/p@ssWord

1. config 및 log 파일 위치

   - C:\Users\<사용자명>\AppData\Roaming\RabbitMQ

1. 사용자 변수 등록 (confing 및 log 파일 위치 변경)

   - RABBITMQ_BASE : D:\dev\application\rabbitmq

1. 설치 후 에러 발생시

   - 서비스 삭제
     - `rabbitmq-service.bat remove`
   - 서비스 생성
     - `rabbitmq-service.bat install`
   - 실행
     - `rabbitmq-server.bat -detached`

### Ubuntu 16

1. 설치

   ```bash
   $ apt-key adv --keyserver "hkps.pool.sks-keyservers.net" --recv-keys "0x6B73A36E6026DFCA"
   ...

   $ sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list <<EOF
   deb <https://dl.bintray.com/rabbitmq-erlang/debian> xenial erlang
   deb <https://dl.bintray.com/rabbitmq/debian> xenial main
   EOF

   $ sudo apt-get update
   ...

   $ sudo apt-get install rabbitmq-server
   ...
   ```

1. 서버 시작

   ```bash
   $ sudo service rabbitmq-server start
   ==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
   Authentication is required to start 'rabbitmq-server.service'.
   Authenticating as: root
   Password:
   ...
   ```

1. 플러그인 설치

   ```bash
   $ sudo rabbitmq-plugins enable rabbitmq_management
   ...
   ```

1. 사용자 추가

   ```bash
   $ sudo rabbitmqctl add_user admin password
   $ sudo rabbitmqctl set_user_tags admin administrator
   $ sudo rabbitmqctl set_permissions -p / "admin" ".*" ".*" ".*"
   $ sudo rabbitmqctl list_users
   $ sudo rabbitmqctl list_permissions
   ```

1. 관리 페이지 접속

   - http://localhost:15672/
   - admin/p@ssWord

1. 로그위치
   - /var/log/rabbitmq

## 개념

### RabbitMQ란

- RabbitMQ 는 얼랭(Erlang)으로 AMQP를 구현한 메시지 브로커 시스템입니다.

### AMPQ

- 클라이언트가 메시지 미들웨어 브로커와 통신할 수 있게 해주는 메세징 프로토콜입니다.
- Producers -> Broker [Exchange -> Binding -> Queue] -> Consumers
- 메시지를 발행하는 Producer에서 Broker의 Exchange로 메시지를 전달하면, Binding 이라는 규칙에 의해 연결된 Queue로 메시지가 참조 복사됩니다.
- 메시지를 받아가는 Consumer에서는 브로커의 Queue를 통해 메시지를 받아가서 처리합니다.

## 예제 소스

### Spring-boot

#### Producer

1. pom.xml

   ```xml
   ...
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-amqp</artifactId>
   </dependency>

   <dependency>
       <groupId>org.springframework.amqp</groupId>
       <artifactId>spring-rabbit-test</artifactId>
       <scope>test</scope>
   </dependency>
   ...
   ```

1. application.yml

   ```yml
   spring:
     rabbitmq:
       host: localhost
       username: admin
       password: p@ssWord
   ```

1. Sender.java

   ```java
   import org.springframework.amqp.core.Queue;
   import org.springframework.amqp.rabbit.core.RabbitMessagingTemplate;
   import org.springframework.beans.factory.annotation.Autowired;
   import org.springframework.context.annotation.Bean;
   import org.springframework.stereotype.Component;

   @Component
   public class Sender {
       @Autowired
       RabbitMessagingTemplate template;

       @Bean
       Queue queue() {
           return new Queue("hello_queue", false);
       }

       public void send(String message) {
           template.convertAndSend("hello_queue", message);
       }
   }
   ```

1. Controller.java

   ```java
   ...
       @PostMapping(value = "/send")
       public String sendNaverworks(@RequestBody MsgDTO userDomain) {
           try {
               sender.send(userDomain.getContent());
               return "success"
           } catch (Exception e) {
               System.out.println(e.getMessage());
               return "fail"
           }
       }
   ...
   ```

### Python 3.6

#### consumer

1. single_process_consumer.py

   ```python
   #!/usr/bin/env python
   import pika
   import time
   import json

   connection = pika.BlockingConnection(
       pika.ConnectionParameters(
           host='localhost',
           port=5672,
           virtual_host='/',
           credentials=pika.PlainCredentials('admin', 'p@ssWord')

       )
   )
   channel = connection.channel()

   channel.queue_declare(queue='hello_queue', durable=True)
   print(' [*] Waiting for messages. To exit press CTRL+C')


   def callback(ch, method, properties, body):
       print(" [x] Received %r" % body.decode())
       d = json.loads(body.decode())
       print(" [x] Done {}".format(d['content']))
       ch.basic_ack(delivery_tag=method.delivery_tag)


   channel.basic_qos(prefetch_count=1)
   channel.basic_consume(queue='hello_queue', on_message_callback=callback)

   channel.start_consuming()
   ```

1. multi_process_consumer.py

   ```python
   import logging
   import logging.handlers
   import multiprocessing
   from threading import Thread
   from random import choice, random
   import time
   import platform
   import pika
   import json
   import requests

   class Log():
       def __init__(self):
           self.th = None

       def get_logger(self, name):
           return logging.getLogger(name)

       def listener_start(self, file_path, name, queue):
           self.th = Thread(target=self._proc_log_queue, args=(file_path, name, queue))
           self.th.start()

       def listener_end(self, queue):
           queue.put(None)
           self.th.join()
           print('log listener end...')

       def _proc_log_queue(self, file_path, name, queue):
           self.config_log(file_path, name)
           logger = self.get_logger(name)
           while True:
               try:
                   record = queue.get()
                   if record is None:
                       break
                   logger.handle(record)
               except Exception:
                   import sys, traceback
                   print('listener problem', file=sys.stderr)
                   traceback.print_exc(file=sys.stderr)

       def config_queue_log(self, queue, name):
           qh = logging.handlers.QueueHandler(queue)
           logger = logging.getLogger(name)
           logger.setLevel(logging.DEBUG)
           logger.addHandler(qh)
           return logger

       def config_log(self, file_path, name):
           formatter = logging.Formatter('[%(asctime)s] [%(pathname)s:%(lineno)d] [%(processName)s] %(levelname)s - %(message)s','%Y-%m-%d %H:%M:%S')

           # err file handler
           fileHander_error = logging.handlers.TimedRotatingFileHandler(filename=file_path + '/consumer.error.log', when='midnight', interval=1, encoding='utf-8')
           fileHander_error.setLevel(logging.WARNING)
           # file handler
           fileHander_debug = logging.handlers.TimedRotatingFileHandler(filename=file_path + '/consumer.debug.log', when='midnight', interval=1, encoding='utf-8')
           fileHander_debug.setLevel(logging.DEBUG)
           # console handler
           streamHander_info = logging.StreamHandler()
           streamHander_info.setLevel(logging.INFO)
           # logging format setting
           fileHander_error.setFormatter(formatter)
           fileHander_error.suffix = '%Y-%m-%d'
           fileHander_debug.setFormatter(formatter)
           fileHander_debug.suffix = '%Y-%m-%d'
           streamHander_info.setFormatter(formatter)
           if platform.system() == 'Windows':
               import msvcrt
               import win32api
               import win32con
               win32api.SetHandleInformation(msvcrt.get_osfhandle(fileHander_debug.stream.fileno()),
                                           win32con.HANDLE_FLAG_INHERIT, 0)
               win32api.SetHandleInformation(msvcrt.get_osfhandle(fileHander_error.stream.fileno()),
                                           win32con.HANDLE_FLAG_INHERIT, 0)
           # create logger, assign handler
           logger = logging.getLogger(name)
           logger.setLevel(logging.DEBUG)
           logger.addHandler(fileHander_error)
           logger.addHandler(fileHander_debug)
           logger.addHandler(streamHander_info)
           return logger

   def callback(ch, method, properties, body, logger):

       logger.log(logging.INFO, body.decode())

       try:
           d = json.loads(body.decode())
           # print(" [x] to {}".format(d['to']))
           # print(" [x] from {}".format(d['from']))
           # print(" [x] content {}".format(d['content']))

           logger.info('{} - {}'.format(response.status_code, json.loads(response.text)))
           logger.info('headers [{}] - {}'.format(response.status_code, response.headers))

           if response.status_code != 200:
               logger.log(logging.ERROR, '{} - {}'.format(response.status_code, json.loads(response.text)))
       except Exception as e:
           logger.log(logging.ERROR, "%r caught exception %r" % (multiprocessing.current_process(), e))

       ch.basic_ack(delivery_tag=method.delivery_tag)

   def consume(queue):

       name = multiprocessing.current_process().name
       logger = Log().config_queue_log(queue, 'mp')
       print('Worker started: %s' % name)

       connection = pika.BlockingConnection(
           pika.ConnectionParameters(
               host='localhost',
               port=5672,
               virtual_host='/',
               credentials=pika.PlainCredentials('admin', 'p@ssWord')
           )
       )
       channel = connection.channel()
       channel.queue_declare(queue='hello_queue')

       channel.basic_qos(prefetch_count=1)
       channel.basic_consume(queue='hello_queue', on_message_callback=lambda ch, method, properties, body: callback(ch, method, properties, body, logger))
       # print (' [*] Waiting for messages. To exit press CTRL+C')
       channel.start_consuming()

       print('Worker finished: %s' % name)

   def main():
       queue = multiprocessing.Queue(-1)
       listener = Log()
       listener.listener_start('/logs', 'listener', queue)  # log consumer thread start

       workers = []
       for i in range(2):  # multiprocess loop
           w = multiprocessing.Process(target=consume, args=(queue,))
           workers.append(w)
           w.start()

       for w in workers:
           w.join()

       listener.listener_end(queue)  # log consumer thread end

   if __name__ == '__main__':
       main()

   ```

#### Producer (테스트용)

1. producer.py

   ```python
   #!/usr/bin/env python
   import pika
   import sys

   connection = pika.BlockingConnection(
       pika.ConnectionParameters(
           host='localhost',
           port=5672,
           virtual_host='/',
           credentials=pika.PlainCredentials('admin', 'p@ssWord')
       )
   )
   channel = connection.channel()

   channel.queue_declare(queue='hello_queue', durable=True)

   message = ' '.join(sys.argv[1:]) or '{"from":123, "to": "email", "content": "aaa\\nbbb\\nccc"}'
   channel.basic_publish(
       exchange='',
       routing_key='hello_queue',
       body=message,
       properties=pika.BasicProperties(
           delivery_mode=2,  # make message persistent
       ))
   print(" [x] Sent %r" % message)
   connection.close()
   ```

## systemd 등록

### service file 생성

```bash
$ sudo vi /etc/systemd/system/<project_name>.consumer.service

[Unit]
Description=<project_name> consumer
After=network.target

[Service]
User=<user_name>
Group=<user_name>
ExecStart=/usr/bin/python3 /home/<user_name>/<project_name>/consumer/multi_process_consumer.py
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target

```

### systemd 명령어

- 수정 반영
  - `sudo systemctl daemon-reload`
- 시작
  - `sudo systemctl start <project_name>.consumer.service`
- 상태
  - `sudo systemctl status <project_name>.consumer.service`
- 정지
  - `sudo systemctl stop <project_name>.consumer.service`

## 참고 사이트

- https://www.rabbitmq.com/
- https://jonnung.dev/rabbitmq/2019/02/06/about-amqp-implementtation-of-rabbitmq/

```toc

```
