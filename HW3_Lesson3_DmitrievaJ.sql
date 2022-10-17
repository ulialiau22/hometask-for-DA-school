--- Домашнее задание к уроку 3

-- Task 1. Для каждого класса определить число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей

select class, count(name) 
from ships 
join 
outcomes 
on ships.name = outcomes.ship
where outcomes.result = 'sunk'
group by class

-- Task 2. Для каждого класса определить год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, 
-----------определите минимальный год спуска на воду кораблей этого класса. Вывести класс год. 

select class, min(launched) as date
from ships
group by class


-- Task 3. Для классов, имеющий потери в виде потопленных кораблей и не менее 3 кораблей в Базе данных, вывести имя класса и число потопленных кораблей 

select class, count(ship) 
from (
	select name, class 
	from ships
    union
    select ship, ship 
    from outcomes
    ) a
left join outcomes 
ON a.name = outcomes.ship AND result = 'sunk'
group by class
having count(ship) > 0 and count(*) > 2

-- Task 4. Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же  водоизмещения (учесть корабли из таблицы O) 

 with all_ships as (
  select name, class 
  from ships
  union
  select ship, ship 
  from outcomes
)
select name
  from all_ships join classes c1 on all_ships.class=c1.class
  where numGuns >= all(
    select c2.numGuns from classes c2
      where c2.displacement=c1.displacement
        and c2.class in (select all_ships.class from all_ships)
    )

-- Task 5. Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший RAM. Вывести maker


select maker 
from Product
where model in (
	select model 
	from PC
	where speed = (select max(speed) from PC where ram = (select min(RAM) from PC)) and RAM = any (select RAM from PC)
)
and maker in (select product.maker from Product where product.type='Printer')
group by maker

