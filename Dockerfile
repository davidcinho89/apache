FROM php:5.4-apache
RUN echo "=== Docker Apache Debian PHP-5.4==="

RUN apt-get update; apt-get install -y vim \
  libpq-dev \
  libldb-dev \
  libldap2-dev \
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
  docker-php-ext-install ldap; \
  docker-php-ext-configure soap;

RUN pear config-set php_ini /usr/local/etc/php/php.ini;
RUN pecl config-set php_ini /usr/local/etc/php/php.ini;
RUN pecl install apc;
RUN pecl install https://xdebug.org/files/xdebug-2.4.1.tgz 

RUN echo extension=apc.so > /usr/local/etc/php/conf.d/docker-php-ext-apc.ini 

RUN mkdir /etc/apache2/ssl
ADD ./server.crt /etc/apache2/ssl/
ADD ./server.key /etc/apache2/ssl/

RUN a2enmod rewrite
RUN a2enmod ssl
RUN service apache2 restart

COPY php.ini /usr/local/etc/php/

RUN docker-php-ext-enable xdebug

ADD ./001-docker.conf /etc/apache2/sites-available/
ADD ./001-docker-ssl.conf /etc/apache2/sites-available/

RUN ln -s /etc/apache2/sites-available/001-docker.conf /etc/apache2/sites-enabled/
RUN ln -s /etc/apache2/sites-available/001-docker-ssl.conf /etc/apache2/sites-enabled/
RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so
RUN ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so


EXPOSE 443
ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]
