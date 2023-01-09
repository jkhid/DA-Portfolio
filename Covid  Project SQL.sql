use [Covid Project Database]
-- Preview the data 

select *
from [Covid Project Database]..CovidDeaths
where continent is not null
order by 3, 4

Select  *
from [Covid Project Database]..CovidVaccinations
where continent is not null
order by 3, 4

-- Select the data that will be analyzed

select location, date,  total_cases, new_cases, total_deaths, population
from [Covid Project Database]..CovidDeaths
order by 1, 2

-- Total Cases vs Total Deaths
-- Shows the liklihood of mortality when looking at total deaths compared to total cases

select location, date,  total_cases, total_deaths, round((total_deaths/total_cases) * 100, 2) as 'Mortality_Rate'
from [Covid Project Database]..CovidDeaths
order by 1, 2

-- Total Cases vs Population
-- Shows the percentage of the population that contracted Covid

select location, date,  total_cases, population, round((total_cases/population) * 100, 2) as 'Population_Infected'
from [Covid Project Database]..CovidDeaths
order by 1, 2

-- Which countries have the highest infection rate compared to population

select location, population, max(total_cases) as 'Highest_Infection_Count',
round(max(total_cases/population) * 100, 2) as 'Population_Infected'
from [Covid Project Database]..CovidDeaths
group by location, population
order by 4 desc

-- Which countries have the highest deaths rate compared to population 

select location, population, max(cast(total_deaths as int)) as 'Highest_Death_Count',
round((max(total_deaths)/population) * 100, 2) as 'Population_Death_Percentage'
from [Covid Project Database]..CovidDeaths
where continent is not null
group by location, population
order by 4 desc

-- Looking at the total death count by Continent

select location, max(cast(total_deaths as int)) as 'Highest_Death_Count'
from [Covid Project Database]..CovidDeaths
where continent is null
group by location
order by 2 desc

-- Global number of cases and deaths by date

select date, sum(new_cases) as 'Global_Cases', sum(cast(new_deaths as int)) as 'Global_Deaths',
sum(new_cases)/sum(cast(new_deaths as int)) as 'Global_Death_Percentage'
from [Covid Project Database]..CovidDeaths
where continent is not null
group by date
order by 1,2

-- Total global number of cases and deaths

select sum(new_cases) as 'Global_Cases', sum(cast(new_deaths as int)) as 'Global_Deaths',
sum(cast(new_deaths as int))/sum(new_cases) * 100 as 'Global_Death_Percentage'
from [Covid Project Database]..CovidDeaths
where continent is not null
order by 1,2

-- Joining the CovidDeaths and CovidVaccinations tables 
-- How much of the total population got vaccinated 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as 'Rolling_Vaccinations,'
from [Covid Project Database]..CovidDeaths dea
join [Covid Project Database]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

--- Create CTE
with PopvsVac (continent, location, date, population, new_vaccinations, Rolling_Vaccinations)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as 'Rolling_Vaccinations,'
from [Covid Project Database]..CovidDeaths dea
join [Covid Project Database]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
select *, (Rolling_Vaccinations/population) * 100
from PopvsVac

--- Create Temp Table

drop table if exists #PercentVaccinated
create table #PercentVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Rolling_Vaccinations numeric
)

insert into #PercentVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as 'Rolling_Vaccinations,'
from [Covid Project Database]..CovidDeaths dea
join [Covid Project Database]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *, (Rolling_Vaccinations/population) * 100
from #PercentVaccinated

-- Create view for percent of population vaccinated

create view PercentPopVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as 'Rolling_Vaccinations,'
from [Covid Project Database]..CovidDeaths dea
join [Covid Project Database]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

-- Create view for global number of cases and deaths

create view GlobalNumbers as
select sum(new_cases) as 'Global_Cases', sum(cast(new_deaths as int)) as 'Global_Deaths',
sum(cast(new_deaths as int))/sum(new_cases) * 100 as 'Global_Death_Percentage'
from [Covid Project Database]..CovidDeaths
where continent is not null

-- Create view for total deaths by continent
create view ContinentDeathCount as
select location, max(cast(total_deaths as int)) as 'Highest_Death_Count'
from [Covid Project Database]..CovidDeaths
where continent is null
group by location