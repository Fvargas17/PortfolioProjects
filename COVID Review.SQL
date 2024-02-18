
/*Apartado de formulas para conversiones
Convierte un nvarchar a float para hacer calculos
--select convert (float , dbo.[Covid Deaths].total_cases))) as Prueba



----------------------------------------------------------------------------------------------------*/
--SELECT * FROM 
--PortfolioProject..[Covid Deaths]
--ORDER BY 3,4

--SELECT * FROM 
--PortfolioProject..[Covid Vaccinations]
--ORDER BY 3,4


--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..[Covid Deaths]
--ORDER BY 1,2


---- Casos totales vs Muertes totales

--SELECT location, date, total_cases, total_deaths, (total_deaths/(select convert (float , dbo.[Covid Deaths].total_cases)))*100 as Porcentaje_de_muertos
--FROM PortfolioProject..[Covid Deaths]
--where location like '%states%'
--ORDER BY Porcentaje_de_muertos

---- Casos totales vs poblacion

--SELECT location, date, population, total_cases,  (total_cases/(select convert (float , dbo.[Covid Deaths].population)))*100 as Porcentaje_de_poblacion
--FROM PortfolioProject..[Covid Deaths]
--ORDER BY Porcentaje_de_poblacion


----Mayores lugares con porcentaje de infeccion

--Select continent,location, population, max(total_cases) as Conteo_de_infecciones, max(total_cases/population)*100 as Porcentaje_De_infectados
--from PortfolioProject.dbo.[Covid Deaths]
--group by continent,location, population
--order by Porcentaje_De_infectados DESC

---- Contientes con mayor porcentaje de muertes por poblacion

--select continent as continente, population as poblacion, max(total_deaths) as Muertos_totales,max(total_deaths/population)*100 as porcentaje_de_muertos
--from PortfolioProject.dbo.[Covid Deaths]
--where continent is not null
--group by continent, population,total_deaths
--order by porcentaje_de_muertos desc

--select location, max(total_deaths) as Muertos_totales
--from PortfolioProject.dbo.[Covid Deaths]
--where continent is not null
--group by location
--order by Muertos_totales desc

-- Let's breake things down by continent




---- Enseñando los contienentes con el mayor numero de muertos por cantidad de gente.

--select location, max(total_deaths) as Muertos_totales
--from PortfolioProject.dbo.[Covid Deaths]
--where continent is not null
--group by location
--order by Muertos_totales desc

---- Global numbers


--SELECT 
--    date, 
--    SUM(new_cases) AS Nuevos_casos, 
--    SUM(CAST(new_deaths AS int)) AS Nuevas_muertes, 
--    CASE 
--        WHEN SUM(CAST(new_deaths AS int)) = 0 THEN 0 -- Manejo de división por cero
--        ELSE SUM(CAST(new_deaths AS int)) /    SUM(CAST(new_cases AS float)) *100
--    END AS porcentaje
--FROM 
--    PortfolioProject.dbo.[Covid Deaths]
--WHERE 
--    continent IS NOT NULL
--GROUP BY 
--    date
--ORDER BY 
--    porcentaje desc

--Total de pobalacion vs gente vacunada

--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (Partition by dea.location order by dea.location, dea.date) as Suma_de_vacunas
--FROM PortfolioProject.dbo.[Covid Deaths] dea JOIN PortfolioProject.dbo.[Covid Vaccinations] vac
--	ON dea.location = vac.location and dea.date = vac.date
--	where --dea.location = 'Mexico'
--	dea.continent is not null and vac.new_vaccinations is not null
--	order by 2,3
	

	
--	-- Usando una cte

--	With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Suma_de_vacunas)
--	as
--	(
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (Partition by dea.location order by dea.location, dea.date) as Suma_de_vacunas
--FROM PortfolioProject.dbo.[Covid Deaths] dea JOIN PortfolioProject.dbo.[Covid Vaccinations] vac
--	ON dea.location = vac.location and dea.date = vac.date
--	where --dea.location = 'Mexico'
--	dea.continent is not null and vac.new_vaccinations is not null
--	--order by 2,3
--	)
--	Select *, (Suma_de_vacunas/Population)*100 as Porcentaje_de_vacunas_aplicadas
--	from PopvsVac
	
--	--Usando una tabla temporal
--	Drop table if exists #Porcentaje_de_poblacion_vacuanda
--	Create table #Porcentaje_de_poblacion_vacuanda
--	--Declarando los datos de la tabla temporal
--	(Continent nvarchar(255),
--	location nvarchar(255),
--	date datetime,
--	population numeric,
--	new_vaccinations numeric,
--	Suma_de_vacunas numeric)

--	--Insertando los datos en la tabla
--	Insert into  #Porcentaje_de_poblacion_vacuanda
--	SELECT dea.continent,
--	dea.location,
--	dea.date,
--	dea.population,
--	vac.new_vaccinations,
--	sum(cast(vac.new_vaccinations as bigint)) over (Partition by dea.location order by dea.location, dea.date) as Suma_de_vacunas

--	--Uniendo las dos tablas base
--	FROM PortfolioProject.dbo.[Covid Deaths] dea JOIN PortfolioProject.dbo.[Covid Vaccinations] vac
--		ON dea.location = vac.location and dea.date = vac.date
--	where 
--	dea.continent is not null and vac.new_vaccinations is not null
	
	
--	Select *, (Suma_de_vacunas/Population)*100 as Porcentaje_de_vacunas_aplicadas
--	from #Porcentaje_de_poblacion_vacuanda
	

--	-- Creando una vista para almacenar datos para visualizaciones despues
--	Create View Porcentaje_de_poblacion_vacuanda as

--	SELECT dea.continent,
--	dea.location,
--	dea.date,
--	dea.population,
--	vac.new_vaccinations,
--	sum(cast(vac.new_vaccinations as bigint)) over (Partition by dea.location order by dea.location, dea.date) as Suma_de_vacunas

--	FROM PortfolioProject.dbo.[Covid Deaths] dea JOIN PortfolioProject.dbo.[Covid Vaccinations] vac
--		ON dea.location = vac.location and dea.date = vac.date
--	where --dea.location = 'Mexico'
--	dea.continent is not null and vac.new_vaccinations is not null
--	--order by 2,3