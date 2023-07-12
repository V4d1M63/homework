# Домашнее задание к занятию 12.1. «Базы данных» - Вадим Вдовин.

---
### Легенда

Заказчик передал вам [файл в формате Excel](https://github.com/netology-code/sdb-homeworks/blob/main/resources/hw-12-1.xlsx), в котором сформирован отчёт. 

На основе этого отчёта нужно выполнить следующие задания.

### Задание 1

Опишите не менее семи таблиц, из которых состоит база данных:

- какие данные хранятся в этих таблицах;
- какой тип данных у столбцов в этих таблицах, если данные хранятся в PostgreSQL.

Ответ:
1. Фамилия Имя Отчество. - Строковый.
2. Оклад сотрудника. - Цифровой.
3. Должность сотрудника. - Строковый.
4. Тип подразделения. - Строковый.
5. Дата. - Дата и время.
6. Адрес. - Строковый.
7. Проэкт. - Строковый.
8. Проект на который назначен. - Строковый.

Приведите решение к следующему виду:

Сотрудники (

- идентификатор, первичный ключ, serial,
- фамилия varchar(50),
- ...
- идентификатор структурного подразделения, внешний ключ, integer).

```
- main_table (Основная таблица)
- - id (auto incriment, int, primary)
- - user_id (unsigned, int, not null)
- - office_id (unsigned, int, not null)
- - position_id (unsigned, int, not null)
- - subdivision_id (unsigned, int, not null) 
- - department_id (unsigned, int, not null)
- - total_sum (float, not null)
- - hire_date (date, not null)
```

```
- user (Пользователь)
- - id (auto incriment, int, primary)
- - first_name (varchar(255), not null)
- - middle_name (varchar(255), not null)
- - last_name (varchar(255), not null)
```

```
- office (Адрес филиала)
- - id (auto incriment, int, primary)
- - address (varchar(255), not null)
```

```
- position (Должность)
- - id (auto incriment, int, primary)
- - name (varchar(255), not null)
```

```
- subdivision (Тип подразделения)
- - id (auto incriment, int, primary)
- - name (varchar(255), not null)
```

```
- department (Структурное подразделение)
- - id (auto incriment, int, primary)
- - name (varchar(255), not null)
```

```
- project (Проекты)
- - id (auto incriment, int, primary)
- - name (varchar(255), not null)
```

```
- project_user (таблица для соеденения пользователей и проектов)
- - id (auto incriment, int, primary)
- - project_id (varchar(255), not null)
- - user_id (varchar(255), not null)
```
---
