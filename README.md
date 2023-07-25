# Домашнее задание к занятию "`12.5. «Индексы»`" - `Вдовин Вадим`

### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

> #### Ответ: 
> ```sql
> select
> 	concat(round(( (sum(t.INDEX_LENGTH)/ SUM(t.DATA_LENGTH)) * 100 ), 2), '%') > index_metric
> from
> 	INFORMATION_SCHEMA.tables t
> where
> 	t.TABLE_SCHEMA = 'sakila'
> ```
>  <img width="667" alt="1" src="https://github.com/V4d1M63/homework/assets/130470784/f9401a21-ed2b-4779-8d38-5edaf6b405b3">


### Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
``` 
> Выборка заняла почти 7 секунд:
> <img width="994" alt="2" src="https://github.com/V4d1M63/homework/assets/130470784/cfbf5ab3-12b2-44c5-8ff3-d96e5df25b0b">
 

- перечислите узкие места; 
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.  

> #### Ответ: 
> Для начала, нужно понять, что выводит запрос. Это выборка за дату уникальных сумм платежей за аренду фильма, которые были внесены клиентами в день взятия в аренду.  
> Что важно, в запросе используется оконная функция при вычислении суммы платежей, которая группирует в разрере по "клиенту" `customer_id` и "фильму" `film_id`. Особенность оконных функций: количество строк в запросе не уменьшается по сравнении с исходной таблицей, отсюда следует, что она используется не случайно. Но группировка по `film_id` сейчас не даёт правильного результата, т.к. таблица `film` присоединена некорректно, "многое ко многим".  
> Таким образом, выделим узкие места запроса:  
> 1. Таблица `film` привязана как "многое ко многим" без условий. Нужно добавить в `where` условие `and f.film_id = i.film_id`, запрос будет работать значительно быстрее, но тогда и результат изменится, т.к. оконная функция отработает правильно.  
> 2. Если же изначально не было задумки группировать в разрезе фильмов уникальные суммы платежей, то нет смысла включать в запрос таблицы `film` и `inventory`, а следовательно и нет причин использоать оконную функцию, если можно ограничиться GROUP BY по `customer_id`. Тогда можно убрать и `distinct` дедупликацию
> 3. Связка таблиц `payment` и `rental` по дате. В таблице `rental` есть индекс `rental_date`, а вот в `payment` нет индекса по дате. Создадим с помощью ```CREATE UNIQUE INDEX payment_date_IDX USING BTREE ON sakila.payment (payment_date,rental_id);```. Хотя можно, наверное, и просто индекс на payment_date
> 4. Можно попробовать оптимизировать фильтр по дате. Сравнил различные EXPLAIN, конструкция `p.payment_date >= '2005-07-30' and p.payment_date < date_add('2005-07-30', interval 1 day)` отрабатывает быстрее, чем `between`, и еще быстрее, чем изначальное условие `date(p.payment_date) = '2005-07-30'`, т.к. оно бы преобразовывало datetimne в date
> 5. `JOIN ON` выглядит нагляднее и поприятнее, чем where + условия. Но на оптимальности запроса это не должно сказаться.  
> 
> Итого, я вижу два варианта, что хотел вывести изначальный автор запроса, а следовательно и два варианта оптимизации: 
> 1. Выборка за дату суммы платежей по клиентам, которые внесли оплату в день взятия в  аренду. Результат выборки совпадает с авторским.
> ```sql
> select
> 	concat(c.last_name, ' ', c.first_name),
> 	sum(p.amount)
> from
> 	sakila.payment p
> left join sakila.rental r ON
> 	r.rental_date = p.payment_date
> left join sakila.customer c ON
> 	c.customer_id = p.customer_id
> where
> 	p.payment_date >= '2005-07-30'
> 	and p.payment_date < date_add('2005-07-30', INTERVAL 1 DAY)
> group by
> 	p.customer_id
> ```
> Выборка за 3,5 мс:
> <img width="1340" alt="3" src="https://github.com/V4d1M63/homework/assets/130470784/d58da2a1-ccc9-4702-92ba-81147e91a498">
> <img width="686" alt="4" src="https://github.com/V4d1M63/homework/assets/130470784/d3c7eb81-b1dd-495b-9a70-fd1e25217a61">
> 
> 2. Выборка за дату сумм платежей за аренду фильма, которые были внесены клиентами в > день взятия в аренду, в разрезе клиентов и фильмов. Результат выборки не совпадает с > изначальным.
> ```sql
> select
> 	distinct concat(c.last_name, ' ', c.first_name),
> 	sum(p.amount) over (partition by c.customer_id,
> 	f.title)
> from
> 	sakila.payment p
> left join sakila.rental r ON
> 	r.rental_date = p.payment_date
> left join sakila.customer c ON
> 	c.customer_id = p.customer_id
> left join sakila.inventory i on
> 	i.inventory_id = r.inventory_id
> left join sakila.film f on
> 	f.film_id = i.film_id
> where
> 	p.payment_date >= '2005-07-30'
> 	and p.payment_date < date_add('2005-07-30', INTERVAL 1 DAY)
> ```
> Выборка за 6,7 мс:
> <img width="1515" alt="5" src="https://github.com/V4d1M63/homework/assets/130470784/fd0efa62-6083-4e92-991b-a906bb8cfdd9">  
> <img width="864" alt="6" src="https://github.com/V4d1M63/homework/assets/130470784/b8e34594-4ced-4453-aade-b2b50a3477bd">
