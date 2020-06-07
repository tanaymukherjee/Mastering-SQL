-- Multiple Joins:
SELECT c.code, name, region, e.year, fertility_rate, unemployment_rate
  -- 1. From countries (alias as c)
  FROM countries AS c
  -- 2. Join to populations (as p)
  INNER JOIN populations AS p
    -- 3. Match on country code
    ON c.code = p.country_code
  -- 4. Join to economies (as e)
  INNER JOIN economies AS e
    -- 5. Match on country code and year
    ON c.code = e.code AND e.year = p.year;
    
    
    
-- Inner join with using fucntion:
SELECT c.name AS country, continent, l.name AS language, official
  -- 1. From countries (alias as c)
  FROM countries AS c
  -- 2. Join to languages (as l)
  INNER JOIN languages AS l
    -- 3. Match using code
    USING(code);
    
    
    
-- Self-join:
SELECT p1.country_code,
       p1.size AS size2010, 
       p2.size AS size2015,
       -- 1. calculate growth_perc
       ((p2.size - p1.size)/p1.size * 100.0) AS growth_perc
-- 2. From populations (alias as p1)
FROM populations AS p1
  -- 3. Join to itself (alias as p2)
  INNER JOIN populations AS p2
    -- 4. Match on country code
    ON p1.country_code = p2.country_code
        -- 5. and year (with calculation)
        AND p1.year = p2.year - 5;
        
        
        
-- Usings CASE:
SELECT name, continent, code, surface_area,
    -- 1. First case
    CASE WHEN surface_area > 2000000 THEN 'large'
        -- 2. Second case
        WHEN surface_area > 350000 THEN 'medium'
        -- 3. Else clause + end
        ELSE 'small' END
        -- 4. Alias name
        AS geosize_group
        -- 5. From table
        FROM countries;
-- We can add the values from CASE as a new column by using INTO clause like <select query> INTO new_table FROM original _table.
        
        
-- LEFT or RIGHT Join:
SELECT cities.name AS city, urbanarea_pop, countries.name AS country,
       indep_year, languages.name AS language, percent
FROM languages
  RIGHT JOIN countries
    ON languages.code = countries.code
  RIGHT JOIN cities
    ON countries.code = cities.country_code
ORDER BY city, language;
-- same can be done for LEFT Join by replacing Right keyword by left above



-- FULL Join with USING fucntion:
SELECT c1.name AS country, region, l.name AS language,
       basic_unit, frac_unit
-- 1. From countries (alias as c1)
FROM countries AS c1
  -- 2. Join with languages (alias as l)
  FULL JOIN languages AS l
    -- 3. Match on code
    USING (code)
  -- 4. Join with currencies (alias as c2)
  FULL JOIN currencies AS c2
    -- 5. Match on code
    USING (code)
-- 6. Where region like Melanesia and Micronesia
WHERE region LIKE 'M%esia';



-- CROSS Join:
SELECT c.name AS city, l.name AS language
-- 1. From cities (alias as c)
FROM cities AS c        
  -- 2. Join to languages (alias as l)
  CROSS JOIN languages AS l
-- 3. Where c.name like Hyderabad
WHERE c.name LIKE 'Hyder%';



-- EXCEPT Clause:
SELECT name
  -- From cities
  FROM cities
	-- Set theory clause
	EXCEPT
-- Select field
SELECT capital
  -- From countries
  FROM countries
-- Order by result
ORDER BY name;




-- JOIN with UNIONS, EXCEPT and other styles, as part fo set theory:
-- Select the city name
SELECT name
  -- Alias the table where city name resides
  FROM cities AS c1
  -- Choose only records matching the result of multiple set theory clauses
  WHERE country_code IN
(
    -- Select appropriate field from economies AS e
    SELECT e.code
    FROM economies AS e
    -- Get all additional (unique) values of the field from currencies AS c2   
    UNION
    SELECT c2.code
    FROM currencies AS c2
    -- Exclude those appearing in populations AS p  
    EXCEPT
    SELECT p.country_code
    FROM populations AS p
);




-- Sub queres:
SELECT code, inflation_rate, unemployment_rate
  -- From economies
  FROM economies
  -- Where year is 2015 and code is not in
  WHERE year = 2015 AND code NOT IN
  	-- Subquery
  	(SELECT code
  	 FROM countries
  	 WHERE (gov_form = 'Constitutional Monarchy' OR gov_form LIKE '%Republic%'))
-- Order by inflation rate
ORDER BY inflation_rate;
