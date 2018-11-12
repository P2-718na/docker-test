FROM debian:stretch

EXPOSE 80

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get -y install nginx php7.0-cli php7.0-cgi php7.0-fpm php7.0-simplexml php7.0-json php7.0-mysql unzip wget vim

RUN wget https://getcomposer.org/installer && php installer
RUN php composer.phar global require joomlatools/console --no-interaction

COPY ./etc /etc
RUN ln -s /etc/nginx/sites-available/joomla /etc/nginx/sites-enabled/
RUN rm /etc/nginx/sites-enabled/default

CMD ~/.composer/vendor/bin/joomla site:create --www=/tmp --mysql-login=root:$MYSQL_ROOT_PASSWORD \
    --mysql-host=db --mysql-database=$MYSQL_DATABASE $SITE_NAME && \
    mv /tmp/$SITE_NAME/* /var/www/html && \
    rm -rf /tmp/$SITE_NAME && \
    chmod -R 755 /var/www/html/ && \
    chown -R www-data:www-data /var/www/html/ && \
    service php7.0-fpm start && \
    nginx -g "daemon off;"