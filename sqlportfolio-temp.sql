
select *
from CovidDeaths
where continent is not null

--select * 
--from CovidVaccinations
--order by 3, 4

-- select data that we are going to be using

select location, date, total_cases_per_million, new_cases, total_deaths, population
from CovidDeaths
order by 1,2

--Looking at total_cases Vs total_deaths
--likelyhood of dying if you get effected by the covid


--select location,
--		date,
--		total_cases_per_million,
--		total_deaths,
--		(cast (total_deaths as float)/ cast (total_cases_per_million as float))*100 as DeathPercentage
--from CovidDeaths
--order by 1, 2

SELECT location, 
       date, 
       total_cases_per_million, 
       total_deaths, 
       CASE 
           WHEN CAST(total_cases_per_million AS FLOAT) = 0 THEN NULL
           ELSE ROUND((CAST(total_deaths AS FLOAT) / CAST(total_cases_per_million AS FLOAT)) * 100, 2)
       END AS DeathPercentage
FROM CovidDeaths

WHERE ISNUMERIC(total_deaths) = 1 
  AND ISNUMERIC(total_cases_per_million) = 1
  AND location like '%state%'
ORDER BY 1, 2;

--looking total cases vs population
-- shows the percentage of population got covid

SELECT location, 
       date, 
       total_cases_per_million, 
       population, 
       CASE 
           WHEN CAST(total_cases_per_million AS FLOAT) = 0 THEN NULL
           ELSE ROUND((CAST(total_cases_per_million AS FLOAT) / CAST(population AS FLOAT)) * 100, 2)
       END AS DeathPercentage
FROM CovidDeaths

WHERE ISNUMERIC(population) = 1 
  AND ISNUMERIC(total_cases_per_million) = 1
ORDER BY 1, 2;

--looking at countries where highest infection rate compared to population

SELECT 
    location, 
    population,
    MAX(CAST(total_cases_per_million AS FLOAT)) AS HighestInfectionCount,
    MAX(
        CASE 
            WHEN CAST(population AS FLOAT) = 0 THEN NULL
            ELSE (CAST(total_cases_per_million AS FLOAT) / CAST(population AS FLOAT)) * 100
        END
    ) AS percentagepopulationInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY percentagepopulationInfected DESC;

--showing countries with highest death per population SELECT

--FROM
--WHERE ← filters before grouping
--GROUP BY
--HAVING ← filters after grouping
--ORDER BY

SELECT 
    location, 
    MAX(cast(total_deaths as int)) AS totalDeathsCount
FROM CovidDeaths
WHERE continent IS NOT NULL  
GROUP BY location
ORDER BY totalDeathsCount DESC;

--Lets break things down by continent

SELECT distinct continent,
     
    MAX(CAST(total_deaths AS INT)) AS totalDeathsCount
FROM CovidDeaths

GROUP BY continent
ORDER BY totalDeathsCount DESC;

--Global numbers
SELECT 
    SUM(CAST(new_cases AS INT)) AS total_cases, 
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    CASE 
        WHEN SUM(CAST(new_cases AS INT)) = 0 THEN NULL
        ELSE ROUND((SUM(CAST(new_deaths AS INT)) * 100.0) / SUM(CAST(new_cases AS INT)),2)
    END AS DeathPercentage
FROM CovidDeaths
ORDER BY 1,2;

--connecting tables and see total population vs vaccination 

select cov.continent, cov.location, cov.date, cov.population, vac.new_vaccinations,
SUM(cast (new_vaccinations as int)) over (partition by cov.location order by cov.location, cov.date)
from CovidDeaths cov
join CovidVaccinations vac
on cov.location = vac.location
and cov.date = vac.date
where cov.continent is not null
order by 2,3 

select continent, count (cast(total_deaths as int)) as TotoalDeath
from CovidDeaths
group by continent 
order by TotoalDeath desc


