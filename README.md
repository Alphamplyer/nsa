# Project NSA

# Gitlab

Indentifier: root (can be configured)
Password: configured in `./repository/setup/gitlab/env.json`.  

URL of the Gitlab instance: localhost:8000

## How to locally run mysql instance:

```bash
# Install ansible galaxy mysql package
ansible-playbook -i ./ansible_inventory.ini exploit/mysql/deploy-mysql.yml
```

## Setup on your machine

run theses commands to test locally : 
```
ansible-galaxy install geerlingguy.composer
ansible-galaxy install geerlingguy.php
ansible-galaxy install geerlingguy.mysql
ansible-galaxy install geerlingguy.nginx
ansible-galaxy install geerlingguy.nodejs
ansible-galaxy install geerlingguy.git
```

Install jq to your machine before runing `start_all.sh` script
```
sudo apt install jq
```

## Setup repo

run : 
```./create_repository.sh```
