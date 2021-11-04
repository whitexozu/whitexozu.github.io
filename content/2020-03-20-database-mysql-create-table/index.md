---
title: '[MySQL] 테이블 생성시 고려사항'
date: 2020-03-20 08:05:34
author: TMM
categories: Database
tags: MySQL
---

프로젝트를 설계를 할때면 리셋되어 있는 지식들이 있습니다.<br />
그중에 DB 설계 관련 지식들은 거의 신생아로 돌아간거 같습니다.<br />
그래서 나중에 찾아볼 것들을 미리 정리해 보았습니다.

## Data Types

### Numeric types

- Integer Types (정수 타입)

  | Type | Storage (Bytes) | Minimum Value Signed | Minimum Value Unsigned | Maximum Value Signed | Maximum Value Unsigned |
  |TINYINT |1 |-128 |0 |127 |255|
  |SMALLINT |2 |-32768 |0 |32767 |65535|
  |MEDIUMINT |3 |-8388608 |0 |8388607 |16777215|
  |INT |4 |-2147483648 |0 |2147483647 |4294967295|
  |BIGINT |8 |-2<sup>63</sup> |0 |2<sup>63</sup> - 1 |2<sup>64</sup> - 1|

  ```sql
  CREATE TABLE test (
  column1 int(10) unsigned NOT NULL AUTO_INCREMENT,
  column2 int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (column1)
  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  ```

  > 정수형 데이터 타입을 생성할때 예상되는 최소, 최대 값과 부호를 확인 후 선택해야 합니다.

- Fixed-Point Types (고정 소수점 타입)

  - DECIMAL
  - NUMERIC

- Floating-Point Types (부동 소수점 타입)

  - FLOAT
  - DOUBLE

- Bit-Value Type (비트값 타입)
  - BIT

### String types

- CHAR and VARCHAR Types

  |Value |CHAR(4) |Storage Required |VARCHAR(4) |Storage Required|
  |'' |' ' |4 bytes |'' |1 byte|
  |'ab' |'ab ' |4 bytes |'ab' |3 bytes|
  |'abcd' |'abcd' |4 bytes |'abcd' |5 bytes|
  |'abcdefgh' |'abcd' |4 bytes |'abcd' |5 bytes|

  컬럼 속정 정보 `CHAR(M)`, `VARCHAR(M)` 의 M은 저장할 수 있는 문자열의 최대 길이를 나타냅니다.<br />
  CHAR는 *0~255*까지 설정할 수 있으며, VARCHAR는 *0~65,535*까지 설정할 수 있습니다.<br />

  ```sql
  mysql> CREATE TABLE vc (v VARCHAR(4), c CHAR(4));
  Query OK, 0 rows affected (0.01 sec)

  mysql> INSERT INTO vc VALUES ('ab  ', 'ab  ');
  Query OK, 1 row affected (0.00 sec)

  mysql> SELECT CONCAT('(', v, ')'), CONCAT('(', c, ')') FROM vc;
  +---------------------+---------------------+
  | CONCAT('(', v, ')') | CONCAT('(', c, ')') |
  +---------------------+---------------------+
  | (ab  )              | (ab)                |
  +---------------------+---------------------+
  1 row in set (0.06 sec)

  mysql> SELECT c LIKE 'ab', c LIKE 'ab  ' FROM vc;
  +-----------+-------------+
  |c LIKE 'ab'|c LIKE 'ab  '|
  +-----------+-------------+
  |          1|            0|
  +-----------+-------------+
  ```

  공백 저장시 CHAR, VARCHAR 모두 저장이 되나 조회시 CHAR은 공백을 제거합니다.<br />
  CHAR는 EQUAL 검색시 공백이 있어도 검색이되나 LIKE 검색시 공백이 있으면 검색이 되지 않습니다.

- BINARY and VARBINARY Types

- BLOB and TEXT Types

- ENUM Type

- SET Type

### Date types

- DATE, DATETIME, and TIMESTAMP Types

  ```sql
  mysql> CREATE TABLE ts (
      ->     id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
      ->     col TIMESTAMP NOT NULL
      -> ) AUTO_INCREMENT = 1;

  mysql> CREATE TABLE dt (
      ->     id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
      ->     col DATETIME NOT NULL
      -> ) AUTO_INCREMENT = 1;
  ```

  DATE는 날짜 부분만 사용됩니다. 지원 범위는 'YYYY-MM-DD', '1000-01-01', '9999-12-31' 입니다.<br />
  DATETIME유형은 날짜와 시간 부분을 모두 포함하는 값에 사용됩니다. DATETIME은 형식으로 값을 검색하고 표시 합니다. 지원 범위는 'YYYY-MM-DD hh:mm:ss', '1000-01-01 00:00:00', '9999-12-31 23:59:59' 입니다.<br />
  TIMESTAMP데이터 타입은 날짜와 시간 부분을 모두 포함하는 값에 사용됩니다. UTC ~ UTC TIMESTAMP범위입니다 . '1970-01-01 00:00:01', '2038-01-19 03:14:07'<br />
  DATETIME또는 TIMESTAMP 값이 마이크로 초(6자리 소수 부분)를 포함 할 수 있습니다. 특히, DATETIME또는 TIMESTAMP열에 삽입 된 값의 소수 부분 은 버리지 않고 저장됩니다.

- TIME Type

- YEAR Type

### Json type

- JSON 데이터 입력

  ```sql
  CREATE TABLE facts (
      id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
      sentence JSON
  ) AUTO_INCREMENT = 1;

  INSERT INTO facts(sentence) VALUES(JSON_OBJECT('key1', 1, 'key2', 'abc'));
  INSERT INTO facts(sentence) VALUES(JSON_ARRAY('a', 1, NOW()));
  INSERT INTO facts(sentence) VALUES(JSON_MERGE_PRESERVE('["a", 1]', '{"key": "value"}'));
  SET @j = JSON_OBJECT('key', 'value');
  INSERT INTO facts(sentence) VALUES(@j);
  INSERT INTO facts(sentence) VALUES('{"mascot": "Our mascot is a dolphin named \\"Sakila\\"."}');
  ```

- JSON Object 조회

  ```sql
  SELECT sentence->"$.mascot" FROM facts;
  +---------------------------------------------+
  | sentence->"$.mascot"                        |
  +---------------------------------------------+
  | "Our mascot is a dolphin named \"Sakila\"." |
  +---------------------------------------------+

  SELECT sentence->>"$.mascot" FROM facts;
  +-----------------------------------------+
  | sentence->>"$.mascot"                   |
  +-----------------------------------------+
  | Our mascot is a dolphin named "Sakila". |
  +-----------------------------------------+
  ```

- JSON Array 조회

  ```sql
  SELECT id FROM (
      SELECT id, json_contains(sentence, json_array('a')) AS rst FROM facts
  ) A
  WHERE rst > 0;
  +--+
  |id|
  +--+
  |3 |
  |5 |
  +--+

  SELECT * from facts f
  WHERE JSON_CONTAINS(sentence , '"a"', '$');

  SELECT * from facts f
  WHERE JSON_CONTAINS(sentence , '1', '$');
  ```

## Naming Conventions

### 공통

1. 소문자를 사용한다.
1. 단어를 임의로 축약하지 않는다.
   - register_date (O) / reg_date (X)
1. 가능하면 약어의 사용을 피한다.
   - 약어를 사용해야 하는 경우, 약어 역시 소문자를 사용한다.
1. 동사는 능동태를 사용한다.
   - register_date (O) / registered_date (X)

### TABLE

1. 복수형을 사용한다.
1. 이름을 구성하는 각각의 단어를 underscore 로 연결하는 snake case 를 사용한다.
1. 교차 테이블 (many-to-many) 의 이름에 사용할 수 있는 직관적인 단어가 있다면 해당 단어를 사용한다.
   - 적절한 단어가 없다면 relationship을 맺고 있는 각 테이블의 이름을 "_and_" 또는 "_has_" 로 연결한다.
1. 예
   - articles, movies : 복수형
   - vip_members : 약어도 예외 없이 소문자 & 단어의 연결에 underbar를 사용
   - articles*and_movies : 교차 테이블을 "\_and*" 로 연결

### COLUMN

1. auto increment 속성의 PK를 대리키로 사용하는 경우, "테이블 이름의 단수형"\_id 의 규칙으로 명명한다.
1. 이름을 구성하는 각각의 단어를 underscore 로 연결하는 snake case 를 사용한다.
1. foreign key 컬럼은 부모 테이블의 primary key 컬럼 이름을 그대로 사용한다.
   - self 참조인 경우, primary key 컬럼 이름 앞에 적절한 접두어를 사용한다.
   - 같은 primary key 컬럼을 자식 테이블에서 2번 이상 참조하는 경우, primary key 컬럼 이름 앞에 적절한 접두어를 사용한다.
1. boolean 유형의 컬럼이면 "\_flag" 접미어를 사용한다.
1. date, datetime 유형의 컬럼이면 "\_date" 접미어를 사용한다.
1. 예
   - article_id, movie_id : "테이블 이름의 단수형" + "\_id"
   - complete_flag : boolean 유형의 컬럼
   - issue_date : 날짜 유형의 컬럼

### INDEX

1. 이름을 구성하는 각각의 단어를 hyphen 으로 연결하는 snake case 를 사용한다.
1. 접두어
   - unique index : uix
   - spatial index : six
   - index : nix
1. "접두어"-"테이블 이름"-"컬럼 이름"-"컬럼 이름"
1. 예
   - uix-accounts-login_email

### FOREIGN KEY

1. 이름을 구성하는 각각의 단어를 hyphen 으로 연결하는 snake case 를 사용한다.
1. "fk"-"부모 테이블 이름"-"자식 테이블 이름"
   - 같은 부모-자식 테이블에 2개 이상의 foreign key가 있는 경우, numbering합니다.
1. 예
   - fk-movies-articles : article 테이블이 movie 테이블을 참조
   - fk-admins-notices-1 / fk-admins-notices-2 : notices 테이블이 admins 테이블을 2회 이상 참조하여 numbering

### VIEW

1. 접두어 "v"를 사용한다.
1. 기타 규칙은 TABLE과 동일
1. 예
   - v_privileges

### FUNCTION

1. 접두어 "usf"를 사용한다.
1. 이름을 구성하는 각각의 단어를 underscore 로 연결하는 snake case 를 사용한다.
1. 예
   - usf_random_key

### TRIGGER

1. 이름을 구성하는 각각의 단어를 underscore 로 연결하는 snake case 를 사용한다.
1. 접두어
   - tra : AFTER 트리거
   - trb : BEFORE 트리거
1. "접두어"_"테이블 이름"_"트리거 이벤트"
1. 예
   - tga_movies_ins : AFTER INSERT 트리거
   - tga_movies_upd : AFTER UPDATE 트리거
   - tgb_movies_del : BEFORE DELETE 트리거

## AUTO_INCREMENT

### AUTO_INCREMENT prefix

- 하나의 컬럼에 접두사를 넣을수는 없으나 컬럼 두개를 이용하면 가능 합니다.
- MyISAM ENGINE으로 가능합니다.

  ```sql
  CREATE TABLE animals (
      grp ENUM('fish','mammal','bird') NOT NULL,
      id MEDIUMINT NOT NULL AUTO_INCREMENT,
      name CHAR(30) NOT NULL,
      PRIMARY KEY (grp,id)
  ) ENGINE=MyISAM;

  INSERT INTO animals (grp,name) VALUES
      ('mammal','dog'),('mammal','cat'),
      ('bird','penguin'),('fish','lax'),('mammal','whale'),
      ('bird','ostrich');

  SELECT * FROM animals ORDER BY grp,id;
  ```

### AUTO_INCREMENT multi

- AUTO_INCREMENT prefix 의 ENUM 설정을 Integer로 사용하면 가능하나 숫자는 직접 입력해야 합니다.

## Index

### Create index

```sql
CREATE TABLE `salaries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `emp_no` int(11) NOT NULL,
  `salary` int(11) NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `is_bonus` tinyint(1) unsigned zerofill DEFAULT NULL,
  `group_no` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE INDEX IDX_SALARIES_INCREASE ON salaries
(is_bonus, from_date, group_no);

CREATE INDEX IDX_SALARIES_DECREASE ON salaries
(group_no, from_date, is_bonus);
```

### Explain index

```sql
explain select * from facts f where id=1;
```

### Show index

```sql
SHOW INDEX FROM test;
SHOW INDEX FROM facts;
```

### Drop index

```sql
ALTER TABLE books DROP INDEX idx_test;
```

### Tip

- 인덱스가 없는 컬럼을 조건으로 update, delete를 하게 되면 굉장히 느려 많은 양의 데이터를 삭제 해야하는 상황에선 인덱스로 지정된 컬럼을 기준으로 진행하는것을 추천드립니다.
- 인덱스의 키는 길면 길수록 성능상 이슈가 있습니다.
- 카디널리티가 높은순에서 낮은순으로 구성하는게 더 성능이 뛰어납니다.
- 조회 쿼리 사용시 인덱스를 태우려면 최소한 첫번째 인덱스 조건은 조회조건에 포함되어야만 합니다.

## ENGINE

- SHOW ENGINES

  ```sql
  SHOW ENGINES;

  |------------------|-------|--------------------------------------------------------------|------------|---|----------|
  |Engine            |Support|Comment                                                       |Transactions|XA |Savepoints|
  |------------------|-------|--------------------------------------------------------------|------------|---|----------|
  |InnoDB            |DEFAULT|Supports transactions, row-level locking, and foreign keys    |YES         |YES|YES       |
  |MRG_MYISAM        |YES    |Collection of identical MyISAM tables                         |NO          |NO |NO        |
  |MEMORY            |YES    |Hash based, stored in memory, useful for temporary tables     |NO          |NO |NO        |
  |BLACKHOLE         |YES    |/dev/null storage engine (anything you write to it disappears)|NO          |NO |NO        |
  |MyISAM            |YES    |MyISAM storage engine                                         |NO          |NO |NO        |
  |CSV               |YES    |CSV storage engine                                            |NO          |NO |NO        |
  |ARCHIVE           |YES    |Archive storage engine                                        |NO          |NO |NO        |
  |PERFORMANCE_SCHEMA|YES    |Performance Schema                                            |NO          |NO |NO        |
  |FEDERATED         |NO     |Federated MySQL storage engine                                |            |   |          |
  |------------------|-------|--------------------------------------------------------------|------------|---|----------|
  ```

- 가장 많이 쓰이는 엔진

  - InnoDB : 따로 스토리지 엔진을 명시하지 않으면 default 로 설정되는 스토리지 엔진이다. InnoDB는 transaction-safe 하며, 커밋과 롤백, 그리고 데이터 복구 기능을 제공하므로 데이터를 효과적으로 보호 할 수 있다.<br />
    InnoDB는 기본적으로 row-level locking 제공하며, 또한 데이터를 clustered index에 저장하여 PK 기반의 query의 I/O 비용을 줄인다. 또한 FK 제약을 제공하여 데이터 무결성을 보장한다.<br />
    <br />
  - MyISAM : 트랜잭션을 지원하지 않고 table-level locking을 제공한다. 따라서 multi-thread 환경에서 성능이 저하 될 수 있다. 특정 세션이 테이블을 변경하는 동안 테이블 단위로 lock이 잡히기 때문이다.<br />
    텍스트 전문 검색(Fulltext Searching)과 지리정보 처리 기능도 지원되는데, 이를 사용할 시에는 파티셔닝을 사용할 수 없다는 단점이 있다.<br />
    <br />
  - Archive : '로그 수집'에 적합한 엔진이다. 데이터가 메모리상에서 압축되고 압축된 상태로 디스크에 저장이 되기 때문에 row-level locking이 가능하다.<br />
    다만, 한번 INSERT된 데이터는 UPDATE, DELETE를 사용할 수 없으며 인덱스를 지원하지 않는다. 따라서 거의 가공하지 않을 원시 로그 데이터를 관리하는데에 효율적일 수 있고, 테이블 파티셔닝도 지원한다. 다만 트랜잭션은 지원하지 않는다.<br />

## CHARSET

- SHOW CHARSET

```sql
SHOW CHARSET;
```

### latin1 (2바이트)

### utf8 (가변3바이트)

### utf8mb4 (가변4바이트)

## Collation

- Collation 은 텍스트 데이터를 정렬(ORDER BY)할 때 사용한다. 즉 text 계열 자료형에서만 사용할 수 있는 속성이다.

```sql
CREATE TABLE `EMP_ATTEND` (
    `ATTEND_YMD` VARCHAR(8) NOT NULL COLLATE 'utf8_bin',
    `EMP_NO` VARCHAR(9) NOT NULL COLLATE 'utf8_bin'
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB;
```

### utf8_bin (or utf8mb4_bin)

- 바이너리 저장 값 그대로 정렬한다.
- hex 코드(16진수)로 A 는 41, B 는 42, a 는 61, b 는 62 이기 때문에 다음 순서로 출력된다.

### utf8_general_ci (or utf8mb4_general_ci)

- 텍스트 정렬할 때 a 다음에 b 가 나타나야 한다는 생각으로 나온 정렬방식. 일반적으로 널리 사용된다.
- 라틴계열 문자를 사람의 인식에 맞게 정렬한다.
- 바이너리를 한번 가공한 것이다.

### utf8_unicode_ci (or utf8mb4_unicode_ci)

- general_ci 보다 조금 더 사람에 맞게 정렬한다.
- 한국어, 영어, 중국어, 일본어 사용환경에서는 general_ci 와 unicode_ci 의 결과가 동일하다.
- 뭔가 더 특수한 문자의 정렬 순서가 변경된다.

### Recommend

- 다음은 권장하는 charset 과 collation 설정 값이다.
  1. MySQL 5.5.3 이전 = utf8 charset 에, utf8_general_ci collation 사용.
  2. MySQL 이 최신일 때 = utf8mb4 charset 에, utf8mb4_unicode_ci collation 사용.

## Procedure

### Example

- Create table

  ```sql
  CREATE TABLE `test_reviews` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `p_id` int(10) unsigned,
  `b_id` varchar(25),
  `memo` varchar(255),
  `dt` timestamp DEFAULT CURRENT_TIMESTAMP,
  primary key(`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8
  ```

- Create procedure

  ```sql
  DROP PROCEDURE IF EXISTS proc_review_data_insert;

  CREATE PROCEDURE proc_review_data_insert()
  BEGIN
      declare v_max INTEGER DEFAULT 1000000;
      declare v_num INTEGER DEFAULT 1;
      declare v_p_id INTEGER DEFAULT 0;
      declare v_b_id varchar(25) DEFAULT 'board';

      while v_num < v_max do
          insert into test_reviews(p_id, b_id, memo) values (CEIL(v_num/10), concat(v_b_id, CEIL(v_num/50)), concat('test - ', v_num) );

          set v_num = v_num + 1;
      end while;

      update test_reviews
      set p_id = 1
      where id = p_id;

      update test_reviews
      set p_id = 0
      where id = 1;

  END;
  ```

- Call procedure

  ```sql
  call proc_review_data_insert();
  ```

## Function

### Example

- Create function

  ```sql
  DROP FUNCTION IF EXISTS fnc_reveiw_hierarchi;

  CREATE FUNCTION  fnc_reveiw_hierarchi() RETURNS INT

  NOT DETERMINISTIC

  READS SQL DATA

  BEGIN

      DECLARE v_id INT;
      DECLARE v_parent INT;
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET @id = NULL;

      SET v_parent = @id;
      SET v_id = -1;

      IF @id IS NULL THEN
          RETURN NULL;
      END IF;

      LOOP

      SELECT MIN(id)
      INTO @id
      FROM test_reviews
      WHERE p_id = v_parent
      AND id > v_id;

      IF (@id IS NOT NULL) OR (v_parent = @start_with) THEN
      SET @level = @level + 1;
      RETURN @id;
      END IF;

      SET @level := @level - 1;

      SELECT id, p_id
      INTO v_id , v_parent
          FROM test_reviews
      WHERE id = v_parent;

      END LOOP;

  END
  ```

- Call function
  ```sql
  SELECT
      CASE WHEN LEVEL-1 > 0 then CONCAT(CONCAT(REPEAT('    ', level  - 1),'┗'), ani.memo)
          ELSE ani.memo
      END AS memo
      , ani.id
      , ani.p_id
      , fnc.level
      , fnc.rnum
  -- 	, ani.pv
  FROM (
      SELECT
          fnc_reveiw_hierarchi() AS id, @level AS level, @rownum := @rownum+1 AS rnum
      FROM (SELECT @start_with:=0, @id:=@start_with, @level:=0) vars
      JOIN test_reviews
      JOIN (SELECT @rownum :=0) AS r
      WHERE @id IS NOT NULL
  ) AS fnc
  JOIN (
  select id, p_id, memo, @pv as pv
      from (
          select * from test_reviews,
          (select @pv := 10) init
      ) a
      where   find_in_set(p_id, @pv)
      and     length(@pv := concat(@pv, ',', id))
  ) ani on fnc.id = ani.id
  order by rnum
  ;
  ```

## Load file

### Example

- Create table

  ```sql
  CREATE TABLE `test_reviews` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `p_id` int(10) unsigned,
  `b_id` varchar(25),
  `memo` varchar(255),
  `dt` timestamp DEFAULT CURRENT_TIMESTAMP,
  primary key(`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8
  ```

- CSV

  ```js
  id, p_id, b_id, memo, dt;
  1, 1, 'board1', 'test - 1', NULL;
  2, 1, 'board1', 'test - 2', NULL;
  3, 1, 'board1', 'test - 3', NULL;
  4, 1, 'board1', 'test - 4', NULL;
  5, 1, 'board1', 'test - 5', NULL;
  6, 1, 'board1', 'test - 6', NULL;
  7, 1, 'board1', 'test - 7', NULL;
  8, 1, 'board1', 'test - 8', NULL;
  9, 1, 'board1', 'test - 9', NULL;
  ```

- Query
  ```sql
  LOAD DATA LOCAL INFILE '/Users/whitexozu/dev/temp/review.csv' INTO TABLE mcs.test_reviews
  FIELDS TERMINATED BY ',' ENCLOSED BY '"'
  IGNORE 1 LINES;
  ```

### Error

- ERROR 1290 (HY000): The MySQL server is running with the --secure-file-priv option so it cannot execute this statement

  에러 발생시 secure_file_priv에 특정 경로가 설정되어있어서 해당 경로에 파일만 import 할 수 있습니다.
  해당 경로에 파일을 넣거나 경로를 삭제하여 모든 경로에 파일을 import 할 수 있도록 하는 방법이 있습니다.
  후자가 좋을거 같습니다.

  1. 경록 확인

     ```
     mysql> SELECT @@GLOBAL.secure_file_priv;
     +---------------------------+
     | @@GLOBAL.secure_file_priv |
     +---------------------------+
     | /var/lib/mysql-files/     |
     +---------------------------+
     ```

  1. 설정 변경

     ```bash
     $ sudo vi /etc/my.cnf

     [mysqld]
     secure-file-priv=""
     ```

  1. MySQL 재시작
     ```bash
     $ sudo systemctl restart mysqld
     ```

## 참고사이트

```yaml
Numeric Types: http://tcpschool.com/mysql/mysql_datatype_numeric
Data Types: https://dev.mysql.com/doc/refman/8.0/en/integer-types.html
Naming Conventions: https://purumae.tistory.com/200
Index: https://jojoldu.tistory.com/243
Charset, Collation: https://sshkim.tistory.com/128
Create Functoin: https://shlee0882.tistory.com/242
  https://m.blog.naver.com/PostView.nhn?blogId=sthwin&logNo=221150189755&proxyReferer=https%3A%2F%2Fwww.google.com%2F
```

```toc

```
