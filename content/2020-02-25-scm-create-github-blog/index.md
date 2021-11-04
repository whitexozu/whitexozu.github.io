---
title: '[Blog] GitHub에 blog 생성'
date: 2020-02-25 08:05:34
author: TMM
categories: SCM
tags: git blog
---

Tistory 에서 블로그 관리가 편하지 않네요. 미루고 미루던 일을 이제 해볼까 합니다. GitHub에 Jekyll과 minimal-mistakes 테마를 활용하여 블러그를 만들도록 하겠습니다.

## OS & App

```liquid
macOS Catalina 10.15.3
Ruby 2.6.3: 루비는 마츠모토 유키히로가 개발한 동적 객체 지향 스크립트 프로그래밍 언어입니다.
gem 3.0.8: RubyGems는 Ruby 프로그램 및 라이브러리 배포를위한 표준 형식, gem 설치를 쉽게 관리하도록 설계된 도구 및 배포 용 서버를 제공하는 Ruby 프로그래밍 언어의 패키지 관리자입니다.
jekyll 4.0.0: Jekyll은 개인, 프로젝트 또는 조직 사이트를위한 간단한 블로그 인식 정적 사이트 생성기입니다.
```

## Install

1. GitHub 에 Repository 생성 및 Clone
   1. github 에서 New Repository 클릭
   2. Repository name : [username].github.io
   3. Public 으로 생성
   4. git clone https://github.com/[username]/[username].github.io.git
2. Ruby Version Manager 설치
   ```bash
   $ curl -sSL https://get.rvm.io | bash -s stable --ruby
   ```
3. Teminal 재실행
4. Ruby 선택

   ```bash
   $ rvm list
   = ruby-2.6.3 [ x86_64 ]

   # => - current
   # =* - current && default
   #  * - default

   $ rvm use 2.6.3 --default
   $ ruby -v
   ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-darwin19]
   ```

5. Jekyll 설치
   ```bash
   $ gem install jekyll bundler
   $ jekyll -v
   jekyll 4.0.0
   ```
6. Jekyll default site 생성
   ```bash
   $ cd [username].github.io.git
   $ jekyll new ./
   $ bundle
   $ bundle exec jekyll serve
   ...
   Server address: http://127.0.0.1:4000/
   Server running... press ctrl-c to stop.
   ...
   ```
7. GitHub 에 반영
   ```bash
   $ git add .
   $ git commit -m "first commit"
   $ git push origin master
   ```
8. web site 확인
   ```
   https://[username].github.io/
   ```

**Note:**<br />
위의 내용으로 `GitHub [username].github.io` 에 반영하면 깔끔하게 잘 나옵니다.<br />
그러나 이후 테마가 적용된 소스를 GitHub 에 커밋하면 404 페이지가 나옵니다.<br />
원인은 불확실하나 처리 방법은 테마 적용후 Jekyll 서버를 기동하면 컴파일된 소스들이 `_site` 폴더에 생성되는데 생성된 파일을 `GitHub [username].github.io master` 에 올리면 정상적으로 페이지가 나옵니다.<br />
그래서 소스 파일 관리는 `GitHub [username].github.source` Repository 에서, 배포는 `GitHub [username].github.io` Repository 에 하도록 하겠습니다.
{: .notice--info}

## Apply theme

1. GitHub 에 Repository 생성 및 Clone
   1. github 에서 New Repository 클릭
   2. Repository name : [username].github.source
   3. git clone https://github.com/[username]/[username].github.source.git
2. GitHub 에서 테마 다운로드
   - Jekyll theme 중 가장 많이 다운받는 [minimal-mistakes](https://github.com/mmistakes/minimal-mistakes) 에서 압축파일을 다운받아 풀고 **[username].github.source** 폴더에 복사합니다.
3. 커스터마이징
   ```
   _config.yml: 파일에는 테마 스킨, locale 선택, 블로그 정보, 사용자 정보, 검색 등의 정보를 설정 합니다.
   _data/navigation.yml: 네이게이션, 사이드바 정보를 설정 합니다.
   _posts: 블로그 게시글들 입니다.
   ```
4. 중요 폴더 복사
   - `docs/_pages` 폴더를 최상위 폴더로 복사합니다. 그럼 게시글들을 year, categorise, tags 단위로 그룹지어서 볼수있습니다.
   - `docs/_posts` 에 글들을 참고하여 최상위 폴더인 `_posts` 에 파일을 생성합니다. 파일 생성시에는 규칙이 있으며 생성된 파일들이 블로그의 게시글들이 됩니다. 자세한 내용은 링크를 참고바랍니다. 설명할게 너무 많아요.
5. 불필요한 폴더 목록
   ```
   /docs
   /test
   ```
6. 자동 배포

   - `[username].github.source` 의 `_site` 파일들을 `[username].github.io` 폴더로 복사후 GitHub 에 커밋까지 하려면 명령어를 조금 많이 입력해야 합니다. 귀찮습니다. 그래서 shell 파일을 만들려 합니다.

   ```bash
   $ cd [username].github.source

   $ bundle exec jekyll serve
   Ctrl + c

   $ vi publish.sh

       #!/bin/bash

       rm -rf ../[username].github.io/*
       cp -r _site/* ../[username].github.io/
       git --git-dir ../[username].github.io/.git --work-tree=../[username].github.io status
       git --git-dir ../[username].github.io/.git --work-tree=../[username].github.io add .
       git --git-dir ../[username].github.io/.git --work-tree=../[username].github.io commit -m "..."
       git --git-dir ../[username].github.io/.git --work-tree=../[username].github.io push origin master

   $ chmod 755 publish.sh
   $ ./publish.sh
   ```

7. web site 확인
   ```
   https://[username].github.io/
   ```

**Note:**<br />
`git filter-branch --subdirectory-filter _site/ -f` 명령어로 하나의 Repository 에서 관리를 할 수 있다고하는데 저는 잘 적용되지 않았습니다.<br />
혹시 이글을 보시는 분이 있다면 한번 도전해 보시기 바랍니다.<br />
참고했던 링크는 [여기](https://rainsound-k.github.io/jekyll-blog/2018/05/02/apply-custom-plugin.html)입니다.
{: .notice--info}

> https://poiemaweb.com/jekyll-basics > https://junhobaik.github.io/jekyll-apply-theme/ > https://rainsound-k.github.io/jekyll-blog/2018/05/02/apply-custom-plugin.html > https://jetalog.net/86

```toc

```
