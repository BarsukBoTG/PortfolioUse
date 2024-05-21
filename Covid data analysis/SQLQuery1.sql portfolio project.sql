Select *
From PortfolioUse..CovidDeaths
order by 3,4;

--Select *
--From PortfolioUse..CovidVaccinations
--order by 3,4;

-- Select data for use case


Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioUse..CovidDeaths
order by 1,2

-- Looking at total cases vs Total deaths
--Shows likelihood of dying if contract covid.

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioUse..CovidDeaths
Where location like '%Russia'
order by 1,2

-- Looking at total cases vs population

Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioUse..CovidDeaths
Where location like '%Russia'
order by 1,2

-- Looking at countries with the Highest ifection rate compared to population

Select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioUse..CovidDeaths
--Where location like '%Russia'
group by location,population
order by PercentPopulationInfected desc

--Hightest death count per Population (data type issues. Has to use "cast")

--Let's find out about continents



Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioUse..CovidDeaths
--Where location like '%Russia'
Where continent is not null
group by continent
order by TotalDeathCount desc

--Showing continents with the highest death count per population

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioUse..CovidDeaths
--Where location like '%Russia'
Where continent is not null
group by continent
order by TotalDeathCount desc

--Global numbers

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioUse..CovidDeaths
--Where location like '%Russia'
Where continent is not null
--group by date
order by 1,2

--Looking at total population vs vaccination

--Use CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
From PortfolioUse..CovidDeaths dea
join PortfolioUse..CovidVaccinations vac
   on dea.location=vac.location
   and dea.date=vac.date
   Where dea.continent is not null
   --order by 2,3
   )
   Select *, (RollingPeopleVaccinated/population)*100
   from PopvsVac


   --Temp table
   Drop table if exists #PercentPopulationVaccinated

   Create table #PercentPopulationVaccinated
   (Continent nvarchar(255),
   Location nvarchar(255),
   date datetime,
   Population numeric,
   New_vaccinations numeric,
   RollingPeopleVaccinated numeric)

   Insert into #PercentPopulationVaccinated

   Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
From PortfolioUse..CovidDeaths dea
join PortfolioUse..CovidVaccinations vac
   on dea.location=vac.location
   and dea.date=vac.date
   --Where dea.continent is not null
   -- order by 2,3

   Select *, (RollingPeopleVaccinated/population)*100
   from #PercentPopulationVaccinated

   --Creating view to store data for later visualisations 
Use PortfolioUse
GO

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
From PortfolioUse..CovidDeaths dea
join PortfolioUse..CovidVaccinations vac
   on dea.location=vac.location
   and dea.date=vac.date
   Where dea.continent is not null
   -- order by 2,3