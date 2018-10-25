FROM debian:stretch

COPY ./etc /etc

EXPOSE 80

RUN apt-get update
RUN apt-get -y install nginx php7.0-cli php7.0-cgi php7.0-fpm unzip wget systemd systemd-sysv

RUN cd /tmp && wget https://github.com/joomla/joomla-cms/releases/download/3.8.2/Joomla_3.8.2-Stable-Full_Package.zip
RUN mkdir -p /var/www/html/joomla
RUN unzip /tmp/Joomla*.zip -d /var/www/html/joomla
RUN chown -R www-data:www-data /var/www/html/joomla/
RUN chmod -R 755 /var/www/html/joomla/
RUN ln -s /etc/nginx/sites-available/joomla.conf /etc/nginx/sites-enabled/
RUN rm /etc/nginx/sites-enabled/default

CMD nginx