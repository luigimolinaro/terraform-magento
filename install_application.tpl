#!/usr/bin/env bash

########################################################################################################################
# Installazione Magento2
########################################################################################################################

#Output verboso
set -x

#----------->  TOOLS-COMMON

apt-get --allow-downgrades --allow-remove-essential --allow-change-held-packages dist-upgrade --yes
#apt-get dist-upgrade --force-yes

apt-add-repository ppa:ansible/ansible

apt-get install \
    htop \
    git \
    vim \
    curl \
    software-properties-common \
    ansible \
    unzip \
    build-essential \
    s3fs \
    cowsay \
    --yes

#refresh path
hash -r

############# TUNING

  #SWAP
  echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf

  #CACHE COMPOSER
  mkdir -p /var/www/cache/composer
  export COMPOSER_HOME=/var/www/cache/composer/

cat <<EOF >> /home/ubuntu/.bashrc
 parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
 }
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
EOF

cat <<EOF >> /home/ubuntu/.vimrc
:set nu
EOF


#-----------> SSH-KEYS
# Set your ssh-key

#-----------> NGINX+PHP

ansible-galaxy install geerlingguy.nginx
ansible-galaxy install chusiang.php7

cat <<EOF > /etc/ansible/owl.plb
---
- hosts: localhost
  remote_user: root
  roles:
     - chusiang.php7
     - geerlingguy.nginx
  vars:
  # nginx_vhosts:
  # - listen: 80
  #   server_name : "luigi.it"
  #   server_name_redirect : "www.luigi.it"
  #   root: "/var/www/html"
  #   index: "index.html index.php"
  #   filename: "ciao.conf"
   nginx_upstreams:
   - name: php71
     strategy: "ip_hash" # "least_conn", etc.
     keepalive: 16 # optional
     servers: {
       "unix:/run/php/php7.1-fpm.sock"
     }
EOF

ansible-playbook /etc/ansible/owl.plb

#----------->  COMPOSER

wget https://getcomposer.org/composer.phar -O /usr/local/bin/composer
chmod 777 /usr/local/bin/composer

#----------->  N98MAGERUN

wget https://files.magerun.net/n98-magerun2.phar -O /usr/local/bin/n98magerun2
chmod 777 /usr/local/bin/n98magerun2

#Stampo e salvo le informazioni
echo "MAGENTO_DATABASE_HOST: ${MAGENTO_DATABASE_HOST}" > /root/magento-install
echo "MAGENTO_DATABASE_NAME: ${MAGENTO_DATABASE_NAME}" >> /root/magento-install
echo "MAGENTO_DATABASE_USER: ${MAGENTO_DATABASE_USER}" >> /root/magento-install
echo "MAGENTO_DATABASE_PASSWORD: ${MAGENTO_DATABASE_PASSWORD}" >> /root/magento-install
echo "MAGENTO_BASE_URL: ${MAGENTO_DATABASE_PASSWORD}" >> /root/magento-install
echo "REDIS: ${MAGENTO_REDIS_HOST_NAME}" >> /root/magento-install


sudo -u www-data php bin/magento setup:upgrade
sudo -u www-data php bin/magento setup:di:compile
sudo -u www-data php bin/magento setup:static-content:deploy en_US it_IT
sudo -u www-data php bin/magento app:config:import
sudo -u www-data php bin/magento cache:clean && php bin/magento cache:flush

#-----------> RESTART SERVICE
service nginx restart
service php7.1-fpm restart
