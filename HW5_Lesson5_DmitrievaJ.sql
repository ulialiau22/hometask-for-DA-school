--- Домашнее задание к уроку 5 

--- task 1 Сделать view, в котором будет постраничная разбивка всех продуктов (не более 2х продуктов на 1 стр)
----------- Вывод: все данные из laptop, номер страницы, список всех страниц 

create view pages_all_products as

select *,
case when rn % 2 = 0 then rn/2 else rn / 2+1 end as page_num,
case when rn % 2 = 0 then 2 else 1 end as position 
from (
	select*,
	row_number (*) over(order by price desc) as rn
	from laptop) a 
	
select *
from pages_all_products

--- task 2 Сделать view, в рамках которого будет процентное соотношение всех товаров по типу устройства.
---------- Вывод: производитель, тип, % 
--- Нахожу процентное соотношение от всех товаров по рынку 

create view percentage_product as 

with list_product as 
(select * 
from (
	(select price, model m from pc 
	union all
	select price, model m from printer
	union all
	select price, model m from laptop) l
join product 
on product.model = l.m))



select maker, type, cast(count(model) as float)/cast(min(aggre) as float) as percentage from (
select maker, type, model, (count(model) over (partition by type)) as aggre
from list_product) keks
group by maker, type
order by maker, type

select maker, type, percentage 
from percentage_product


--- task 3 Сделать на базе предыдущего view - график круговую диаграмму 
--- доля продуктов на рынке каждого производителя 

import plotly.express as px
request = """
select maker, avg(percentage)
from percentage_product
group by maker
"""

df = pd.read_sql_query(request,conn)
fig = px.pie(df, values='avg', names='maker')
fig.show()

--- task 4 Сделать копию таблицы ships, но название корабля должно состоять из двух слов

create table ships_two_words as 

select * 
from ships s 
where name like '_% _%' 

select *
from ships_two_words


--- task 5 Вывести список кораблей, у которых класс отсутствует и название начинается с буквы S 


select name
from ships s 
full join classes c 
on s.class = c.class
where name like 'S%' and c.class is null


--- task 6 Вывести все принтеры производителя А со стоимостью выше средней по принтерам производителя С и три самых дорогих
----------- Вывести модель

----- все принтеры производителя А со стоимостью выше средней по принтерам производителя С

with avg_price_printer_C as(
select avg(price)
from printer p
join product p2 
on p.model = p2.model 
where maker = 'C')

select p.model, price
from printer p
join product p2 
on p.model = p2.model 
where maker = 'A' and price > (select * from avg_price_printer_C) 

--- три самых дорогих принтера в разрезе производителей

with list_price as 
(select * 
from (
	(select price, model m 
	from printer) l
join product 
on product.model = l.m))

select maker, model, price, type
from (
	select *,
	row_number () over (partition by maker order by price desc) rn
	from list_price
	) a 

where rn = 1
