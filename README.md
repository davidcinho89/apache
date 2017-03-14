#Imagen Docker Apache Debian PHP5.4

Add to "hosts" file, desarrollo.com with the image ip address of container.

Generate keys in server:

openssl req -x509 -nodes -days 1095 -newkey rsa:2048 -out /etc/apache2/ssl/server.crt -keyout /etc/apache2/ssl/server.key

Run image:

docker run -d -p 80:80 -p 443:443 -v {LOCAL_PATH}:/var/www/html/ davidcinho89/apachedebian-php-5.4

LOCAL_PATH contains the "desarrollo" folder
