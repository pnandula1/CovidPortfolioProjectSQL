--Selecting all data from the Covid Deaths table, a table imported from Excel and available publicly at https://data.world/
select * from [PortfolioProject-DataExploration]..CovidDeaths$
order by 3,4

--Selecting the location, date, total cases, new cases, total death, and population columns from the Covid Deaths table
select location, date, total_cases, new_cases, total_deaths, population 
from [PortfolioProject-DataExploration]..CovidDeaths$
order by 1,2

--Total cases vs. Total deaths
--Likelihood of catching covid and dying
select location, date, total_cases, total_deaths, (Convert(float, total_deaths))/(Convert(float,total_cases))*100 as DeathPercentage
from [PortfolioProject-DataExploration]..CovidDeaths$
where location like '%states%'
order by 1,2

--% of population that has gotten covid
select location, date, total_cases, population, (Convert(float, total_cases))/(Convert(float, population))*100 as PercentPopCovid
from [PortfolioProject-DataExploration]..CovidDeaths$
where location like '%states%'
order by 1,2

--Querying for infection rate by country
select location, population, MAX(total_cases) as HighInfectionCount, MAX((Convert(float, total_cases))/(Convert(float, population))*100) as PercentPopCovid
from [PortfolioProject-DataExploration]..CovidDeaths$
Group by location, population
order by 4 DESC

--Countries with highest death count per population
create view HighestDeathCount as
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from [PortfolioProject-DataExploration]..CovidDeaths$
where continent is not null
Group by location
--order by 2 desc


--Showing continents with highest death count
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from [PortfolioProject-DataExploration]..CovidDeaths$
where continent is not null
Group by continent
order by 2 desc

--Global numbers 
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from [PortfolioProject-DataExploration]..CovidDeaths$
where continent is not null
Group by continent
order by 1,2

--Joining both tables
select * from [PortfolioProject-DataExploration]..CovidDeaths$ dea
join [PortfolioProject-DataExploration]..CovidVax$ vax
	on dea.location = vax.location
	and dea.date = vax.date

--Total population vs. vaccinations
--Adding up each row
select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, SUM(cast(vax.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.Date) as 'Rolling People Vaccinated'
from [PortfolioProject-DataExploration]..CovidDeaths$ dea
join [PortfolioProject-DataExploration]..CovidVax$ vax
	on dea.location = vax.location
	and dea.date = vax.date
where dea.continent is not null
order by 2,3

--Creating View to store data for later visualization
--% of population vaccinated
create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, SUM(cast(vax.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.Date) as 'Rolling People Vaccinated'
from [PortfolioProject-DataExploration]..CovidDeaths$ dea
join [PortfolioProject-DataExploration]..CovidVax$ vax
	on dea.location = vax.location
	and dea.date = vax.date
where dea.continent is not null

--Selecting data from view
select * from PercentPopulationVaccinated









