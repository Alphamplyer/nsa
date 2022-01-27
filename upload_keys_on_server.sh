#!/bin/bash

build_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

vagrant upload ${build_dir}/id_rsa /home/vagrant/id_rsa gitlab
vagrant upload ${build_dir}/id_rsa.pub /home/vagrant/id_rsa.pub gitlab
vagrant ssh gitlab << EOF
sudo mkdir -p /home/gitlab-runner/.ssh
sudo cp /home/vagrant/id_rsa /home/gitlab-runner/.ssh/id_rsa
sudo cp /home/vagrant/id_rsa.pub /home/gitlab-runner/.ssh/id_rsa.pub
cat /home/vagrant/id_rsa.pub | sudo tee -a /home/gitlab-runner/.ssh/authorized_keys > /dev/null

sudo ssh-keygen -f "/home/gitlab-runner/.ssh/known_hosts" -R 192.168.56.83
sudo ssh-keygen -f "/home/gitlab-runner/.ssh/known_hosts" -R 192.168.56.81
sudo ssh-keygen -f "/home/gitlab-runner/.ssh/known_hosts" -R 192.168.56.82
sudo touch /home/gitlab-runner/.ssh/known_hosts
sudo ssh-keyscan -t rsa -H 192.168.56.83 | sudo tee -a /home/gitlab-runner/.ssh/known_hosts > /dev/null
sudo ssh-keyscan -t rsa -H 192.168.56.82 | sudo tee -a /home/gitlab-runner/.ssh/known_hosts > /dev/null
sudo ssh-keyscan -t rsa -H 192.168.56.81 | sudo tee -a /home/gitlab-runner/.ssh/known_hosts > /dev/null

sudo chown -R gitlab-runner:gitlab-runner /home/gitlab-runner/.ssh
sudo chmod 600 /home/gitlab-runner/.ssh/id_rsa
EOF

vagrant upload ${build_dir}/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub database
vagrant ssh database -c "cd /home/vagrant/.ssh/ && cat id_rsa.pub >> authorized_keys"
vagrant upload ${build_dir}/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub frontend
vagrant ssh frontend -c "cd /home/vagrant/.ssh/ && cat id_rsa.pub >> authorized_keys"
vagrant upload ${build_dir}/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub backend
vagrant ssh backend -c "cd /home/vagrant/.ssh/ && cat id_rsa.pub >> authorized_keys"
