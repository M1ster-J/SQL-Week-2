/* 
Mister J
9/3/25
Intro to SQL

Mainly notes but examples of what i've been learning during my time with SQL
*/  


-- Selects all from customers table   
SELECT * FROM customers

-- Limits how many is returned to 100   
SELECT * FROM customers LIMIT 100   

-- selects table then sets filter for NYC   
SELECT * FROM customers WHERE city = 'NYC'

-- Filters for postal code 10022 in customers table  
SELECT * FROM customers WHERE postalcode = 10022

-- Shows everything else but postal code 10022 in table  
SELECT * FROM customers WHERE postalcode != 10022

-- +1 to items in officeCode then assigns to new_office  
SELECT officeCode + 1 AS new_office FROM offices

-- Allows you to search both capital and lower case words  
SELECT * FROM tutorial.billboard_top_100_year_end 
WHERE "group_name" ILIKE 'snoop%'

-- by using a underscore you can subsitute for individual characters   
SELECT * FROM tutorial.billboard_top_100_year_end
WHERE artist ILIKE 'dr_ke'

-- by using IN you can return results equal to the values in the list  
SELECT * FROM tutorial.billboard_top_100_year_end
WHERE year_rank IN (1,2,3)

-- You can also use string values  
SELECT * FROM tutorial.billboard_top_100_year_end 
WHERE artist IN ('Taylor Swift', 'Drake', 'Ludacris')

-- Using the BETWEEN AND operators paired together you can select rows within a certian range  
SELECT * FROM tutorial.billboard_top_100_year_end
WHERE year_rank >= 5 AND year_rank <= 10

-- The IS NULL operator allows you to execute rows with missing data  
SELECT * FROM tutorial.billboard_top_100_year_end
WHERE artist IS NULL

-- The AND operator allows you to select rows that only between two conditions  
SELECT * FROM tutorial.billboard_top_100_year_end
WHERE year = 2012 AND year_rank <= 10

-- You can use the AND operator as many times as you want  
SELECT * FROM tutorial.billboard_top_100_year_end
WHERE year = 2012 AND year_rank <= 10 AND "group_name" LIKE '%feat%'

-- OR allows you to select rows that satisfy either of two conditions  
SELECT * FROM tutorial.billboard_top_100_year_end
WHERE year = 2013 OR year = 2012

-- You can use AND with OR using parenthesis  
SELECT * FROM tutorial.billboard_top_100_year_end
WHERE year = 2013 AND ("group_name" LIKE '%macklemore%' OR "group_name" LIKE '%timberland%')

-- NOT operator you can put before any conditional statement for rows that are false 
Below 2 and 3 are not included in return  
SELECT * FROM tutorial.billboard_top_100_year_end
WHERE year = 2013 AND year_rank NOT BETWEEN 2 AND 3

-- Instead of using NOT with < or > you can use the opposite operator   
SELECT * FROM tutorial.billboard_top_100_year_end
WHERE year = 2013 AND year_rank <= 3 

-- The ORDER BY clause allows reordering based on data in one or more columns  
SELECT * FROM tutorial.billboard_top_100_year_end
ORDER BY artist

-- Pairing with the DESC operator you can return values in a descending order  
SELECT * FROM tutorial.billboard_top_100_year_end
WHERE year = 2013 ORDER BY year_rank DESC

-- The COUNT operator counts the number of rows in a particular column  
SELECT COUNT(*) FROM tutorial.aapl_historic_stock_price
SELECT COUNT(high) FROM tutorial.aapl_historic_stock_price
SELECT COUNT(date) FROM tutorial.aapl_historic_stock_price

-- You can also use COUNT on non-numerical values 
SELECT COUNT(date)
FROM tutorial.aapl_historic_stock_price

-- You can rename columns with count too
SELECT COUNT(date) AS count_of_date
FROM tutorial.aapl_historic_stock_price

-- To use spaces you must use double quotes

SELECT COUNT(date) AS "Count Of Date"
FROM tutorial.aapl_historic_stock_price

-- SUM totals values in a given column. This only works for numerical values
-- SUM treats nulls as 0 unlike COUNT
SELECT SUM(volume)
FROM tutorial.aapl_historic_stock_price

-- MIN and MAX return the lowest and highest values in a particular column
SELECT MIN(volume) AS min_volume,
MAX(volume) AS max_volume 
FROM tutorial.aapl_historic_stock_price

-- AVG calculates the averages of a selected group of values
SELECT AVG(high) FROM tutorial.aapl_historic_stock_price
 
-- GROUP BY allows you to seperate data into groups which can be aggregated independently of one another
SELECT year, COUNT(*) AS count 
FROM tutorial.aapl_historic_stock_price GROUP BY year

-- You can group multiple columns as well
SELECT year, month, day, COUNT(*) AS count 
FROM tutorial.aapl_historic_stock_price GROUP BY year, month

-- GROUP BY can be used with ORDER BY
SELECT year, month, 
count(*) AS count FROM tutorial.aapl_historic_stock_price GROUP BY month, year 

-- Having allows you to filter a query on aggregated columns 
SELECT year, month, MAX(high) AS month_high
FROM tutorial.aapl_historic_stock_price GROUP BY year, month HAVING MAX(high) > 400 ORDER BY year, month

-- CASE statments are SQL's if/then logic
-- Every CASE must end with a END statement. Else is optional
SELECT player_name, year, CASE WHEN year = 'SR' THEN 'yes'
ELSE NULL END AS is_a_senior FROM benn.college_football_players

-- ELSE version
SELECT player_name, year, CASE WHEN year = 'SR' THEN 'yes'
ELSE 'no' END AS is_a_senior FROM benn.college_football_players

-- You can add multiple conditions to a CASE statement
SELECT player_name, weight, 
CASE WHEN weight > 250 THEN 'Over 250'
WHEN weight > 200 THEN '201 - 250'
WHEN weight > 175 THEN '176 - 200' ELSE '175 or under' END AS weight_group FROM benn.college_football_players

-- WHEN / THEN statements will get evaluated in the order their written. 
SELECT player_name, weight, CASE WHEN weight > 250 THEN 'over 250'
WHEN weight > 200 AND weight <=250 THEN '201 - 250'
WHEN weight > 175 AND weight <=200 THEN '176 - 200'
ELSE '175 or under' END AS weight_group FROM benn.college_football_players

-- You can string together multiple conditional statements with AND and OR the same way you might in WHERE
SELECT player_name, CASE WHEN year = 'FR' AND position = 'WR' THEN 'frost_wr'
ELSE NULL END AS sample_case_statement
FROM benn.college_football_players

-- Case's more useful functionality comes from pairing with aggregate functions
SELECT CASE WHEN year = 'fr' THEN 'FR'
ELSE 'Not FR' END AS year_group, 
COUNT(1) AS count FROM benn.

-- Using CASE you can evaluate null or non-null values depending on the result
SELECT CASE WHEN year = 'FR' THEN 'FR'
ELSE 'Not FR' END AS year_group,
COUNT(1) AS count
FROM benn.college_football_players
GROUP BY CASE WHEN year = 'FR' THEN 'FR'
ELSE 'Not FR' END

-- When can also be used to filter out rows you dont want
SELECT COUNT(1) AS fr_count
FROM benn.college_football_players
WHERE year = 'fr'

-- When can be used for counting multiple conditions in one query
SELECT CASE WHEN year = 'FR' THEN 'FR'
When year = 'SO' THEN 'SO'
WHEN year = 'JR' THEN 'JR'
WHen year = 'SR' THEN 'SR'
ELSE 'No Data Found' END AS year_group,
COUNT(1) AS count FROM benn.college_football_players GROUP BY 1

-- To look at unique values in a particular column you can use SELECT DISTINCT
SELECT DISTINCT month
FROM tutorial.aapl_historic_stock_price

-- JOIN allows you to join multiple columns into one new row
-- Below takes the average weight from the players.weight table, joins with the teams 
SELECT teams.conference AS conference, 
AVG(players.weight) AS average_weight
FROM benn.college_football_players players
JOIN benn.college_football_teams teams 
ON teams.school_name = players.school_name
GROUP BY teams.conference
ORDER BY AVG(players.weight) DESC
 nbvcxsa
-- To join two tables with the same identical names - inner join the tables
-- Below is an example
SELECT players.*, teams.* 
FROM benn.college_football_players players 
JOIN benn.college_football_teams teams ON teams.school_name = players.school_name


/* ALL returns matched rows from both sides of table
LEFT JOIN returns only unmatched rows from the left table 
RIGHT JOIN returns only unmatched rows from the right table  
FULL OUTER JOIN returns unmatched  rows from both sides*/
SELECT companies.permalink AS companies_permalink,
companies.name AS companies_name,
acquisitions.company_permalink AS acquisitions_permalink,
acquisitions.acquired_at AS acquired_date
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink

-- By using UNION you can combine two datasets side-by-side
-- UNION only appends distinct values. Any identical rows in the first table.
SELECT * FROM tutorial.crunchbase_investments_part1
UNION
SELECT * FROM tutorial.crunchbase_investments_part2

-- UNION ALL appends all values. 
SELECT * FROM tutorial.crunchbase_investments_part1
UNION ALL 
SELECT * FROM tutorial.crunchbase_investments_part2

-- Comparison operators with joins
-- Below is an example with > and ON
SELECT companies.permalink, 
companies.name,
companies.status, 
COUNT(investments.investor_permalink) AS investors
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments_part1 investments 
ON companies.permalink = investments.company_permalink
AND investments.funded_year > companies.founded_year + 5
GROUP BY 1,2,3

-- Joining on multiple keys
SELECT companies.permalink,
companies.name, investments.company_name,
investments.company_permalink
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments_part1 investments
ON companies.permalink = investments.company_permalink
AND companies.name = investments.company_name

-- Self joining tables allows you to join a table to itself
SELECT DISTINCT japan_investments.company_name,
japan_investments.company_permalink 
FROM tutorial.crunchbase_investments_part1 japan_investments
JOIN tutorial.crunchbase_investments_part1 gb_investments
ON japan_investments.companies_name = gb_investments.company_name
AND gb_investments.investor_country_code = 'GBR'
AND gb_investments.funded_at > japan_investments.funded_at
WHERE japan_investments.investor_country_code = 'JPN'
ORDER BY 1

