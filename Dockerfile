FROM ubuntu:12.04
MAINTAINER Dmitry Anikeev <anikeev.dmitry@outlook.com>
ENV ENVIRONMENT docker
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get update -y --force-yes && \
    apt-get install -y --force-yes --no-install-recommends \ 
      git \
      mercurial \
      nano \
      curl lynx-cur \
      php5 \
      php5-cli \
      php5-gd \
      php5-json \
      php5-ldap \
      php5-mysql \
      php5-pgsql \
      php5-sqlite \
      php-pear \
      php-apc \
      php5-curl \
      php5-xdebug \
      php5-intl \
      php5-mcrypt \
      && rm -rf /var/lib/apt/lists/* \
      && apt-get clean -y

RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

RUN echo "xdebug.remote_enable=on" >> /etc/php5/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /etc/php5/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /etc/php5/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_port=${XDEBUG_REMOTE_PORT}" >> /etc/php5/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.idekey=${XDEBUG_IDEKEY}" >> /etc/php5/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.max_nesting_level=${XDEBUG_MAX_NESTING_LEVEL}" >> /etc/php5/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_connect_back=off" >> /etc/php5/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_host=${XDEBUG_IP_ADDRESS}" >> /etc/php5/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_log=${XDEBUG_REMOTE_LOG}" >> /etc/php5/cli/conf.d/20-xdebug.ini

RUN export XDEBUG_CONFIG="remote_enable=on remote_autostart=off remote_handler=dbgp remote_connect_back=off remote_port=${XDEBUG_REMOTE_PORT} show_local_vars=on max_nesting_level=${XDEBUG_MAX_NESTING_LEVEL} remote_log=${XDEBUG_REMOTE_LOG} remote_host=${XDEBUG_IP_ADDRESS} xdebug.idekey=${XDEBUG_IDEKEY}"