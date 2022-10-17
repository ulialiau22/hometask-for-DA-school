--- Домашнее задание к уроку 2 

-- Task 1. Вывести name, class по кораблям, выпущенным после 1920

select class, name
from ships
where launched > 1920

-- Task 2. Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942

select class, name
from ships
where launched between 1920 and 1942

-- Task 3. Какое количество кораблей в каждом классе. Вывести количество и класс

select class,count(*)
from ships
group by class

-- Task 4. Для классов кораблей, калибр оружий которых не менее 16, укажите класс и страну

select country, class 
from classes
where bore > 16


-- Task 5. Укажите корабли, потопленные в сражениях в Северной Атлантике

select ship, result, battle 
from outcomes
where result = 'sunk' and battle = 'North Atlantic'


-- Task 6. Вывести название последнего потопленного корабля

select ship, max(battles.date)
from outcomes
join battles
on outcomes.battle = battles.name
where result = 'sunk' 
group by ship
order by max(battles.date) desc


-- Task 7. Вывести название и класс последнего потопленного корабля

select *
from outcomes join battles on outcomes.battle = battles.name 
join ships on outcomes.ship = ships.name
where result = 'sunk'


-- Task 8. Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены  

select ship
from classes join ships on classes.class = ships.class join outcomes on ships.name = outcomes.ship
where result = 'sunk' and bore > 16


-- Task 9. Вывести все классы кораблей, выпущенных США

select class, country 
from classes
where country = 'USA'

-- Task 10. Вывести все корабли, выпущенные США 

select name
from classes
join ships
on classes.class = ships.class
where country = 'USA'

