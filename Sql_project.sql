SELECT * FROM INFORMATION_SCHEMA.TABLES

--List of countries that comes from Europe--

SELECT country_name, continent
FROM countries
WHERE continent = 'europe';

--List of cities with a population greater than 1 million--

SELECT name
FROM cities
WHERE city_proper_pop > 1000000;

--TOP 5 most populous cities--

SELECT TOP 5 city_proper_pop,name
FROM cities
ORDER BY city_proper_pop DESC;

--Calculating TOP 10 Gross savings growth from 2015 to 2019 --

 SELECT TOP 10 c.country_name,
        e.gross_savings,
		e2.gross_savings,
		(e2.gross_savings - e.gross_savings/e.gross_savings) * 100 as gross_savings_growth
 FROM economies2015 AS e
 JOIN economies2019 AS e2
 ON e.code = e2.code
 JOIN countries as c
 ON e.code = c.code
 ORDER BY gross_savings_growth desc;

 --List of countries in Europe that have a Gdp Per Capital greater than $5000 and population greater than 50 million in the year 2010----

SELECT
      c.country_name,
	  p.year, e.gdp_percapita,
	  p.population_size
FROM economies AS e
JOIN countries AS c
ON e.code = c.code
JOIN populations AS p
ON p.country_code = e.code
WHERE gdp_percapita > 10000 
      AND continent = 'europe' 
	  AND population_size >50000000
	  AND p.year = 2010  
ORDER BY population_size DESC;

--Calculating net export for the Top 5 countries in Europe --
SELECT TOP 5
      c.code, 
	  c.country_name,
	  e.exports - e.imports AS net_exports 
FROM countries AS C
JOIN economies AS e
ON c.code = e.code
WHERE continent = 'europe'
ORDER BY net_exports DESC;


--total population of EU countries that use "Euro" as currency--
 
SELECT SUM(population_size) as sum_pop
FROM populations AS p
WHERE p.country_code IN ( select c.code
                 from eu_countries AS ec
				 JOIN currencies AS c
				 on ec.code = c.code
				 WHERE c.curr_code = 'eur');

--Calculating the average GDP per capita greater than $5000 for countries with a population over 100 million in the year 2015--

WITH avg_percapita as 
(
SELECT 
      c.country_name,p.population_size, AVG(gdp_percapita) as avg_gdp_percapita
FROM economies AS e
JOIN countries AS c
ON e.code = c.code
JOIN populations AS p
ON p.country_code = c.code
WHERE population_size >1000000000 AND p.year = 2015
GROUP BY c.country_name,p.population_size
) 
SELECT *
FROM avg_percapita
WHERE avg_gdp_percapita > 5000;

--Using store procedure to get 10 most populous countries in 2015--

CREATE PROCEDURE top_10_mostpopulous_countries2015
 AS 
 BEGIN
      SELECT TOP 10 c.country_name, p.year,p.population_size
	  FROM countries AS c
	  JOIN populations AS p
	  ON c.code = p.country_code
	  WHERE p.year = 2015
	  ORDER BY population_size DESC;
 END;
 GO
 EXEC top_10_mostpopulous_countries2015
 
 CREATE PROCEDURE gross_savings2015_2019 
 AS
 BEGIN
      SELECT TOP 10 c.country_name,
        e.gross_savings,
		e2.gross_savings,
		(e2.gross_savings - e.gross_savings/e.gross_savings) * 100 as gross_savings_growth
 FROM economies2015 AS e
 JOIN economies2019 AS e2
 ON e.code = e2.code
 JOIN countries as c
 ON e.code = c.code
 END 
 GO

 exec gross_savings2015_2019


 















