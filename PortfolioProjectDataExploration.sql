SELECT * 
FROM PortfolioProject..CovidDeaths
ORDER BY location, date

SELECT * 
FROM PortfolioProject..CovidDeaths
ORDER BY location, date

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY location, date

-- Total Cases VS Total Deaths in Canada
SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%canada%'
ORDER BY location, date

-- Total Cases VS Population in Canada
SELECT location, date, population, total_cases, (total_cases / population) * 100 AS population_percentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%canada%'
ORDER BY location, date

-- Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) AS highest_infection_count, 
MAX((total_cases / population)) * 100 AS infection_percentage
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY infection_percentage DESC

-- Countries with Highest Death Count per Population
SELECT location, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC

-- Continents with Highest Death Count per Population 
SELECT location as continent, MAX(CAST(total_deaths AS BIGINT)) AS total_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
AND location NOT LIKE '%income'
AND location NOT IN ('World', 'International')
GROUP BY location
ORDER BY total_death_count DESC

-- Global Numbers
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS BIGINT)) AS total_deaths,  
SUM(CAST(new_deaths AS BIGINT)) / SUM(new_cases) AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY total_cases, total_deaths

-- Total Population VS Vaccinations Using CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, people_vaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT, vac.new_vaccinations)) 
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS people_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *,  (people_vaccinated / population) * 100 AS percentage
FROM PopvsVac

-- Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent text,
location text,
date datetime,
population numeric,
new_vaccinations numeric,
people_vaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT, vac.new_vaccinations)) 
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS people_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *,  (people_vaccinated / population) * 100 AS percentage
FROM #PercentPopulationVaccinated

-- Creating view to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT, vac.new_vaccinations)) 
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS people_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *
FROM PercentPopulationVaccinated
