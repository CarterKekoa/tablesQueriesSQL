# tablesQueriesSQL
Tables created from database schema provided in pdf. Queries used to grab specific values also specified in pdf.

Technical Work. Consider the following database schema, which is loosely based on the CIA World Factbook.1
Country(country code, country name, gdp, inflation)
– Countries consisting of their country codes (e.g., “US”), names (e.g., “United States of America”), gross domestic product per capita (e.g., 46,900 dollars per person), and inflation rates (e.g., 3.8 percent), where country code is the primary key
Province(province name, country code, area)
– Provinces (states in the US) consist of their names, their countries, and their ar- eas (in km2), where province name and country coode together form the primary key, and country code is a foreign key to Country.country code
City(city name, province name, country code, population)
– Cities consist of their names, provinces, countries, and population, where city name, province name, and country code together form the primary key, and province name and country code together are a foreign key to Province.(province name,country code)
Border(country code 1, country code 2, border length)
– Borders between countries with their border lengths (in km), where country code 1 and country code 2 together form the primary key, and country code 1 and coun- try code 2 are both foreign keys to Country.country code. Assume there is only one row in the table for a given border between two countries (i.e., the table does not store a symmetric closure over the border relation).
Assume it is possible for: (i) two different cities in different provinces to have the same name; (ii) two different provinces in different countries to have the same name; and (iii) two countries with different country codes to have the same country name.
1https://www.cia.gov/library/publications/the-world-factbook 1
      
1. Implement the above tables in MySQL using create table statements. Populate your tables with enough data to fully test your answers to the following queries. All of your create table, insert, and query statements must be placed in a hw6.sql script file. Note you do not have to use “real” data when populating your tables. Your data also does not need to be “comprehensive”, e.g., if you do represent actual country and province data, you do not need to include all provinces within a country, and you do not need to include all cities within a province.
For the following queries, use variables within your SQL script for queries that ask for “specific values.” For instance, if we want to find the names of countries with a specific GDP value, we would create the following.
   SET @gdp = 50;
   SELECT c.country_name
   FROM   country c
   WHERE  c.gdp = @gdp;
2. Write an SQL query to find the countries containing a province with a small area, but where the country has low inflation and high gdp. Use specific values for the area, inflation, and gdp cutoffs as appropriate to fit your data. Your query should return the name, code, gdp, and inflation for each such country, and only return one row per matching country. Your query must use a comma join.
3. Rewrite your query from (2) using inner JOIN syntax.
4. Write an SQL query that finds the set of all provinces that have at least one city with a population greater than 1000. Return the country code, country name, province name, and province area. Your query must use comma joins.
5. Rewrite your query from (4) using inner JOIN syntax for all of the joins.
6. Write an SQL query that finds the total area of all of the provinces within countries that have a gdp within a given range of values. Your query should return the total area.
7. Write an SQL query that finds the mininim, maximum, and average of both gdp and inflation of each country.
8. Write an SQL query that finds the number of cities and the average population within a specific country. You choose which country.
2

9. Write an SQL query that finds the average population of cities that are within the same province and country as a given city. Do not include the given city’s population in the average population calculation.
10. Write an SQL query that finds the average population for each country in your database. The population of a country is the total population of each city in the country’s provinces.
11. Write an SQL query that finds each country’s total area and average population for countries with an inflation below a specific value and with a total population above a specific value. Return each country’s code, name, gdp, inflation, total area, and average population. Note that the toal area of a country is the sum of the areas of its provinces.
12. Write an SQL query that finds the number of countries that a specific country borders and its corresponding average border length. You choose which country.
13. Create an SQL view named SymmetricBorders that uses UNION to create a “symmet- ric” version of the borders relation. For instance, if a row ("a", "b", 100) is in Borders, then both ("a", "b", 100) and ("b", "a", 100) should be in the view.
14. Using the view you created in 13, create an SQL query that finds for each country c the number of c’s bordering countries that have a larger inflation rate but a smaller gdp than c. Your query should return the name and code of the country along with the total number of matching countries.
15. Write an SQL query that finds each country c1’s bordering countries c2 such that c1 has at least a 10% smaller population than c2, covers a larger area than c2, and has a larger gdp than c2. Return the country codes for c1 and c2 along with each countries population, area, and gdp.
