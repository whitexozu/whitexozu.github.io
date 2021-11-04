---
title: '[Jenkins] CentOS7 Jenkins 설정'
date: 2020-02-12 08:05:34
author: TMM
categories: CI
tags: Jenkins Springboot nodejs
---

### Global Tool Configuration

1.  Jenkins 관리 > Global Tool Configuration 이동
2.  JDK  
    Uncheck Install automatically  
    Name : jdk1.8  
    JAVA_HOME : /usr/local/java
3.  MAVEN  
    Uncheck Install automatically  
    Name : maven3.5.2  
    JAVA_HOME : /usr/local/maven
4.  NodeJS (nvm 사용시)  
    Uncheck Install automatically  
    Name : nodejs12.16.0  
    Installation directory : /home/whitexozu/.nvm/versions/node/v12.16.0

### Build 설정 (springboot)

1.  새로운 Item 클릭
2.  이름 및 타입 입력  
    Enter an item name 입력 (ex:build)  
    item 타입 선택 (Freestyle project)
3.  build 설정

    1.  General  
        GitHub project 선택  
        Project url : [https://github.com/whitexozu/Springboot-Example.git](https://github.com/whitexozu/Springboot-Example.git)
    2.  소스 코드 관리  
        Git 선택  
        Repositories > Credentials 의 Add 에서 Jenkins 선택 후 본인 github의 username/password 입력  
        Repositories > Repository URL : [https://github.com/whitexozu/Springboot-Example.git](https://github.com/whitexozu/Springboot-Example.git)  
        Repositories > Credentials : whitexozu/**\*\***  
        Repository browser : githubweb 선택  
        Repository browser > URL : [https://github.com/whitexozu/Springboot-Example.git](https://github.com/whitexozu/Springboot-Example.git)
    3.  빌드유발
        > [https://kutar37.tistory.com/entry/Jenkins-Github-%EC%97%B0%EB%8F%99-%EC%9E%90%EB%8F%99%EB%B0%B0%ED%8F%AC-3](https://kutar37.tistory.com/entry/Jenkins-Github-%EC%97%B0%EB%8F%99-%EC%9E%90%EB%8F%99%EB%B0%B0%ED%8F%AC-3)
    4.  Build  
        kill spring boot tomcat of local server > make jar > run spring boot tomcat 총 3단계로 진행

        1.  shell 파일 생성  
            /var/lib/jenkins/workspace/springboot-test/start.sh

            ```bash
             #!/bin/sh

             BUILD_ID=dontKillMe nohup /usr/local/java/bin/java -jar /var/lib/jenkins/workspace/springboot-test/Springboot-Swagger2/target/springboot-swagger2-0.0.1-SNAPSHOT.jar -server > /var/lib/jenkins/workspace/springboot-test/logs/springboot-swagger2.log &
             echo 'springboot-swagger2 is running on the server...'
            ```

            _로컬 서버에서 서버기동시 정상적으로 작동하지 않는 이슈가 발생, 원인은 젠킨스 빌드 종료시 진행중인 프로세스가 모두 종료되어 nohup 같은 명령어가 정상적으로 작동하지않는 문제가 있다, 그래서 기동 명령에 BUILD_ID=dontKillMe 를 붙여 주어야 한다._

            > [https://jang8584.tistory.com/248](https://jang8584.tistory.com/248)

            /var/lib/jenkins/workspace/springboot-test/stop.sh

            ```bash
             #!/bin/sh

             kill -15 ` ps -ef | grep springboot-swagger2 | grep -v grep | grep -v tail | awk '{ print $2 }'`
             echo "springboot-swagger2 has been shutdown..."
            ```

        2.  build 명령어 등록
            1.  Add build step > Execute shell 선택  
                Command : /var/lib/jenkins/workspace/springboot-test/start.sh
            2.  Add build step > Invork top-level Maven targets 선택  
                Invork top-level Maven targets > Maven Version : Global Tool Configuration 에서 입력한 maven name 선택  
                Goals : -f /var/lib/jenkins/workspace/springboot-test/Springboot-Swagger2 spring-boot:run
            3.  Add build step > Execute shell 선택  
                Command : /var/lib/jenkins/workspace/springboot-test/stop.sh

### Build 설정 (nodejs)

1.  새로운 Item 클릭
2.  이름 및 타입 입력  
    Enter an item name 입력 (ex:NodeJS-Build)  
    item 타입 선택 (Pipline)
3.  build 설정

    1.  General  
        GitHub project 선택  
        Project url : [https://github.com/whitexozu/Vue3-Koa-Scaffold.git](https://github.com/whitexozu/Vue3-Koa-Scaffold.git)
    2.  Pipeline

        ```
        pipeline {
        agent any

        tools {
            // Global Tool Configuration 에서 입력한 NodeJs 이름을 입력하면 npm 명령어 사용 가능
            nodejs "nodejs12.16.0"
        }

        stages {
            stage('Build') {
              steps {
                  // Kill process
                  //   pid 를 검색하여 kill 하는 경우 pid 가 있으면 괜찮으나 없는경우 에러 발생으로 이후 진행이 되지않음
                  //   - 2>&1 표준 출력으로 변경해도 해결 되지 않음
                  //     sh label: '', script: 'kill -15 $(ps aux | grep \'Koa-Backend\'| grep -v grep | grep -v tail | awk \'{print $2}\') > /dev/null 2>&1'
                  //   그래서 pid 가 있는 경우 kill 되록 처리
                  //   shell 작성 후 변경은 Pipeline Syntax 버튼을 클릭하여 Generate 하면 편하다
                  sh label: '', script: '''pname=\'Koa-Backend\'
                  pid=`ps -ef | grep $pname | grep -v grep | grep -v tail | awk \'{print $2}\'`
                  if [ $pid ];then
                    echo "process is running"
                    kill -15 $pid
                    echo "${pname} has been shutdown"
                  else
                    echo "process is not running"
                  fi'''
                  echo "Koa-Backend has been shutdown..."

                  // Get some code from a GitHub repository
                  git credentialsId: 'a02dc8c1-d07f-43c9-a225-844410db9031', url: 'https://github.com/whitexozu/Vue3-Koa-Scaffold.git'

                  // Run npm install
                  sh "cd Koa-Backend && npm i"
                  sh "cd Vue3-Frontend && npm i"

                  // Run npm build
                  sh "cd Vue3-Frontend && npm run build"

                  // Run npm serve
                  // 실패
                  //   jenkins가 설치된 서버에서 nodejs 서버 기등하는 방법을 찾을수가 없었음
                  //   - 외부 shell 파일을 실행해도 실패
                  //     sh "/var/lib/jenkins/workspace/start-nodejs.sh"
                  //   - BUILD_ID=dontKillMe 와 nohup 을 적용해도 실패
                  //     sh "BUILD_ID=dontKillMe cd Koa-Backend && BUILD_ID=dontKillMe nohup npm run serve > ../logs/Koa-Backend.log &"
                  //   - forever package 를 적용해도 실패
                  //     sh "cd Koa-Backend && forever start -a -l ../logs/forever.log -o ../logs/output.log -e ../logs/error.log src"
                  // echo "Koa-Backend is running on the server..."

              }
            }
        }
        }
        ```

### Build 실행

1.  My Views 클릭
2.  목록의 아이탬 클릭
3.  Build Now 클릭
4.  좌측 하단의 #num, 프로그래스바 클릭으로 Console Output 로그 확인

```toc

```
