--Covid Deaths Table

Select * 
from CovidDeaths 
where continent IS NOT NULL 
order by 3,4

--Select location, date, total_cases, new_cases, total_deaths, population from CovidDeaths order by 1,2

--Total Cases Vs Total Death in a Day for each date
Select location, date, total_deaths, total_cases, Round((total_deaths/total_cases)*100,2) as DeathRate 
from CovidDeaths 
where location='Nepal' 
order by 2

--Total cases VS Total Population (shows percentage of infection)
Select location, date, population, total_cases, (total_cases/population)*100 as CovidInfectionRate 
from CovidDeaths 
where location='Nepal' 
order by 2

--Highest Infection Rate in the world
Select location, population, max(total_cases) as TotalCases, max((total_cases/population)*100) as CovidInfectionRate 
from CovidDeaths 
group by location, population 
order by 4 Desc

--Death Rate of Nepal as per total cases
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRate 
from CovidDeaths 
where location='Nepal' 
order by 5 Desc

--Total Deaths Per Country

Select Location,max(cast(total_deaths as int)) as TotalDeathCount 
from CovidDeaths 
where continent IS NOT NULL 
group by location 
order by TotalDeathCount desc 

-- Total Deaths By Continent

Select location,continent,max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths 
where continent IS NULL 
group by location,continent 
order by TotalDeathCount desc 

--DateWise Death Rate per New Cases Everyday in the world
 
 Select date, sum(new_cases) as Total_New_Cases, sum(cast(new_deaths as int)) as total_New_deaths, sum(cast (new_deaths as int))/sum(new_cases)*100 as World_NewDeathRate 
 from CovidDeaths 
 where continent is not null 
 group by date
 order by 1,2

 --Total Global Death rate (Global_totalcases/Global_total deaths)
 Select sum(new_cases) as Total_New_Cases, sum(cast(new_deaths as int)) as total_New_deaths, sum(cast (new_deaths as int))/sum(new_cases)*100 as World_NewDeathRate 
 from CovidDeaths 
 where continent is not null 
 order by 1,2

 
 --Covid Vaccination Table

Select * 
from CovidVaccination
where continent IS NOT NULL 
order by 3,4


Select cd.continent,cd.location,cd.population,cv.new_vaccinations from CovidDeaths as CD
join CovidVaccination as CV
ON CD.location=CV.location And cd.date=cv.date 
where cd.continent IS NOT NULL
order by 2,3


Select cd.continent,cd.location, cd.date,cd.population,cv.new_vaccinations,
Sum(cast(cv.new_vaccinations as int)) OVER (PARTITION BY cd.location order by cd.location,cd.date) As TotalVaccinations
from CovidDeaths as CD
join CovidVaccination as CV
ON CD.location=CV.location And cd.date=cv.date 
where cd.continent IS NOT NULL
order by 2,3

--with Temp Table
--Drop Table If exists #Vaccinate
--Create Table #Vaccinate(
--continent nvarchar(255),
--location nvarchar(255),
--Date datetime,
--population numeric,
--new_vaccinations numeric,
--TotalVaccinations numeric
--)

--Insert Into #Vaccinate
--Select cd.continent,cd.location, cd.date,cd.population,cv.new_vaccinations,
--Sum(cast(cv.new_vaccinations as int)) OVER (PARTITION BY cd.location order by cd.location,cd.date) As TotalVaccinations
--from CovidDeaths as CD
--join CovidVaccination as CV
--ON CD.location=CV.location And cd.date=cv.date 
--where cd.continent IS NOT NULL

--Select * ,(totalvaccinations/population)*100 as VaccinationRate from #Vaccinate

--With CTES
With vac(continent, location, date, population, new_vaccinations, TotalVaccinations)
As
(
Select cd.continent,cd.location, cd.date,cd.population,cv.new_vaccinations,
Sum(cast(cv.new_vaccinations as int)) OVER (PARTITION BY cd.location order by cd.location,cd.date) As TotalVaccinations
from CovidDeaths as CD
join CovidVaccination as CV
ON CD.location=CV.location And cd.date=cv.date 
where cd.continent IS NOT NULL
)
 Select * ,(totalvaccinations/population)*100 as VaccinationRate from vac


 --Creating view for later usage
Create View 
TotalVaccinated as
Select cd.continent,cd.location, cd.date,cd.population,cv.new_vaccinations,
Sum(cast(cv.new_vaccinations as int)) OVER (PARTITION BY cd.location order by cd.location,cd.date) As TotalVaccinations
from CovidDeaths as CD
join CovidVaccination as CV
ON CD.location=CV.location And cd.date=cv.date 
where cd.continent IS NOT NULL
 
 Select * from TotalVaccinated