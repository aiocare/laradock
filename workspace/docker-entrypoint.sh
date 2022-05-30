#!/bin/bash

CONTAINER_FIRST_STARTUP="CONTAINER_FIRST_STARTUP"
if [ ! -e /$CONTAINER_FIRST_STARTUP ]; then
    touch /$CONTAINER_FIRST_STARTUP
    # wait for mysql
    echo "Waiting for MySQL connection"
    while ! mysqladmin ping -h"mysql" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
      sleep 1
    done

    # run artisan scripts
    pushd /var/www
      composer install
      make migrate
      make seed
    popd
else
    echo "No startup action"
    # script that should run the rest of the times
fi

# start workspace process
/sbin/my_init
