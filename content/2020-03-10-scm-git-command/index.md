---
title: '[GIT] 명령어, 협업 방법'
date: 2020-03-10 08:05:34
author: TMM
categories: SCM
tags: Git
---

SVN을 주로쓰다가 Git을 처음 사용하게되면 개념잡는데 생각보다 많은 시간이 필요합니다.(제 이야기 입니다)<br />
Git을 SVN 처럼 사용하여 매번 충돌이 나고 충돌을 stach로만 처리하는 프로젝트도 본적이 있습니다.<br />
SVN은 trunk 밑에 하나의 repository를 만들에 모든 사용자들이 merge후 commit만 사용하는 비교적 단순한 방식이라면
Git은 merge또는 rebase후에 add, commit, push단계로 관리하고 다양한 의미에 branch를 만들어 사용 할 수 있는 복잡한 구조입니다.<br />
단, 모든 프로젝트를 복잡하게 관리할 필요는 없습니다. 프로젝트 규모와 목적에 맞는 규칙을 선택해서 사용하는것을 추천드립니다.<br />
<br />

## 개념잡기

### add, commit, push

실제 파일에 수정이 이루어지는 `working directory`에서<br />
*add*룰 하게 되면 `index(staging area)`로 넘어가게 됩니다.<br />
*commit*을 하게되면 `HEAD`으로 넘어가 최종 확장본이 생성됩니다.<br />
*push*를 통해 `remote(origin)` 원격저장소에 반영 하게 됩니다.

### merge, rebase

merge를 사용할 지, Rebase를 사용할 지는 프로젝트의 히스토리를 어떻게 관리할지에 따라 선택됩니다.<br />
merge의 경우 병합되는 브런치의 모든 작업 내용을 기록하게 됩니다.<br />
Rebase의 경우 다른 브랜치는 없었던 것처럼 작업 내용이 하나의 흐름으로 기록됩니다.<br />

## git 연걸

### 원격지 변경

```bash
$ git remote remove origin
$ git remote add origin https://github.com/...
```

### 원격지 branch checkout

```bash
# 원격 브런치 접근을 위해 git remote를 갱신 합니다.
$ git remote update

# 원격 저장소의 branch list 확인 합니다.
$ git branch -r

# -a 옵션을 주면 로컬, 원격 모든 저장소의 branch 리스트를 볼 수 있습니다.
$ git branch -a

# 원격저장소의 branch를 가져옵니다.
$ git checkout -t origin/[branch name]
```

**Note:**<br />
branch를 참고만 할 뿐 수정 내용을 원격 저장소에 push 하지 않을 경우 _$ git checkout [원격 저장소의 branch 이름]_ 옵션이 없는 명령어로 checkout 하면 ‘detached HEAD’ 상태의 소스를 확인 및 수정 할 수는 있지만 변경사항들을 commit, push 할 수 없으며 다른 branch로 checkout하면 사라지게 됩니다.
{: .notice--info}

## 명령어

### git merge

- 다른 branch 수정 사항을 가져올때 사용, 이력이 남음

```bash
$ git branch issue1 (branch 생성)
$ git branch  (branch 목록 확인)
$ git checkout issue1 (branch 이동)
# issue1 수정
$ git add .
$ git commit -m "comment"
$ git checkout master
$ git merger issue1
$ git branch -d issue1
$ git branch
```

### git rebase

- 다른 branch 수정 사항을 가져올때 사용, 이력이 남지 않음

```bash
$ git chekcout -b issue1 # branch 생성과 checkout 을 한번에 하기위해 -b 옵션 사용
# issue1 수정 후 push
# master 수정 후 push (pc가 다른경우 master 수정사항 pull, issue1 수정사항 pull)
$ git chekcout issue1
$ git rebase master
$ git checkout maser
$ git merge issue1
```

### 한 branch에서 merge

```bash
$ git add, git commit
$ git pull origin
$ git merge

# 비 충돌시
$ git push origin

# 충돌시 충돌 내용 정리 후
$ git add, git commit
$ git push origin
```

## git log 정리 방법

### git CRLF 개행 문자 통일

```bash
$ git config --global core.eol lf
$ git config --global core.autocrlf input
$ git config --global core.autocrlf true
```

### add alias git log

```bash
$ git config --global alias.lg "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold red)%h%C(reset) : %C(bold green)(%ar)%C(reset) - %C(cyan)<%an>%C(reset)%C(bold yellow)%d%C(reset)%n%n%w(90,1,2)%C(white)%B%C(reset)%n'"

$ git lg
$ git log
$ git log --oneline
```

### 아직 push되지 않은 commit 목록 보기

```bash
$ git log --branches --not --remotes
```

### git에서 특정 commit의 변경된 파일 목록 보기

```bash
$ git log --name-only -1
```

## branch 의미

### Master Branch

_제품으로 출시될 수 있는 브랜치_

- 배포(Release) 이력을 관리하기 위해 사용. 즉, 배포 가능한 상태만을 관리한다.

### Develop Branch

_다음 출시 버전을 개발하는 브랜치_

- 기능 개발을 위한 브랜치들을 병합하기 위해 사용. 즉, 모든 기능이 추가되고 버그가 수정되어 배포 가능한 안정적인 상태라면 develop 브랜치를 ‘master’ 브랜치에 병합(merge)한다.
- 평소에는 이 브랜치를 기반으로 개발을 진행한다.

### Feature branch

_기능을 개발하는 브랜치_

- feature 브랜치는 새로운 기능 개발 및 버그 수정이 필요할 때마다 ‘develop’ 브랜치로부터 분기한다. feature 브랜치에서의 작업은 기본적으로 공유할 필요가 없기 때문에, 자신의 로컬 저장소에서 관리한다.
- 개발이 완료되면 ‘develop’ 브랜치로 병합(merge)하여 다른 사람들과 공유한다.

### Release Branch

_이번 출시 버전을 준비하는 브랜치_

- 배포를 위한 전용 브랜치를 사용함으로써 한 팀이 해당 배포를 준비하는 동안 다른 팀은 다음 배포를 위한 기능 개발을 계속할 수 있다. 즉, 딱딱 끊어지는 개발 단계를 정의하기에 아주 좋다.

### Hotfix Branch

_출시 버전에서 발생한 버그를 수정 하는 브랜치_

- 배포한 버전에 긴급하게 수정을 해야 할 필요가 있을 경우, ‘master’ 브랜치에서 분기하는 브랜치이다. ‘develop’ 브랜치에서 문제가 되는 부분을 수정하여 배포 가능한 버전을 만들기에는 시간도 많이 소요되고 안정성을 보장하기도 어려우므로 바로 배포가 가능한 ‘master’ 브랜치에서 직접 브랜치를 만들어 필요한 부분만을 수정한 후 다시 ‘master’브랜치에 병합하여 이를 배포해야 하는 것이다.

## 협업 방법

### Feature Branch Workflow

_소규모의 프로젝트에서 많이 사용하는 방식_

### Forking Workflow

_오픈 소스 프로젝트에서 많이 사용하는 방식_

### Gitflow Workflow

_대규모의 프로젝트에서 사용하는 엄격한 방식_

## 참고사이트

```yaml
git 간편 안내서: https://rogerdudler.github.io/git-guide/index.ko.html
git commit message: https://djkeh.github.io/articles/How-to-write-a-git-commit-message-kor/
git remote branch: https://cjh5414.github.io/get-git-remote-branch/
merge vs rebase: https://velog.io/@godori/Git-Rebase
branch 설명: https://gmlwjd9405.github.io/2018/05/11/types-of-git-branch.html
Feature Branch Workflow: https://gmlwjd9405.github.io/2017/10/27/how-to-collaborate-on-GitHub-1.html
Forking Workflow: https://gmlwjd9405.github.io/2018/05/12/how-to-collaborate-on-GitHub-3.html
Gitflow Workflow: https://gmlwjd9405.github.io/2017/10/28/how-to-collaborate-on-GitHub-2.html
git add, commit, pusho 취소: https://gmlwjd9405.github.io/2018/05/25/git-add-cancle.html
```

```toc

```
