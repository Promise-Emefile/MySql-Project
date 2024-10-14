CREATE DATABASE My_Project;
USE My_Project;

select * from athlete_events;

# How Many Olimpic Games were celebrated
Select count(distinct year) 
 from athlete_events;

# list of Olympic games celebrated
 select distinct games
 from athlete_events;
 
 # Total Numbers of countries that participated in all Olympic games
  Select count(distinct noc) as num_countries, games from athlete_events
  group by games;


(select year, count(distinct noc) as num_countries_max from athlete_events
group by year
order by num_countries_max desc
limit 1)
UNION
(select year, count(distinct noc) as num_countries_min from athlete_events
group by year
order by num_countries_min asc
limit 1);

Countries that has participated in all olympic tournament

select noc, count(distinct year) from athlete_events
group by noc
having count(distinct year)= (select count(distinct noc) from athlete_events);

#Find the sport that was played in all the summer olympic games
select * from athlete_events;
select season, sport, count(distinct games) from athlete_events
where season = 'summer'
group by sport
having count(distinct games) = (select count(distinct games) from athlete_events
where season="summer");

#Find the sport that was played in all the summer olympic games and
#build a table with 2 columns: names of sport and how many times it was played

create temporary table t1(select count(distinct games) as Total_Og_summer from athlete_events
where season="summer"
order by games);
select * from t1;

create temporary table t3 (select sport, count(games) as Num_Og
from(select distinct sport, games from athlete_events
where season = 'summer'
order by games) as X
group by sport);

select * from t3;

select t3.sport, t3.num_og from t3
inner join t1
on t3.num_og = t1.total_og_summer; 

#Total number of sports played on every olympic games

select games, count(distinct sport) from athlete_events
group by games;

#Ratio of Male and Female athletes who participated in all the Olympic Games

select 
year,
Round(MaleCount/TotalCount, 2) as MaleProportion,
Round(femaleCount/TotalCount, 2) as femaleProportion
from
(select year, count(*) As TotalCount,
SUM(case when sex = 'm' then 1 ELSE 0 END) as MaleCount,
SUM(case when sex = 'f' then 1 ELSE 0 END) as FemaleCount
From athlete_events
group by year) as subquery
Order by Year;

#Top 5 athletes that have won the most gold medals
select * from athlete_events;
create temporary table s2
(select name, count(medal) as Total_Gold from athlete_events
where medal = "Gold"
group by name
order by Total_Gold desc);

select * from s2;

select *
from (select s2.*,
        DENSE_RANK() over(order by s2.Total_Gold desc) as DRK
from s2) as ranked
where DRK<=5;

#Top 5 athlete who have won the most medals (Gold,Sliver,Bronze)

Select
Name,
SUM(CASE WHEN Medal ="GOLD" THEN 1 ELSE 0 END) AS GOLD,
SUM(CASE WHEN Medal ="SILVER" THEN 1 ELSE 0 END) AS SILVER,
SUM(CASE WHEN Medal ="BRONZE" THEN 1 ELSE 0 END) AS BRONZE,
count(*) as Total_medals
from athlete_events
WHERE Medal IN ('GOLD', 'SILVER', 'BRONZE')
GROUP By name
ORDER BY Total_medals DESC
LIMIT 5;

#Sports/Events in which the United States won the most medals

select
Sport,
Event,
SUM(CASE WHEN Medal ="GOLD" THEN 1 ELSE 0 END) AS GOLD,
SUM(CASE WHEN Medal ="SILVER" THEN 1 ELSE 0 END) AS SILVER,
SUM(CASE WHEN Medal ="BRONZE" THEN 1 ELSE 0 END) AS BRONZE
from athlete_events
where Team = 'United States'
Group by Sport, Event
Order by Gold DESC, Silver Desc, Bronze Desc;





