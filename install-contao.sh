echo 'HELLO'
echo 'version: "3.3"

services:
   db:
     image: mysql:5.7
     volumes:
       - ./db_data:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: somecontao
       MYSQL_DATABASE: contao
       MYSQL_USER: contao
       MYSQL_PASSWORD: contao

   apache:
     image: webdevops/php-apache-dev:alpine
     depends_on:
     - db
     volumes:
     - ./contao:/var/www/html/
     ports:
     - "80:80"
     environment:
      - WEB_DOCUMENT_ROOT=/var/www/html/web
      - WEB_ALIAS_DOMAIN=hello.co
       
   phpmyadmin-contao:
     image: phpmyadmin/phpmyadmin
     container_name: phpmyadmin-contao
     depends_on: 
      - db
     restart: always
     ports:
      - "8080:80"
     environment:
      - PMA_ARBITRARY=1   
       
       
volumes:
    db_data:' > ./docker-compose.yml


curl -L http://download.contao.org/4.4 | tar -xzp
mv contao-4* contao
cd contao/web
curl https://download.contao.org/contao-manager/stable/contao-manager.phar -o contao-manager.phar.php
docker-compose up -d
echo 'Contao 4 ready.'
