# Домашнее задание к занятию "6.4. PostgreSQL" - Вдовин Вадим

---
## Задача 1

<details><summary>.</summary>

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

</details>

## Решение 1

```
# Подготавливаю обарз
root@test-16:~$ docker pull postgres:13  

# Создаю volume для бекапов и хранения базы
root@test-16:~$ docker volume create vol3 
vol1  
root@test-16:~$ docker volume create vol4
vol2  

# Поднимаю контейнер
root@test-16:/var/lib/docker/volumes/vol2/_data/data# docker run --network host --name postgres_test -e POSTGRES_PASSWORD=postgres -ti -d -v vol3:/var/lib/postgresql/data -v vol4:/var/lib/postgresql/backup postgres:13  

# Подключаюсь к БД через psql
root@test-16:~$ docker exec -it postgres_test3 psql -h localhost -p 5432 -U postgres
```

Найдите и приведите управляющие команды для:

- вывода списка БД
```
postgres=# \l+
                                                                   List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |  Size   | Tablespace |
       Description
-----------+----------+----------+------------+------------+-----------------------+---------+------------+---------
-----------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7901 kB | pg_default | default
administrative connection database
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7753 kB | pg_default | unmodifi
able empty database
           |          |          |            |            | postgres=CTc/postgres |         |            |
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7753 kB | pg_default | default
template for new databases
           |          |          |            |            | postgres=CTc/postgres |         |            |
(3 rows)
```
- подключения к БД,
```
postgres=# \conninfo
You are connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5432".
```
- вывода списка таблиц,
```
postgres=# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 pg_catalog | pg_am                   | table | postgres
 pg_catalog | pg_amop                 | table | postgres
 pg_catalog | pg_amproc               | table | postgres
 pg_catalog | pg_attrdef              | table | postgres
 pg_catalog | pg_attribute            | table | postgres
 pg_catalog | pg_auth_members         | table | postgres
 pg_catalog | pg_authid               | table | postgres
 pg_catalog | pg_cast                 | table | postgres
 pg_catalog | pg_class                | table | postgres
 pg_catalog | pg_collation            | table | postgres
 pg_catalog | pg_constraint           | table | postgres
 pg_catalog | pg_conversion           | table | postgres
 pg_catalog | pg_database             | table | postgres
 pg_catalog | pg_db_role_setting      | table | postgres
 pg_catalog | pg_default_acl          | table | postgres
 pg_catalog | pg_depend               | table | postgres
 pg_catalog | pg_description          | table | postgres
 pg_catalog | pg_enum                 | table | postgres
 pg_catalog | pg_event_trigger        | table | postgres
 pg_catalog | pg_extension            | table | postgres
 pg_catalog | pg_foreign_data_wrapper | table | postgres
 pg_catalog | pg_foreign_server       | table | postgres
 pg_catalog | pg_foreign_table        | table | postgres
 pg_catalog | pg_index                | table | postgres
 pg_catalog | pg_inherits             | table | postgres
 pg_catalog | pg_init_privs           | table | postgres
 pg_catalog | pg_language             | table | postgres
--More--
```
- вывода описания содержимого таблиц,
```
postgres=# \dS+

postgres-#             List of relations
postgres-#    Schema   |          Name           | Type  |  Owner
postgres-# ------------+-------------------------+-------+----------
postgres-#  pg_catalog | pg_aggregate            | table | postgres
postgres-#  pg_catalog | pg_am                   | table | postgres
postgres-#  pg_catalog | pg_amop                 | table | postgres
postgres-#  pg_catalog | pg_amproc               | table | postgres
postgres-#  pg_catalog | pg_attrdef              | table | postgres
postgres-#  pg_catalog | pg_attribute            | table | postgres
postgres-#  pg_catalog | pg_auth_members         | table | postgres
postgres-#  pg_catalog | pg_authid               | table | postgres
postgres-#  pg_catalog | pg_cast                 | table | postgres
postgres-#  pg_catalog | pg_class                | table | postgres
postgres-#  pg_catalog | pg_collation            | table | postgres
postgres-#  pg_catalog | pg_constraint           | table | postgres
postgres-#  pg_catalog | pg_conversion           | table | postgres
postgres-#  pg_catalog | pg_database             | table | postgres
postgres-#  pg_catalog | pg_db_role_setting      | table | postgres
postgres-#  pg_catalog | pg_default_acl          | table | postgres
postgres-#  pg_catalog | pg_depend               | table | postgres
postgres-#  pg_catalog | pg_description          | table | postgres
postgres-#  pg_catalog | pg_enum                 | table | postgres
postgres-#  pg_catalog | pg_event_trigger        | table | postgres
postgres-#  pg_catalog | pg_extension            | table | postgres
postgres-#  pg_catalog | pg_foreign_data_wrapper | table | postgres
postgres-#  pg_catalog | pg_foreign_server       | table | postgres
postgres-#  pg_catalog | pg_foreign_table        | table | postgres
postgres-#  pg_catalog | pg_index                | table | postgres
postgres-#  pg_catalog | pg_inherits             | table | postgres
postgres-#  pg_catalog | pg_init_privs           | table | postgres
postgres-#  pg_catalog | pg_language       
--More--
```
- выхода из psql.
```
postgres=# \q
root@test-16:/#
```

---
## Задача 2
    
<details><summary>.</summary>

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

</details>

## Решение 2

- Используя psql создайте БД test_database
```
root@test-16:/src/test_data$ docker exec -it postgres_test3 psql -h localhost -p 5432 -U postgres

postgres=# CREATE DATABASE test_database;
```

 - Изучите бэкап БД.
 - Восстановите бэкап БД в test_database.
```
root@test-16:/var/lib/postgresql/backup# psql -U postgres -W test_database < /var/lib/postgresql/backup/test_dump.sql
```

 - Перейдите в управляющую консоль psql внутри контейнера.
 - Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
 - Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
```
test_database=# ANALYZE VERBOSE public.orders;

test_database=# select avg_width from pg_stats where tablename='orders';
```

![1](https://github.com/V4d1M63/homework/assets/130470784/78c69856-6236-4d7a-8411-b289a4d05340)

---
## Задача 3
    
<details><summary>.</summary>
  
Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
                                                                                              
</details>

## Решение 3
  
```  
# Переименовываю старую таблицу 
alter table public.orders rename to orders_old;
  
# Создаю новую таблицу 
create table public.orders (like public.orders_old including all);
  
# Создаю дочернюю таблицу с проверкой условия значение price>499 для таблицы public.orders
create table public.orders_499 (check (price>499)) inherits (public.orders);

# Создаю дочернюю таблицу с проверкой условия значение price<=499 для таблицы public.orders
create table public.orders_less499 (check (price<=499)) inherits (public.orders);
  
# Создаю правило для всех значений public.orders где price>499 вставлять значение в таблицу public.orders_499
create rule orders_more_499 as on insert to public.orders where (price>499) do instead insert into public.orders_499 values(NEW.*);
  
# Создаю правило для всех значений public.orders где price<=499 вставлять значение в таблицу public.orders_less499
create rule orders_less_499 as on insert to public.orders where (price<=499) do instead insert into public.orders_less499 values(NEW.*);

# Копирую данные из public.orders_old в public.orders для заполнения шардированых таблиц
test_database=# insert into orders (id, title, price) select * from orders_old;
```  
  
![2](https://github.com/V4d1M63/homework/assets/130470784/f9b66aa9-4817-4db5-beb6-c8849d6aa23b)

```
# Добавляю данные и проверяю результат заполнения таблиц
test_database=# INSERT INTO orders (id, title, price) VALUES (9, 'All hope is gone', 777);
```
  
![3](https://github.com/V4d1M63/homework/assets/130470784/d0494a12-cf6b-4750-8702-e790b1909997)
  
- Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?  
  
Такая возможность была но шардирование необходимо предусмотреть при создании родительской таблицы.  
Дочерние таблицы заполняются при вводе новых значений в основную таблицу, наличие уже имеющихся значений в родительской таблице не передается в дочериние поэтому  необходимо предусмотреть их наличие и привязку при непосредственном создании основной таблицы. 
  
---
## Задача 4 
    
<details><summary>.</summary>
  
Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

</details>
 
## Решение 4

- Перехожу в контейнер
``` 
root@test-16:~$ docker exec -it postgres_test3 bash
``` 
- Создаю бекап и проверяю его наличие
``` 
root@test-16:/# pg_dump -U postgres -W test_database > /var/lib/postgresql/backup/test_database.sql
Password:
root@test-16:/# cd /var/lib/postgresql/backup
root@test-16:/var/lib/postgresql/backup# ls
test_database.sql  test_dump.sql
``` 
- Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database? 
``` 
# Присваиваю столбцу  title неповторяемые уникальные значения UNIQUE
--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer DEFAULT nextval('public.orders_id_seq'::regclass) NOT NULL,
    title character varying(80) NOT NULL UNIQUE,
    price integer DEFAULT 0
);
  ``` 
