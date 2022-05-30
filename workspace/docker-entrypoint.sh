#!/bin/bash

# wait for mysql
while ! mysqladmin ping -h"mysql" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
  sleep 1
done

# run artisan scripts
pushd /var/www
  composer install
  make migrate
  make seed
popd

# start workspace process
/sbin/my_init
