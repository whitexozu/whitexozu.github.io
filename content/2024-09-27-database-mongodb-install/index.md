---
title: '[MongoDB] 설치, 계정생성, 원격 접속, 테스트 데이터 입력'
date: 2024-09-27 08:05:34
author: TMM
categories: Database
tags: MongoDB
---

## 개념 설명

1. Collection (컬렉션)

  - 컬렉션은 MongoDB에서 데이터가 저장되는 공간으로, 관계형 데이터베이스의 테이블과 유사한 역할을 합니다.
  - 하나의 데이터베이스 안에는 여러 컬렉션이 있을 수 있습니다.
  - 같은 컬렉션에 저장된 문서들은 서로 다른 구조를 가질 수 있습니다. 즉, 스키마가 강제되지 않으며, 각 문서가 필드나 데이터 구조를 자유롭게 설정할 수 있습니다.

2. Document (문서)

  - 문서는 MongoDB에서 데이터를 저장하는 기본 단위입니다. 각각의 문서는 JSON 또는 BSON(Binary JSON) 형식으로 저장됩니다.
  - 하나의 문서가 하나의 레코드로 취급되며, 이는 관계형 데이터베이스에서 행(row)에 해당합니다.
  - 문서에는 여러 필드가 포함되며, 각 필드는 키-값 쌍으로 저장됩니다.

3. Field (필드)

  - 필드는 문서 내에서 특정 데이터를 저장하는 단위로, 관계형 데이터베이스의 열(column)과 유사합니다.
  - 각 필드는 이름(키)과 값으로 구성되며, 값의 유형은 문자열, 숫자, 배열, 객체 등 다양할 수 있습니다.
  - 문서 내 필드들은 유동적으로 추가되거나 제거될 수 있으며, 동일한 컬렉션 내 문서들끼리 필드 구성이 달라도 상관없습니다.

## ubuntu 18에 MongoDB 설치

```bash
# MongoDB는 공식 Ubuntu 저장소에는 포함되지 않으므로, MongoDB 공식 저장소를 추가해야 합니다.
$ sudo apt update
$ sudo apt install -y gnupg

# MongoDB의 GPG 키를 가져옵니다.
$ wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

# 이제 MongoDB 패키지 저장소를 추가합니다.
$ echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# 이제 패키지 목록을 업데이트하고 MongoDB를 설치합니다.
$ sudo apt update
$ sudo apt install -y mongodb-org

# MongoDB를 시작.
$ sudo systemctl start mongod

# MongoDB가 실행 중이면, 터미널에서 MongoDB 셸에 접속할 수 있습니다.
$ mongosh
```
## 사용자 생성

```bash
# 터미널에서 MongoDB 셸에 접속
$ mongosh

# MongoDB의 사용자 관리 권한은 admin 데이터베이스에서 이루어집니다.
> use admin

# 관리자 권한을 가진 사용자를 생성
> db.createUser({
  user: "myUserAdmin",
  pwd: "myPassword",
  roles: [{ role: "userAdminAnyDatabase", db: "admin" }]
})

> exit

# mongod.conf 파일에서 인증을 활성화
$ vi /etc/mongod.conf

# authorization: "enabled"로 변경
...
security:
  authorization: enabled
...

# 변경 후 MongoDB를 다시 시작합니다.
$ systemctl restart mongod.service

# 사용자 인증으로 접속
$ mongosh -u "myUserAdmin" -p "myPassword" --authenticationDatabase "admin"
```

## 원격 접속 설정

```bash
# MongoDB 설정 파일을 수정합니다.
$ vi /etc/mongod.conf

# any
...
net:
  bindIp: 0.0.0.0
...

# 특정 IP만 지정
...
net:
  bindIp: 127.0.0.1, <your_remote_pc_ip>
...

# 변경 후 MongoDB를 다시 시작합니다.
$ systemctl restart mongod.service

# 원격 PC에서 MongoDB 접속
$ mongosh --host <server_ip> -u "myUserAdmin" -p "myPassword" --authenticationDatabase "admin"
```

## 테스트 데이터 입력

```bash
# 접속
$ mongosh -u "myUserAdmin" -p "myPassword" --authenticationDatabase "admin"

# temp DB 생성
> use temp

# users collection 생성
> db.createCollection('users')
< MongoServerError[Unauthorized]: not authorized on temp to execute command

# 계정에 temp 권한 추가
> use admin
> db.grantRolesToUser("myUserAdmin", [{ role: "readWrite", db: "temp" }])

# 만약 myUserAdmin 계정에 모든 데이터베이스에 대해 읽기/쓰기 권한을 부여하고 싶다면, 다음과 같은 명령을 사용할 수 있습니다:
> use admin
> db.grantRolesToUser("myUserAdmin", [{ role: "readWriteAnyDatabase", db: "admin" }])

# temp DB 이동
> use temp;

> db.createCollection('users');
< { ok: 1 }

> show collections;
< users

> show databases;
< admin   148.00 KiB
  config   60.00 KiB
  local    72.00 KiB
  temp      8.00 KiB

> db.users.insertOne({'name':'이름', 'age':20, 'gender':'man'});
< {
    acknowledged: true,
    insertedId: ObjectId('...')
  }

> db.users.find();

> db.user.drop();

> use temp;
> db.dropDatabase();

```

## 로그 rotate설정

```bash
# MongoDB의 로그 파일을 관리할 수 있도록 /etc/logrotate.d/mongodb 설정 파일을 생성합니다.
$ vi /etc/logrotate.d/mongodb

'''
/var/log/mongodb/mongod.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 664 root root
    sharedscripts
    postrotate
        /bin/kill -SIGUSR1 `pgrep mongod`
    endscript
}
'''
```

## csv import

```bash
$ mongoimport --db <database_name> --collection <collection_name> --type csv --headerline --file <path_to_csv_file>
$ mongoimport --db <database_name> --collection <collection_name> --type csv --headerline --file <path_to_csv_file> --username <your_username> --password <your_password> --authenticationDatabase <auth_db> --batchSize 1000
# --db <database_name>: 데이터를 import할 MongoDB 데이터베이스 이름.
# --collection <collection_name>: 데이터를 저장할 컬렉션 이름.
# --type csv: 파일 형식을 CSV로 지정.
# --headerline: 첫 번째 줄을 필드 이름으로 사용 (CSV의 헤더 행을 컬렉션 필드로 자동 인식).
# --file <path_to_csv_file>: import할 CSV 파일의 경로.
# --username 및 --password: 사용자명과 비밀번호.
# --authenticationDatabase: 인증을 위한 데이터베이스 (보통 admin).
$ mongoimport --db mydatabase --collection mycollection --type csv --headerline --file /path/to/myfile.csv
```

## 테스트 데이서 생성, 조회, 수정, 삭제

```bash
> db.createCollection('test')
< { ok: 1 }

> for (let i = 1; i <= 10000; i++) {
    db.test.insertOne({
        name: `user${i}`,
        age: Math.floor(Math.random() * 50) + 20, // 20에서 70 사이의 무작위 나이
        city: "City" + i
    });
}
< {
  acknowledged: true,
  insertedId: ObjectId('66f5a0cc776e25c54f4ad826')
}

> db.test.countDocuments()
< 10000

> db.test.find({ age: { $gte: 30 } }).pretty();
< {
  _id: ObjectId('66f5a082776e25c54f4ab118'),
  name: 'user2',
  age: 59,
  city: 'City2'
}
...

> db.test.find({ name: 'user50' })
< {
  _id: ObjectId('66f5a083776e25c54f4ab148'),
  name: 'user50',
  age: 37,
  city: 'City50'
}

> db.test.updateOne(
    { name: "user50" },  // 수정할 조건
    { $set: { age: 60 } } // 수정할 내용
)
< {
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}

> db.test.find({ name: 'user50' })
< {
  _id: ObjectId('66f5a083776e25c54f4ab148'),
  name: 'user50',
  age: 60,
  city: 'City50'
}

> db.test.deleteOne({ name: "user50" });
< {
  acknowledged: true,
  deletedCount: 1
}

> db.test.find({ name: 'user50' })
<

> db.test.countDocuments()
< 9999
```

## Index 적용

```bash
# name 필드에 index 생성
> db.test.createIndex({ name: 1 });
# { name: 1 }: name 필드에 대해 오름차순(ascending) 인덱스를 적용합니다. 1은 오름차순을, -1은 내림차순(descending)을 의미합니다.

# 인덱스 생성 후 확인
> db.test.getIndexes();

# unique 옵션을 사용하면 해당 필드에 중복 값을 허용하지 않도록 설정할 수 있습니다.
> db.test.createIndex({ name: 1 }, { unique: true });
```