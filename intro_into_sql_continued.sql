
/* Mister J
Intro_into_sql_continued
9/8/25

Was completed 9/5/25 but lost file due to switching to Linux.
Mainly advanced SQL such as datatypes, datawrangling, SQL strings
to clean data, subqueries, performance tuning SQL queries and pivoting data in SQL
*/


-- Data types
-- Strings = VARCHAR(1024) - any char with max field of 1024
-- Date/Time = TimeStamp - Stores year, month, day, hour, minute and second
-- Values as YYYY-MM-DD
-- Decimal numbers = DOUBLE PRECISION - 17 significant decimal numbers
-- Boolean = BOOLEAN - True/False

-- Year dates are formatted with year-first
SELECT permalink,
founded_at 
FROM tutorial.crunchbase_companies_clean_date
ORDER BY founded_at

-- You can change types of data using ::datatype 
-- Below uses Timestamp but also the interval function
SELECT companies.permalink,
companies.founded_at_clean, 
companies.founded_at_clean::timestamp + INTERVAL '1 week'
AS plus_one_week
FROM tutorial.crunchbase_companies_clean_date companies
WHERE founded_at_clean IS NOT NULL

-- INTERVAL is defined using plain english such as 10 seconds or 5 months
-- Current time can also be added using NOW() function
SELECT companies.permalink, 
companies.founded_at_clean,
NOW() - companies.founded_at_clean::timestamp AS founded_time_ago
FROM tutorial.crunchbase_companies_clean_date companies
WHERE founded_at_clean IS NOT NULL

-- Data wrangling or munging is the proccess of manually converting or mapping data from one 
-- raw format into a format you can work with

-- Left can pull a certian number of chars from the left side of a string and present as a seperate string
SELECT incidnt_num,
date, 
LEFT(date, 10) AS cleaned_date
FROM tutorial.sf_crime_incidents_2014_01

-- Right does the same thing but on the right side of the string
SELECT incidnt_num,
date, 
RIGHT(date, 10) AS cleaned_date
FROM tutorial.sf_crime_incidents_2014_01

-- TRIM removes chars from the beginning and end of a string
-- TRIM takes two functions. The beginning(leading), end(trailing), or both
-- from there you specify all chars needed to be trim. Any chars in the single quotes are removed
SELECT location,
TRIM(both '()' FROM location)
FROM tutorial.sf_crime_incidents_2014_01


-- POSITION allows you to specify a substring then return a value equal to the chars number starting from the left
SELECT incidnt_num,
descript, 
POSITION('A' IN descript) AS a_position
FROM tutorial.sf_crime_incidents_2014_01

-- STRPOS also does the same thing just replace IN with a comma and swap the order
SELECT incidnt_num,
date, 
SUBSTR(date,4,2) AS day
FROM tutorial.sf_crime_incidents_2014_01

-- CONCAT combines strings from several columns together. Just seperate values with a ,
SELECT incidnt_num,
day_of_week,
LEFT(date,10) AS cleaned_date,
CONCAT(day_of_week, ',', LEFT(date,10)) AS day_and_date
FROM tutorial.sf_crime_incidents_2014_01

-- || also does the same as CONCAT
SELECT incidnt_num,
day_of_week,
LEFT(date,10) AS cleaned_date,
day_of_week || ',' || LEFT(date,10) AS day_and_date
FROM tutorial.sf_crime_incidents_2014_01

-- UPPER and LOWER does what it sounds. These force every chars to be either UPPER or LOWER
SELECT incidnt_num, address,
UPPER(address) AS address_upper,
LOWER(address) AS address_lower
FROM tutorial.sf_crime_incidents_2014_01

-- Turning strings into dates
SELECT incidnt_num,
date,
(SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
'-' || SUBSTR(date, 4, 2))::date AS cleaned_date
FROM tutorial.sf_crime_incidents_2014_01

-- EXTRACT allows you to deconstruct a date field
SELECT cleaned_date,
EXTRACT('year' FROM cleaned_date) AS year,
EXTRACT('month' FROM cleaned_date) AS month,
EXTRACT('day' FROM cleaned_date) AS day 
FROM tutorial.sf_crime_incidents_2014_01

-- DATE_TRUNC rounds date to the nearest unit of measurement
SELECT cleaned_date,
DATE_TRUNC('year', cleaned_date) AS year,
DATE_TRUNC('month', cleaned_date) AS month,
DATE_TRUNC('week', cleaned_date) AS week
FROM tutorial.sf_crime_incidents_2014_01

-- date, time, timestamp, localtime, localtimestamp, NOW() can be included using any of the following functions
SELECT CURRENT_DATE AS date,
CURRENT_TIME AS time,
CURRENT_TIMESTAMP AS timestamp,
LOCALTIME AS localtime, 
LOCALTIMESTAMP AS localtimestamp,
NOW() AS now

-- AT TIME ZONE ' ' allows you to specify specific time zones
SELECT CURRENT_TIME AS time,
CURRENT_TIME AT TIME ZONE 'MST' as time_mst

-- COALESCE allows you to return values from nulls.
SELECT incidnt_num,
descript, 
COALESCE(descript, 'No description')
FROM tutorial.sf_crime_incidents_2014_01
ORDER BY descript DESC

-- Subqueries allow performing operations in multiple steps
SELECT sub.*
FROM ( 
    SELECT * FROM tutorial.sf_crime_incidents_2014_01
    WHERE day_of_week = 'Friday'
)sub
WHERE sub.resolution = 'NONE'

-- When a subqueries is ran, the inner query is ran first
-- You can use subqueries to aggregate in multiple stages 
SELECT LEFT(sub.date, 2) AS cleaned_month, sub.day_of_week,
AVG(sub.incidents) AS average_incidents
FROM (
    SELECT day_of_week,
    date,
    COUNT(incidnt_num) AS incidents
    FROM tutorial.sf_crime_incidents_2014_01
    GROUP BY 1,2
    ) sub
 GROUP BY 1,2
 ORDER BY 1,2

 -- Subqueries can also contain conditional logic such as WHERE, JOIN/ON or CASE
 SELECT * 
 FROM tutorial.sf_crime_incidents_2014_01
 WHERE Date = (SELECT MIN(date) FROM tutorial.sf_crime_incidents_2014_01)

 -- Joining subqueries 
 SELECT * 
 FROM tutorial.sf_crime_incidents_2014_01 incidents
 JOIN ( SELECT date FROM tutorial.sf_crime_incidents_2014_01
 ORDER BY date
 LIMIT 5) sub 
 ON incidents.date = sub.date

 -- Subqueries can help improve performance of your queries. 
 SELECT COALESCE(acquisitions.month, investments.month) AS month,
       acquisitions.companies_acquired,
       investments.companies_rec_investment
  FROM (
         SELECT acquired_month AS month,
         COUNT(DISTINCT company_permalink) AS companies_acquired
         FROM tutorial.crunchbase_acquisitions
         GROUP BY 1
       ) acquisitions

  FULL JOIN (
        SELECT funded_month AS month,
        COUNT(DISTINCT company_permalink) AS companies_rec_investment
        FROM tutorial.crunchbase_investments
        GROUP BY 1
       )investments

    ON acquisitions.month = investments.month
 ORDER BY 1 DESC

 -- UNIONS can also be included in a subquery
 SELECT COUNT(*) AS total_rows
 FROM (
    SELECT * FROM tutorial.crunchbase_investments_part1
    UNION ALL
    SELECT * FROM tutorial.crunchbase_investments_part2
 )sub

 -- Window functions preform a calculation accross a set of table rows that are somehow related to the current row
 SELECT duration_seconds, 
 SUM(duration_seconds) OVER (ORDER BY start_time) AS running_total
 FROM tutorial.dc_bikeshare_q1_2012


 -- ROW_NUMBER() displays the number of a given row
 SELECT start_terminal, start_time, duration_seconds, ROW_NUMBER()
 OVER (ORDER BY start_time)
 AS row_number
 FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'

 -- PARTITION BY allows you to begin counting 1 again in each partition
 SELECT start_terminal, start_time, duration_seconds, ROW_NUMBER() OVER (PARTITION BY start_terminal
 ORDER BY start_time) AS row_number
 FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'

 -- RANK() and DENSE_RANK() are similar to ROW_NUMBER. If values are identical 
 -- They are given the same rank whereas ROW_NUMBER() would give different numbers
 SELECT start_terminal, duration_seconds, RANK() OVER (PARTITION BY start_terminal 
 ORDER BY start_time)
AS rank FROM tutorial.dc_bikeshare_q1_2012 WHERE start_time < '2012-01-08'

--NTILE identifies what percentile (quartile or other subdivision)
-- a given row falls into
SELECT start_terminal, duration_seconds, NTILE(4) OVER 
(PARTITION BY start_terminal ORDER BY duration_seconds) AS quartile,
NTILE(5) OVER (PARTITION BY start_terminal ORDER BY duration_seconds)
AS quintile, 
NTILE(100) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) 
AS percentile
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
ORDER BY start_terminal, duration_seconds

-- LAG or LEAD compares rows to preceding or following rows. 
SELECT start_terminal, duration_seconds, LAG(duration_seconds, 1) OVER
(PARTITION BY start_terminal ORDER BY duration_seconds) AS lag,
LEAD(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lead
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
ORDER BY start_terminal, duration_seconds

-- Several window functions can be used in the same query by creating an alias
SELECT start_terminal, duration_seconds, NTILE(4) OVER ntile_window AS quartile,
NTILE(5) OVER ntile_window AS quintile, NTILE(100) OVER ntile_window AS percentile
FROM tutorial.dc_bikeshare_q1_2012 WHERE start_time < '2012-01-08'
WINDOW ntile_window AS (PARTITION BY start_terminal ORDER BY duration_seconds)
 ORDER BY start_terminal, duration_seconds

-- EXPLAIN at the beginning of any query can get a sense of how long it will take to return
EXPLAIN
SELECT * FROM benn.sample_event_table WHERE event_date >= '2014-03-01' AND 
event_date < '2014-04-01' LIMIT 100

-- Pivoting rows to columns
SELECT conference,
SUM(players) AS total_players,SUM(CASE WHEN year = 'FR' THEN players ELSE NULL END) AS fr,
SUM(CASE WHEN year = 'SO' THEN players ELSE NULL END) AS so,SUM(CASE WHEN year = 'JR' THEN players ELSE NULL END) AS jr,
SUM(CASE WHEN year = 'SR' THEN players ELSE NULL END) AS sr
  FROM (
        SELECT teams.conference AS conference,
        players.year,
        COUNT(1) AS players
        FROM benn.college_football_players players
        JOIN benn.college_football_teams teams
        ON teams.school_name = players.school_name
        GROUP BY 1,2
       ) sub
 GROUP BY 1
 ORDER BY 2 DESC
