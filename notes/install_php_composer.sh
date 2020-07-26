#!/bin/sh

PHP_BINARY=$(which php)

# Specify the correct directory of PHP
PHP_BINARY=/usr/local/php74/bin/php

EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
$PHP_BINARY -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

$PHP_BINARY -d pcre.jit=0 composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
exit $RESULT