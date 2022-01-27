#!/bin/bash

build_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

gitlab_password=$(cat ${build_dir}/repository/setup/gitlab/env.json | jq -r '.ROOT_PASSWORD')

vagrant upload ${build_dir}/repository /home/vagrant/nsa gitlab

vagrant ssh gitlab << EOF
cd /home/vagrant/nsa
git init
git add .
git config --global user.email "push-bot@nsa.com"
git config --global user.name "Push Bot"
git commit -m "Initial Auto Commit"
git remote add origin http://localhost/root/nsa.git
git push -u http://root:${gitlab_password}@localhost/root/nsa.git master
EOF