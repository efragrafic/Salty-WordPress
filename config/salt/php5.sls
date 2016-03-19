# PHP5 modules and configuration
php7_pkgrepo:
  pkgrepo.managed:
    - name: deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main

php5:
  pkg.removed

php5.6-fpm:
  pkg.installed

php5.6-gd:
  pkg.installed

php5.6-mysql:
  pkg.installed

php5.6-json:
  pkg.installed

php5.6-mcrypt:
  pkg.installed

php5.6-curl:
  pkg.installed

php5.6-cli:
  pkg.installed

php-apc:
  pkg.installed

pecl-config:
  cmd.run:
    - name: pecl config-create /etc/php/5.6/ pecl.conf ; pecl -C /etc/php/5.6/pecl.conf config-set php_suffix 5.6 ; pecl -C /etc/php/5.6/pecl.conf config-set php_bin /usr/bin/php5.6
    - unless: ls /etc/php/5.6/pecl.conf

imagick:
  cmd.run:
    - name: yes '' | pecl -C /etc/php/5.6/pecl.conf install imagick ; echo "extension=imagick.so" > /etc/php/5.6/mods-available/imagick.ini ; ln -s /etc/php/5.6/mods-available/imagick.ini /etc/php/5.6/cli/conf.d/imagick.ini ; ln -s /etc/php/5.6/mods-available/imagick.ini /etc/php/5.6/fpm/conf.d/imagick.ini
    - unless: php5.6 -m | grep imagick

memcache:
  cmd.run:
    - name: yes '' | pecl -C /etc/php/5.6/pecl.conf install memcache ; echo "extension=memcache.so" > /etc/php/5.6/mods-available/memcache.ini ; ln -s /etc/php/5.6/mods-available/memcache.ini /etc/php/5.6/cli/conf.d/memcache.ini ; ln -s /etc/php/5.6/mods-available/memcache.ini /etc/php/5.6/fpm/conf.d/memcache.ini
    - unless: php5.6 -m | grep memcache

php_stack:
  service.running:
    - name: php5.6-fpm
    - watch:
      - file: /etc/php/5.6/fpm/php.ini
      - file: /etc/php/5.6/fpm/pool.d/www.conf

# php5-imagick also requires imagemagick
imagemagick:
  pkg.installed

libssh2-1-dev:
  pkg.installed:
    - name: libssh2-1-dev

libssh2-php:
  pkg.installed:
    - name: libssh2-php

composer:
  cmd.run:
    - name: curl -sS https://getcomposer.org/installer | php; mv composer.phar /usr/local/bin/composer
    - unless: which composer

# Configuration files for php5-fpm

/etc/php/5.6/fpm/php.ini:
  file.managed:
    - source: salt://config/php5.6-fpm/php.ini
    - user: root
    - group: root
    - template: jinja
    - mode: 644

/etc/php/5.6/fpm/pool.d/www.conf:
  file.managed:
    - source: salt://config/php5.6-fpm/www.conf
    - user: root
    - group: root
    - template: jinja
    - mode: 644

{% if grains['user'] != 'vagrant' %}
/var/log/php.log:
  file.managed:
    - user: www-data
    - group: www-data
    - mode: 644
{% endif %}