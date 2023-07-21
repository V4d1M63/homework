# Домашнее задание к занятию "`12.4. «SQL. Часть 2»`" - `Вдовин Вадим`

### Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина;
- город нахождения магазина;
- количество пользователей, закреплённых в этом магазине.

> #### Ответ: 
>
> ```sql
> SELECT
> 	staff.first_name,
> 	staff.last_name,
> 	city.city,
> 	customers.cnt
> FROM 
> 	sakila.store AS store
> RIGHT JOIN (
> 	SELECT
> 		store_id,
> 		count(*) as cnt
> 	from
> 		sakila.customer
> 	group by
> 		store_id
> 	having
> 		count(*) > 300) as customers on
> 	customers.store_id = store.store_id
> JOIN sakila.staff AS staff ON
> 	store.manager_staff_id = staff.staff_id
> JOIN sakila.address AS addr ON
> 	store.address_id = addr.address_id
> JOIN sakila.city city ON
> 	addr.city_id = city.city_id
> ```
> <img width="832" alt="1" src="https://github.com/V4d1M63/homework/assets/130470784/520ebedc-be58-4593-8b80-624ecabf03be">
>

### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

> #### Ответ: 
> ```sql
> select
> 	count(1)
> from
> 	sakila.film f
> where
> 	f.length > (
> 	select
> 		AVG(f.length)
> 	from
> 		sakila.film f )
> ```  
<img width="799" alt="2" src="https://github.com/V4d1M63/homework/assets/130470784/66edc2d5-892f-4202-9f1b-c07fc7d93527">


### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.  

> #### Ответ:  
> Группировать просто по MONTH() не получится, т.к. при выборке за несколько лет получим искаженные данные. Поэтому:
> ```sql
> select
> 	date_format(p.payment_date,'%Y-%m') month, count(*) payment_cnt
> from
> 	sakila.payment p 
> group by date_format(p.payment_date,'%Y-%m')
> order by count(*) desc
> LIMIT 1
> ```  
><img width="701" alt="3" src="https://github.com/V4d1M63/homework/assets/130470784/14053c68-c286-49ec-af59-cf75b9261b1b">
