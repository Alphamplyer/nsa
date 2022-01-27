echo --- Installing Requirements ---------------------------------------------------
sudo apt-get install
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq curl openssh-server ca-certificates postfix git make build-essential unzip gnupg python3 python3-pip

# Install ansible globally
sudo pip3 install -r requirements.txt
source /home/vagrant/.bashrc
ansible-galaxy install geerlingguy.git
ansible-galaxy install geerlingguy.php
ansible-galaxy install geerlingguy.mysql
ansible-galaxy install geerlingguy.composer
ansible-galaxy install geerlingguy.nginx
ansible-galaxy install geerlingguy.nodejs

# Install node, install php, install laravel, install composer dependencies

# install nodeJS
curl -sL https://deb.nodesource.com/setup_11.x | sudo bash -
sudo apt-get -y install nodejs
sudo npm install -g yarn

# install php
wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
sudo echo "deb https://packages.sury.org/php/ buster main" | sudo tee -a /etc/apt/sources.list.d/php.list
sudo apt-get update
sudo apt-get install -y php7.1-fpm php7.1-curl php7.1-xml php7.1-zip

# install composer + install laravel dependencies
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# install google-chrome dependencies
sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install google-chrome-stable

echo --- Installing GitLab CE ------------------------------------------------------
echo "gitlab_rails['initial_root_password'] = '${ROOT_PASSWORD}'" >> /tmp/gitlab.rb
echo "gitlab_rails['initial_shared_runners_registration_token'] = '${CI_TOKEN}'" >> /tmp/gitlab.rb
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo apt-get install -y gitlab-ce
mv /tmp/gitlab.rb /etc/gitlab/gitlab.rb
sudo gitlab-ctl reconfigure
sudo gitlab-ctl status

echo --- Runner --------------------------------------------------------------------
curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_$(dpkg --print-architecture).deb"
dpkg -i gitlab-runner_$(dpkg --print-architecture).deb

sudo gitlab-runner register \
  --non-interactive \
  --url ${GITLAB_RUNNER_URL} \
  --registration-token ${CI_TOKEN} \
  --executor "shell" \
  --description "Gitlab Runner"
