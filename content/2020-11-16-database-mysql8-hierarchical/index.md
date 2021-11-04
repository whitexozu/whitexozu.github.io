---
title: '[MySQL8] 계층 구조의 데이터 활용'
date: 2020-11-16 08:05:34
author: TMM
categories: Database
tags: MySQL8, Hierarchical
---

공통코드관리, 조직관리 등 계층 구조 데이터를 관리하기 위해 사용되는 테이블 구조와 쿼리를 작성하겠습니다.<br />

## 테이블 생성

```sql
CREATE TABLE `tb_code` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(10) unsigned DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `menu_menu_idx_fk` (`pid`),
  CONSTRAINT `fk_code_code_id` FOREIGN KEY (`pid`) REFERENCES `tb_code` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

## 테이버 입력

```sql
INSERT INTO chatbot.tb_code (id,pid,name,status) VALUES
(1,NULL,'과일',1)
,(2,1,'포도',1)
,(3,1,'귤',1)
,(4,1,'사과',1)
,(5,2,'청포도',1)
,(6,2,'거봉',1)
,(7,2,'머루포도',1)
,(8,3,'한라봉',1)
,(9,3,'천애향',1)
,(10,4,'홍옥',1)
;
INSERT INTO chatbot.tb_code (id,pid,name,status) VALUES
(11,4,'청사과',1)
,(13,NULL,'스포츠',1)
,(14,13,'야구',1)
,(15,13,'축구',1)
,(16,13,'배구',1)
,(17,14,'메이저리그',1)
,(18,14,'마이너리그',1)
,(19,14,'발야구',1)
,(20,15,'유럽축구',1)
,(21,15,'한국축구',1)
;
INSERT INTO chatbot.tb_code (id,pid,name,status) VALUES
(22,16,'남자배구',1)
,(23,16,'여자배구',1)
;
```

## 조회 쿼리

```sql
WITH RECURSIVE CTE AS (
SELECT
	id,
	ifnull( pid, 0 ) as pid,
	name,
	1 as level,
	cast(id as char) as ppid
FROM
	tb_code
where
-- 	pid IS NULL
-- 	pid = '3'
	id = '2'
AND status = '1'
UNION ALL
SELECT
	p.id,
	p.pid,
	p.name,
	1 + level AS level,
	if( cte.ppid = cast(p.pid as char), concat(cte.id, '-', p.id), concat(ppid, '-', p.id) ) as ppid
FROM
	tb_code p
INNER JOIN CTE ON
	p.pid= cte.id )
select
	ifnull( pid, '') as pid,
	id,
	name,
	level,
	ppid
FROM
	cte
-- WHERE
-- 	LEVEL < 3
ORDER BY ppid;
```

## 참고사이트

- [https://dus815.tistory.com/entry/mariadb-%EC%97%90%EC%84%9C-connected-by-%EB%A5%BC-%EC%8D%A8%EB%B3%B4%EC%9E%90](https://dus815.tistory.com/entry/mariadb-%EC%97%90%EC%84%9C-connected-by-%EB%A5%BC-%EC%8D%A8%EB%B3%B4%EC%9E%90)
- [https://bulkywebdeveloper.tistory.com/109](https://bulkywebdeveloper.tistory.com/109)

```toc

```
