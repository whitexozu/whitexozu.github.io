#!/bin/bash

git --git-dir .git --work-tree=./ status
git --git-dir .git --work-tree=./ add .
git --git-dir .git --work-tree=./ commit -m "maybe add posts file"
git --git-dir .git --work-tree=./ push origin master

rm -rf ../whitexozu.github.io/*
cp -r _site/* ../whitexozu.github.io/

# git --git-dir ../whitexozu.github.io/.git branch
git --git-dir ../whitexozu.github.io/.git --work-tree=../whitexozu.github.io status
git --git-dir ../whitexozu.github.io/.git --work-tree=../whitexozu.github.io add .
git --git-dir ../whitexozu.github.io/.git --work-tree=../whitexozu.github.io commit -m "..."
git --git-dir ../whitexozu.github.io/.git --work-tree=../whitexozu.github.io push origin master

# git checkout source
# git branch -D master
# git checkout -b master
# git filter-branch --subdirectory-filter _site/ -f
# git push -f origin master
# git checkout source
# git push -f origin source