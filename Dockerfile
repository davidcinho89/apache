FROM php:5.4-apache
RUN echo "=== Docker Apache Debian PHP-5.4==="

RUN apt-get update; apt-get install -y vim \
  libpq-dev \
	postgresql-client \
	libxml2-dev;
RUN docker-php-ext-install mbstring; \
	docker-php-ext-install pdo; \
	docker-php-ext-install pdo_pgsql; \
	docker-php-ext-install pgsql; \
	docker-php-ext-install soap; \
  docker-php-ext-install pcntl; \
  docker-php-ext-install gd; \
  docker-php-ext-install zip; \
  docker-php-ext-configure soap;

RUN pear config-set php_ini /usr/local/etc/php/php.ini;
RUN pecl config-set php_ini /usr/local/etc/php/php.ini;
RUN pecl install apc;
RUN pecl install https://xdebug.org/files/xdebug-2.4.1.tgz \ 
&& docker-php-ext-enable xdebug \ 
&& echo "error_reporting = E_ALL" > /usr/local/etc/php/php.ini \ 
&& echo "display_startup_errors = On" >> /usr/local/etc/php/php.ini \ 
&& echo "display_errors = On" >> /usr/local/etc/php/php.ini \ 
&& echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \ 
&& echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \ 
&& echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \ 
&& echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN echo extension=apc.so > /usr/local/etc/php/conf.d/docker-php-ext-apc.ini

RUN a2enmod rewrite
RUN service apache2 restart

COPY php.ini /usr/local/etc/php/

ADD ./001-docker.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/001-docker.conf /etc/apache2/sites-enabled/

ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]
