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
     - ./files:/var/www/html/
     ports:
     - "80:80"
     environment:
      - WEB_DOCUMENT_ROOT=/var/www/html/contao/web
      - WEB_ALIAS_DOMAIN=hello.ap
       
   phpmyadmin2:
     image: phpmyadmin/phpmyadmin
     container_name: phpmyadmin2
     depends_on: 
      - db
     restart: always
     ports:
      - "8080:80"
     environment:
      - PMA_ARBITRARY=1   
       
       
volumes:
    db_data:' > ./docker-compose.yml

mkdir files
mkdir files/contao
mkdir files/contao/web
docker-compose up -d
cd files
curl -sS https://getcomposer.org/installer | php
sleep 5 
rm -rf contao
docker-compose exec apache bash -c "php /var/www/html/composer.phar create-project contao/managed-edition /var/www/html/contao/ '4.6.*' "
docker-compose exec apache bash -c "chmod -R 777 /tmp"
curl https://download.contao.org/contao-manager/stable/contao-manager.phar --output contao/web/contao-manager.phar.php
echo 'Contao 4 ready.'
