--- Домашнее задание к уроку 4

---task 13  Вывести список всех продуктов и производитея с указанием типа продукта. Вывести model, maker, type

select model, maker, type
from product p 

---task 14 При выводе всех значений из таблицы Принтер дополнительно вывести для тех, у кого цена выше средней PC - 1, у остальных 0

select *,
case when price > (select avg(price) from pc)
then 1
else 0
end flag 
from printer p 

---task 15 Вывести список кораблей, у которых класс отсутствует

select *
from ships s 
where class is null 


--task 16 Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду

select name
from battles
where year(battles.date) not in
     (select launched
      from ships
      where launched is not null)

--task 17 Найти сражения, в которых участвовали корабли класса Kongo из таблицы Ships 

select battle from ships 
left join 
outcomes 
on ships.name = outcomes.ship
left join 
battles 
on battles.name = outcomes.battle 
where ships.class = 'Kongo' and battle is not null

--task 1 Сделать view для всех товаров с флагом, если стоимость выше 300

create view all_products_flag_300 as

with all_price as
(select model, price from pc 
union all
select model, price from printer
union all
select model, price from laptop)

select model,price,
case when all_price.price > 300 
then 1
else 0
end flag 
from all_price 

select *
from all_products_flag_300

--task 2 Сделать view для всех товаров с флагом, если стоимость выше средней 

create view all_products_flag_avg_price as

with all_price_2 as
(select model, price from pc 
union all
select model, price from printer
union all
select model, price from laptop)

select model,price,
case when price > (select avg(price) from all_price_2) 
then 1
else 0
end flag 
from all_price_2

select *
from all_products_flag_avg_price

--task 3 Вывести все принтеры производителя А со стоимостью выше средней по принтерам производителя Д и С. Вывести модель

select product.model
from product
join printer
on product.model = printer.model 
where price > (select avg(price) from printer) and product.maker = 'A'

--task 4 Вывести все товары производителя А со стоимостью выше средней по принтерам производителя Д и С. Вывести модель

with price_D_C as
(select model, price from pc 
union all
select model, price from printer
union all
select model, price from laptop)

select price_D_C.model
from product
join price_D_C
on product.model = price_D_C.model 
where price > (select avg(price) from price_D_C) and product.maker = 'A'

--task 5 Какая средняя цена среди уникальных продуктов производителя А

with all_product as
(select model, price from pc 
union
select model, price from printer
union
select model, price from laptop)

select avg(all_product.price)
from all_product 
join product 
on product.model = all_product.model
where product.maker = 'A'

--task 6 Сделать view с количеством товаров по каждому производителю. Вывести производитель - количество

create view count_product_by_makers as 

with all_product_2 as
(select model from pc 
union all
select model from printer
union all
select model from laptop)

select product.maker, count(all_product_2.model)
from all_product_2
join product 
on product.model = all_product_2.model
group by product.maker

select *
from count_product_by_makers


--- task 7 По предыдущему view сделать график (х-maker, y - count)
request = """
SELECT count, maker
from count_product_by_makers
order by count desc
"""

df = pd.read_sql_query(request,conn)
fig = px.bar(x=df.maker.to_list(), y=df['count'].to_list(), labels={'x': 'maker', 'y': 'count price'})
fig.show()

--task 8-9 Сделать копию таблицы printer и удалить из нее все принтеры производителя Д

create table printer_update_4 as 

select printer.model, product.maker 
from printer 
join product 
on printer.model = product.model 
where product.maker <> 'D'


select *
from printer_update_4

--task 10 Сделать view с количеством потопленных кораблей и классом корабля  

create view sunk_ships_by_classes_1 as 

select ships.class, count(outcomes.ship)
from outcomes
full join ships
on outcomes.ship = ships.name
where outcomes.result = 'sunk'
group by ships.class

select *
from sunk_ships_by_classes_1

--task 11 По предыдущему view сделать график в коллаб 

request = """
SELECT count, class
from sunk_ships_by_classes_1
order by count desc
"""

df = pd.read_sql_query(request,conn)
fig = px.bar(x=df['class'].to_list(), y=df['count'].to_list(), labels={'x': 'class', 'y': 'count ship'})
fig.show()

--task 12 Сделать копию Classes и добавить в нее флаг - если количество орудий больше или равно 9 - 1, если нет 0

create table classes_with_flag as 

select *, 
case when numguns >= 9
then 1
else 0
end flag 
from classes c 

select *
from classes

--task 13 Сделать график в колаб по таблице Classes с количеством классов по странам (х-страна, у - кол-во классов)

request = """
SELECT count('class'), country
from classes
group by country
order by count desc
"""

df = pd.read_sql_query(request,conn)
fig = px.bar(x=df.country.to_list(), y=df['count'].to_list(), labels={'x': 'country', 'y': 'count'})
fig.show()

--task 14 Вернуть количество кораблей, у которых название начинается с буквы О или М 

select * 
from ships s 
where name like 'O%' or name like 'M%'

--task 15 Вернуть количество кораблей, у которых название состоит из 2х слов

select * 
from ships s 
where name like '_% _%' 

--task 16 Сделать график в колаб с количеством запущенных на воду кораблей и годом запуска (х-год, у - кол-во кораблей)

select * 
from ships s 

request = """
SELECT count('name'), launched
from ships
group by launched
order by count desc
"""

df = pd.read_sql_query(request,conn)
fig = px.bar(x=df.launched.to_list(), y=df['count'].to_list(), labels={'x': 'launched', 'y': 'count'})
fig.show()
