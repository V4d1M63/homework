# Домашнее задание к занятию "`11.3. ELK`" - `Вадим Вдовин`

### Задание 1. Elasticsearch 

Установите и запустите Elasticsearch, после чего поменяйте параметр cluster_name на случайный.  
*Приведите скриншот команды 'curl -X GET 'localhost:9200/_cluster/health?pretty', сделанной на сервере с установленным Elasticsearch. Где будет виден нестандартный cluster_name*.  

> #### Ответ:  
><img width="798" alt="1-02" src="https://github.com/V4d1M63/homework/assets/130470784/1cde5c57-86aa-4d24-bb9c-db07a44d4a27">

---

### Задание 2. Kibana

Установите и запустите Kibana.

*Приведите скриншот интерфейса Kibana на странице http://<ip вашего сервера>:5601/app/dev_tools#/console, где будет выполнен запрос GET /_cluster/health?pretty*.

> #### Ответ:
>   <img width="957" alt="2-01" src="https://github.com/V4d1M63/homework/assets/130470784/e80ce474-13f1-4d4a-b508-c8e6a35699b9">
 
---

### Задание 3. Logstash

Установите и запустите Logstash и Nginx. С помощью Logstash отправьте access-лог Nginx в Elasticsearch. 

*Приведите скриншот интерфейса Kibana, на котором видны логи Nginx.*

> #### Ответ:
> Установил NGINX, изменил конфигурацию, пишем логи в syslog по порту 5445:  
> ```
> events {
>         worker_connections 1024;
> }
> 
> http {
>         include /etc/nginx/mime.types;
>         include /etc/nginx/conf.d/*.conf;
>         include /etc/nginx/sites-enabled/default;
>         default_type application/octet-stream;
> 
>         log_format json escape=json
>                '{'
>                        '"Authorization":"$http_authorization",'
>                        '"RequestTime":"$time_iso8601",'
>                        '"RemoteAddress":"$remote_addr",'
>                        '"RemotePort":"$remote_port",'
>                        '"RemoteUser":"$remote_user",'
>                        '"RequestHost":"$host",'
>                        '"RequestPort":"$server_port",'
>                        '"RequestMethod":"$request_method",'
>                        '"RequestPath":"$request_uri",'
>                        '"RequestBody":"$request_body",'
>                        '"ResponseStatus":"$status",'
>                        '"Upstream":"$upstream_addr",'
>                        '"UpstreamPath":"$uri",'
>                        '"UpstreamResponseTime":"$upstream_response_time"'
>                '}';
> 
>        access_log syslog:server=0.0.0.0:5445 json;
> ```   
> 
> Конфигурация logstash настроена в /etc/logstash/conf.d/nginx-logstash.conf   
> Читаем из 5445, парсим json, записываем в elasticsearch:
> ```
> input {
>   syslog {
>     port => 5445
>     tags => "nginx"
>   }
> }
> 
> filter {
>     json{
>         source => "message"
>     }
>     mutate {
>         remove_field => ["message","timestamp","RequestTime","facility",> "facility_label","severity","severity_label","priority"]
>     }
> }
> 
> output {
>   elasticsearch {
>       hosts => ["https://localhost:9200"]
>       index => "nginx-%{+yyyy.MM.dd}"
>       user => "logstash_internal"
>       password => "123456"
>       cacert => "/etc/logstash/ca.crt"
>   }
> }
> ```  
> 
> Добавил пользователя logstash_internal, настроил роли и привелегии. Добавил Data  View:  
> ![img](https://github.com/smutosey/11-03-elk/blob/main/img/3-02.png) 
> 
> Логи NGINX в интерфейсе Kibana
> ![img](https://github.com/smutosey/11-03-elk/blob/main/img/3-01.png) 

---

### Задание 4. Filebeat. 

Установите и запустите Filebeat. Переключите поставку логов Nginx с Logstash на Filebeat. 

*Приведите скриншот интерфейса Kibana, на котором видны логи Nginx, которые были отправлены через Filebeat.*

> #### Ответ:
> В концигурации logstash для nginx добавляем input, будем просто помечать другим тегом:
> ```
> input {
>   beats {
>     port => 5678
>     tags => "nginx-from-filebeat"
>   }
> }
> ```
> 
> Конфигурация Filebeat:
> ```yml
> filebeat.inputs:
> - type: log
>   paths:
>     - /var/log/nginx/*.log
> output.logstash:
>   # The Logstash hosts
>   hosts: ["0.0.0.0:5678"]
> ```
> 
> Настройки логирования NGINX, попробуем теперь брать логи из файлов:
> ```
>         access_log syslog:server=0.0.0.0:5445 json;
>         access_log /var/log/nginx/access.log json;
>         error_log /var/log/nginx/error.log;
> ```
> Логи NGINX в интерфейсе Kibana с тегом nginx-from-filebeat
> ![img](https://github.com/smutosey/11-03-elk/blob/main/img/4-01.png) 

---
