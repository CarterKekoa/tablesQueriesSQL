/*----------------------------------------------------------------------
 * Name: Carter Mooring
 * File: hw6.sql
 * Date: Nov. 3rd, 2020
 * Class: CPSC 321 Databases
 * Description: This file creates Tables for countries, provinces, cities, and borders. It populates them
   		  and runs various queries on them to output specific tables. All queries structures are 
		  described above where they are created. The PDF with this file describes it more. 
 ----------------------------------------------------------------------*/
 
-- Start using emacs: emacs -nw hw4.sql  
-- TO Save: hold 'control' and type 'xs'
-- TO SEARCH: 'control s' to 'control g' to quit
-- end of line: 'control e'
-- recenter: 'conrtol l'

-- required in MariaDB to enforce constraints
SET sql_mode = STRICT_ALL_TABLES;

-- table deletion after done running
DROP TABLE IF EXISTS borderingCountries;
DROP TABLE IF EXISTS border;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS province;
DROP TABLE IF EXISTS country;

-- table creation
CREATE TABLE country(
  country_code VARCHAR (10),
  country_name VARCHAR (40),
  gdp INT UNSIGNED,
  inflation DECIMAL(3,2) NOT NULL,
  PRIMARY KEY (country_code)
);

CREATE TABLE province(
  province_name VARCHAR (40),
  country_code VARCHAR (10),
  area INT UNSIGNED,
  PRIMARY KEY (province_name, country_code),
  FOREIGN KEY (country_code) REFERENCES country (country_code)
);

CREATE TABLE city(
  city_name VARCHAR (30),
  province_name VARCHAR (40),
  country_code VARCHAR (40),
  population INT UNSIGNED,
  PRIMARY KEY (city_name, province_name, country_code),
  FOREIGN KEY (province_name, country_code) REFERENCES province (province_name, country_code)
);

CREATE TABLE border(
  country_code_1 VARCHAR (40),
  country_code_2 VARCHAR (40),
  border_length INT UNSIGNED,
  PRIMARY KEY (country_code_1, country_code_2),
  FOREIGN KEY (country_code_1) REFERENCES country (country_code),
  FOREIGN KEY (country_code_2) REFERENCES country (country_code)
);


-- table population
-- To View Tables: select * from recordLabel;

INSERT INTO country VALUES
       ("USA", "United States of America", 20540000, 1.4),
       ("CA", "Canada", 100000, 2.3),
       ("A", "A", 10000, 3),
       ("B", "B", 20000, 0.8),
       ("C", "C", 30000, 1.4),
       ("D", "D", 50000, 3),
       ("E", "E", 40000, 2);

INSERT INTO province VALUES
       ("Washington", "USA", 184830),
       ("a1", "A", 11000),
       ("a2", "A", 1200),
       ("a3", "A", 13000),
       ("b1", "B", 210),
       ("c1", "C", 3100),
       ("d1", "D", 40000),
       ("d2", "D", 4000),
       ("e1", "E", 500),
       ("e2", "E", 5000);

INSERT INTO city VALUES
       ("Seattle", "Washington", "USA", 744955),
       ("11", "a1", "A", 1100),
       ("12", "a1", "A", 12000),
       ("13", "a1", "A", 130),
       ("21", "b1", "B", 21000),
       ("41", "d1", "D", 40),
       ("51", "e1", "E", 500);

INSERT INTO border VALUES
       ("USA", "CA", 8891),
       ("A", "B", 1000),
       ("A", "C", 2000),
       ("B", "C", 3000),
       ("D", "E", 4000);

-- Queries

-- 2. Write an SQL query to find the countries containing a province with a small area, but where the country has low inflation and high gdp. Use specific values for the area, inflation, and gdp cutoffs as appropriate to fit your data. Your query should return the name, code, gdp, and inflation for each such country, and only return one row per matching country. Your query must use a comma join.
SET @area = 1000000;
SET @inflation = 2;
SET @gdp = 10000;
SELECT DISTINCT c.country_code, c.country_name, c.gdp, c.inflation
FROM country c, province p
WHERE p.area < @area AND c.country_code = p.country_code
      AND c.inflation < @inflation
      AND c.gdp > @gdp;

-- 3. Rewrite your query from (2) using inner JOIN syntax.
SET @area = 1000000;
SET @inflation = 2;
SET @gdp = 10000;
SELECT DISTINCT c.country_code, c.country_name, c.gdp, c.inflation
FROM country c JOIN province p USING(country_code)  
WHERE p.area < @area
      AND c.inflation < @inflation
      AND c.gdp > @gdp;

-- 4. Write an SQL query that finds the set of all provinces that have at least one city with a population greater than 1000. Return the country code, country name, province name, and province area. Your query must use comma joins.

SELECT DISTINCT p.country_code, co.country_name, p.province_name, p.area
FROM province p, city c, country co
WHERE c.population > 1000
      AND c.province_name = p.province_name
      AND co.country_code = p.country_code;

-- 5. Rewrite your query from (4) using inner JOIN syntax for all of the joins.
SELECT DISTINCT p.country_code, co.country_name, p.province_name, p.area
FROM province p JOIN country co JOIN city c USING(province_name)
WHERE c.population > 1000
      AND c.province_name = p.province_name
      AND co.country_code = p.country_code;

-- 6. Write an SQL query that finds the total area of all of the provinces within countries that have a gdp within a given range of values. Your query should return the total area.
SET @top = 1000000;
SET @bottom = 1000;
SELECT SUM(p.area)
FROM province p JOIN country c USING(country_code)
     WHERE c.gdp < @top
     AND c.gdp > @bottom;

-- 7. Write an SQL query that finds the mininim, maximum, and average of both gdp and inflation of each country.
SELECT MIN(gdp), MAX(gdp), AVG(gdp), MIN(inflation), MAX(inflation), AVG(inflation)
FROM country c;

-- 8. Write an SQL query that finds the number of cities and the average population within a specific country. You choose which country.
SET @country = 'A';
SELECT c.country_code, COUNT(c.city_name), AVG(c.population)
FROM city c
WHERE c.country_code = @country;

-- 9. Write an SQL query that finds the average population of cities that are within the same province and country as a given city. Do not include the given city’s population in the average population calculation.
SET @city = 11;
SELECT AVG(c.population)
FROM city c JOIN province p USING(province_name, country_code)
WHERE c.country_code IN (SELECT country_code FROM city WHERE city_name = @city)
      AND c.city_name != @city
      AND c.province_name IN (SELECT province_name FROM city WHERE city_name = @city);

-- 10. Write an SQL query that finds the average population for each country in your database. The population of a country is the total population of each city in the country’s provinces.
SELECT c.country_name, AVG(c2.population)
FROM country c JOIN city c2 USING(country_code)
GROUP BY country_code;

-- 11. Write an SQL query that finds each country’s total area and average population for countries with an inflation below a specific value and with a total population above a specific value. Return each country’s code, name, gdp, inflation, total area, and average population. Note that the toal area of a country is the sum of the areas of its provinces.
SET @inflBase = 2;
SET @tp = 10000;
SELECT co.country_code, co.country_name, co.gdp, co.inflation, SUM(p.area), AVG(c.population)
FROM province p JOIN country co USING(country_code) JOIN city c USING(country_code)
GROUP BY country_code
HAVING co.inflation < @inflBase AND SUM(c.population) > @tp;

-- 12. Write an SQL query that finds the number of countries that a specific country borders and its corresponding average border length. You choose which country.
SET @country = "A";
SELECT COUNT(*), AVG(border_length)
FROM border
WHERE country_code_1 = @country;

-- 13. Create an SQL view named SymmetricBorders that uses UNION to create a “symmet- ric” version of the borders relation. For instance, if a row ("a", "b", 100) is in Borders, then both ("a", "b", 100) and ("b", "a", 100) should be in the view.
CREATE VIEW borderingCountries AS
       (SELECT *
        FROM border) UNION
	(SELECT country_code_2, country_code_1, border_length
	 FROM border);

DROP TABLE IF EXISTS borderingCountries;

-- 14. Using the view you created in 13, create an SQL query that finds for each country c the number of c’s bordering countries that have a larger inflation rate but a smaller gdp than c. Your query should return the name and code of the country along with the total number of matching countries.
SELECT c.country_name, c.country_code, COUNT(*)
FROM border b JOIN country c ON (b.country_code_1 = c.country_code)
WHERE (SELECT inflation
       FROM country
       WHERE country_code = country_code_1)
       < (SELECT inflation
       	  FROM country
	  WHERE country_code = country_code_2)
	  AND (SELECT gdp
	       FROM country
	       WHERE country_code = country_code_1)
	       > (SELECT gdp
	       	  FROM country
		  WHERE country_code = country_code_2)
GROUP BY country_code_1;

-- 15. Write an SQL query that finds each country c1’s bordering countries c2 such that c1 has at least a 10% smaller population than c2, covers a larger area than c2, and has a larger gdp than c2. Return the country codes for c1 and c2 along with each countries population, area, and gdp.
SELECT b.country_code_1, b.country_code_2, SUM(c.population), p.area, co.gdp
FROM border b JOIN country co ON (b.country_code_1 = co.country_code) JOIN city	c USING(country_code)
     JOIN province p USING(country_code)
WHERE ((SELECT SUM(population)
       FROM city
       WHERE country_code = country_code_2) * .9)
       > (SELECT SUM(population)
       	  FROM city
          WHERE	country_code = country_code_1)
          AND (SELECT SUM(area)
               FROM province
               WHERE country_code = country_code_1)
               > (SELECT SUM(area)
	          FROM province
	          WHERE country_code = country_code_2)
                  AND (SELECT gdp
                       FROM country
                       WHERE country_code = country_code_1)
                       > (SELECT gdp
                          FROM country
                          WHERE country_code = country_code_2)
GROUP BY country_code_1;
