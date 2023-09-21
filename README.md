# Домашнее задание к занятию "6.3. MySQL" - Вдовин Вадим

---
## Задача 1

<details><summary>.</summary>

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.
    
</details>

## Решение 1

```
# Подготавливаю образ
docker pull mysql:8.0

# Cоздаю volume
docker volume create vol1
docker volume create vol2

# Поднимаю контейнер
docker run --name test_mysql --network host -e MYSQL_ROOT_PASSWORD=mysql -ti -d -v vol1:/etc/mysql/ -v vol2:/etc/mysql/backup mysql:8.0

# Копирую бекап в контейнер
docker cp test_dump.sql test_mysql:/etc/mysql/backup

# Создаю базу test_db
exec -it test_mysql mysql -u root --password=mysql -h localhost -P 3306
CREATE DATABASE test_db;

# Востанавливаю бд из бекапа
docker exec -it test_mysql bash
mysql -u root -p test_db < test_dump.sql

# Выбираю необходимую бд
use test_db
```
![1](https://github.com/V4d1M63/homework/assets/130470784/7e5d82de-00c6-4b75-8168-16d642c40b1c)

---
## Задача 2
    
<details><summary>.</summary>

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.
    
</details>

## Решение 2

```
# Создаю пользователя с паролем test_pass
CREATE USER 'test'@'localhost' IDENTIFIED BY 'test-pass';

# Задаю атрибуты имя и фамилию
ALTER USER 'test'@'localhost' ATTRIBUTE '{"fname":"James", "lname":"Pretty"}';


# максимальное количество запросов в час – 100
# срок истечения пароля - 180 дней
# количество попыток авторизации - 3
ALTER USER 'test'@'localhost'
    -> IDENTIFIED BY 'test-pass'
    -> WITH
    -> MAX_QUERIES_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2;
```
- Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.

```
SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
```
![2](https://github.com/V4d1M63/homework/assets/130470784/342bdc80-3830-4a07-8f88-3bf27512647f)

---
## Задача 3
    
<details><summary>.</summary>

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`
    
</details>

## Решение 3

```
# Устанавливаю профилирование
set profiling=1;

# С помощью запроса узнаю движок
mysql> SELECT TABLE_NAME,ENGINE,ROW_FORMAT FROM information_schema.TABLES WHERE table_name = 'orders' and  TABLE_SCHEMA = 'test_db' ORDER BY ENGINE asc;
```
![3](https://github.com/V4d1M63/homework/assets/130470784/22cd30c4-8cbb-4ac4-9fb9-3cb3a912ca24)

- По умолчанию движок в таблице используется InnoDB

Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:

- на MyISAM
- на InnoDB
```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.01341525 | ALTER TABLE orders ENGINE = MyISAM |
|        2 | 0.01842075 | ALTER TABLE orders ENGINE = InnoDB |
+----------+------------+------------------------------------+
2 rows in set, 1 warning (0.00 sec)
```

---
## Задача 4 
    
<details><summary>.</summary>

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.
    
 </details>
 
 ## Решение 4
 ```
root@4c80762097d0:/# cat /etc/mysql/my.cnf
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

innodb_flush_log_at_trx_commit = 0
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 2G
innodb_log_file_size = 100M
```
