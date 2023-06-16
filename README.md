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

> #### Ответ:> 
> <img width="957" alt="3-01" src="https://github.com/V4d1M63/homework/assets/130470784/a7cddf78-6cb2-40d6-ac1a-fda57d322e8e">


---

### Задание 4. Filebeat. 

Установите и запустите Filebeat. Переключите поставку логов Nginx с Logstash на Filebeat. 

*Приведите скриншот интерфейса Kibana, на котором видны логи Nginx, которые были отправлены через Filebeat.*

> #### Ответ:
![3-2](https://github.com/V4d1M63/homework/assets/130470784/3407d4d0-52e7-499d-a9fe-f682f78abb16)
---
