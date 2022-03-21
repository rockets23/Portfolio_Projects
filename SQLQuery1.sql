
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Covid_Potfolio_project.dbo.CovidDeaths
Order by 1, 2



-- Total cases vs Total deaths
-- Shows the chances of you dying if you are infected with Covid in Belgium 

SELECT Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 AS percentage_deaths
FROM Covid_Potfolio_project.dbo.CovidDeaths
where location = 'Belgium' 
Order by 1, 2


--Total cases vs Population
-- Shows the percentage of population that got infected with Covid

SELECT Location, date, population,  total_deaths, (total_cases/population)*100 AS percentage_infections
FROM Covid_Potfolio_project.dbo.CovidDeaths

Order by 1, 2


--Highest infection rate in the world

SELECT Location, max((total_cases/population)*100) AS Highest_percentage_infections
FROM Covid_Potfolio_project.dbo.CovidDeaths
group by location
Order by Highest_percentage_infections desc

--Highest death count per Country

SELECT Location, max(total_deaths) as CountyDeathsCount
FROM Covid_Potfolio_project.dbo.CovidDeaths
WHERE continent is not null
group by location
Order by CountyDeathsCount desc

--Highest death count per continent 

SELECT Location, max(total_deaths) as CountyDeathsCount
FROM Covid_Potfolio_project.dbo.CovidDeaths
WHERE continent is null
group by location
Order by CountyDeathsCount desc


--The total cases and deaths per day in the world 

SELECT date, SUM(new_cases) AS totalCasesDay, Sum(New_deaths) AS totalDeathsDay
FROM Covid_Potfolio_project.dbo.CovidDeaths
group by date
order by date

-- Total cases and deaths since the begining of the pandemic all over the world

SELECT  SUM(new_cases) AS totalCasesDay, Sum(New_deaths) AS totalDeathsDay
FROM Covid_Potfolio_project.dbo.CovidDeaths

-- Looking at total population vs vaccination

SELECT  deaths.location, deaths.date, deaths.population, vacc.new_vaccinations 

From Covid_Potfolio_project.dbo.CovidDeaths deaths
join Covid_Potfolio_project.dbo.CovidVaccinations vacc

on deaths.location = vacc.location and deaths.date = vacc.date
WHERE deaths.continent is NOT  null

Order by CAST(new_vaccinations as int)

--Total vaccinations per location every day 


SELECT  deaths.location, deaths.date, deaths.population, vacc.new_vaccinations, SUM(CAST(vacc.new_vaccinations AS float)) OVER (Partition by deaths.location order by deaths.location,
deaths.date) as TotalVaccinationDayCountry

From Covid_Potfolio_project.dbo.CovidDeaths deaths
join Covid_Potfolio_project.dbo.CovidVaccinations vacc

on deaths.location = vacc.location and deaths.date = vacc.date
WHERE deaths.continent is NOT  null
order by deaths.location, deaths.date

 --Percentage the vaccinated population each day count

with vaccinations (location, date, population, new_vaccination, TotalVaccinationDayCountry) AS
(
 SELECT  deaths.location, deaths.date, deaths.population, vacc.new_vaccinations, SUM(CAST(vacc.new_vaccinations AS float)) OVER (Partition by deaths.location order by deaths.location,
deaths.date) as TotalVaccinationDayCountry

From Covid_Potfolio_project.dbo.CovidDeaths deaths
join Covid_Potfolio_project.dbo.CovidVaccinations vacc

on deaths.location = vacc.location and deaths.date = vacc.date
WHERE deaths.continent is NOT  null

)
select *, (TotalVaccinationDayCountry/population)*100 as percentagePerDay
from vaccinations
ORDER BY location,  percentagePerDay

     --  Creating a view

	 create view VaccinationDayCountry AS 
	  SELECT  deaths.location, deaths.date, deaths.population, vacc.new_vaccinations, SUM(CAST(vacc.new_vaccinations AS float)) OVER (Partition by deaths.location order by deaths.location,
deaths.date) as TotalVaccinationDayCountry

From Covid_Potfolio_project.dbo.CovidDeaths deaths
join Covid_Potfolio_project.dbo.CovidVaccinations vacc

on deaths.location = vacc.location and deaths.date = vacc.date
WHERE deaths.continent is NOT  null

