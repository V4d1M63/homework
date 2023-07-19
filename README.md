# Домашнее задание к занятию "`12.3. «SQL. Часть 1»`" - `Вдовин Вадим`

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1

Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a” и не содержат пробелов.

> #### Ответ: 
> ```sql
> select 
>   distinct addr.district 
> from 
>   sakila.address addr 
> where 
>   addr.district like 'K%a' 
>   and position(' ' in addr.district) = 0
> 
> ```  
> <img width="783" alt="1" src="https://github.com/V4d1M63/homework/assets/130470784/71830fc7-937e-40b5-a0e0-3d1c4f797656">

  
### Задание 2

Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года **включительно** и стоимость которых превышает 10.00.

> #### Ответ: 
> ```sql
> select
> 	*
> from
> 	sakila.payment pay
> where
> 	pay.payment_date between "2005-06-15 00:00:00" and "2005-06-18 23:59:59"
> 	and pay.amount > 10
> ```  
> <img width="1047" alt="2" src="https://github.com/V4d1M63/homework/assets/130470784/03263c41-631f-4979-bd9c-8a60ac571992">



### Задание 3

Получите последние пять аренд фильмов.

> #### Ответ: 
> ```sql
> select
> 	rent.*,
> 	f.title
> from
> 	sakila.rental rent
> join sakila.inventory i on
> 	i.inventory_id = rent.inventory_id
> join sakila.film f on
> 	f.film_id = i.film_id
> order by
> 	rent.rental_date desc
> limit 5
> ```  
> <img width="871" alt="3" src="https://github.com/V4d1M63/homework/assets/130470784/0ebbde20-7ae4-4169-b83f-4e6a3a1713a0">


### Задание 4

Одним запросом получите активных покупателей, имена которых Kelly или Willie. 

Сформируйте вывод в результат таким образом:
- все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,
- замените буквы 'll' в именах на 'pp'.

> #### Ответ: 
> ```sql
> select
> 	c.customer_id,
> 	REPLACE(lower(c.first_name), 'll', 'pp') as weird_first_name,
> 	REPLACE(lower(c.last_name), 'll', 'pp') as weird_last_name,
> 	c.active,
> 	c.email,
> 	c.create_date
> from
> 	sakila.customer c
> where
> 	lower(c.first_name) in ('kelly', 'willie')
> 	and c.active
> ```  
> <img width="752" alt="4" src="https://github.com/V4d1M63/homework/assets/130470784/0036c74e-95ac-482d-aa70-8fd97ac4a1e7">
