-- dataset of covid_deaths
select *
from portfolio-project-315209.covid19.covid_deaths

-- dataset of covid_vaccinations
select count(*)
from portfolio-project-315209.covid19.covid_vaccinations

-- looking at total_deaths to total_cases ratio
select 
	location, 
	date, 
	total_cases, 
	total_deaths, 
	(total_deaths/total_cases)*100 as death_percentage
from portfolio-project-315209.covid19.covid_deaths

-- death percentage in india
select 
	location, 
	date, 
	total_cases, 
	total_deaths, 
	Round((total_deaths/total_cases)*100,2) as death_percentage
from portfolio-project-315209.covid19.covid_deaths
where location like "India"
order by date

-- looking at total_cases vs population
select 
	location, 
	date, 
	total_cases, 
	population, 
	(total_cases/population)*100 as cases_per_population
from portfolio-project-315209.covid19.covid_deaths
order by location,date

-- percentage cases in population in india
select 
	date, 
	total_cases, 
	population, 
	round((total_cases/population)*100,4) as cases_per_population
from portfolio-project-315209.covid19.covid_deaths
where location like "India"
order by date

-- looking for countries with high infection rate
select 
	location, 
	population, 
	max(total_cases) as total_cases,  
	max(round((total_cases/population)*100,4)) as cases_per_population
from portfolio-project-315209.covid19.covid_deaths
group by location, population
order by cases_per_population desc

-- countries with highest death per population percentage
select 
	location, 
	max(total_deaths) as total_deaths
from portfolio-project-315209.covid19.covid_deaths
group by location
order by total_deaths desc 

-- Now calculating World numbers in top 50 countries
select 
	date, 
	sum(new_cases) as new_cases, 
	sum(new_deaths) as new_deaths, 
	round((sum(new_deaths)/sum(new_cases))*100,4) as death_percentage
from portfolio-project-315209.covid19.covid_deaths
group by date
order by  date

-- total cases and deaths along with death percentage in top 50 countries
select 
	sum(new_cases) as new_cases, 
	sum(new_deaths) as new_deaths, 
	round((sum(new_deaths)/sum(new_cases))*100,4) as death_percentage
from portfolio-project-315209.covid19.covid_deaths

-- now I am joining death and vaccination table
select 
	dth.location, 
	dth.date, 
	dth.population, 
	new_vaccinations
from portfolio-project-315209.covid19.covid_deaths dth
join portfolio-project-315209.covid19.covid_vaccinations vac using(location,date)
order by dth.location, dth.date

-- looking at total vaccination vs population
select 
    dth.location, 
    dth.date, 
    dth.population, 
    new_vaccinations,
    sum(new_vaccinations) over (partition by dth.location order by dth.date, dth.location) as people_vaccinated
from portfolio-project-315209.covid19.covid_deaths dth
join portfolio-project-315209.covid19.covid_vaccinations vac using(location,date)
order by dth.location, dth.date

