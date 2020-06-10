-- For ranges:
-- Method 1:
SELECT title FROM films WHERE release_year >= 1994 AND release_year <= 2000;

-- Method 2:
SELECT title FROM films WHERE release_year BETWEEN 1994 AND 2000;



-- Multiple AND / OR in the same query:
SELECT title FROM films  WHERE (release_year = 1994 OR release_year = 1995) AND (certification = 'PG' OR certification = 'R');



-- Using WHERE IN:
-- Method 1:
SELECT name FROM kids WHERE age = 2 OR age = 4 OR age = 6 OR age = 8 OR age = 10;
-- Method 2:
SELECT name FROM kids WHERE age IN (2, 4, 6, 8, 10);



-- Introduction to NULL and IS NULL:
SELECT COUNT(*) FROM people WHERE birthdate IS NULL;

SELECT name FROM people WHERE birthdate IS NOT NULL;



-- Imputing missing value:
-- Method1 : (using ISNULL function)
-- Check the IncidentState column for missing values and replace them with the City column
SELECT IncidentState, ISNULL(IncidentState, City) AS Location
FROM Incidents
-- Filter to only return missing values from IncidentState
WHERE IncidentState IS NULL

-- Method 2: (Using COALESCE function)
-- Return the first non-null value in a list
-- Replace missing values
SELECT Country, COALESCE(Country, IncidentState, City) AS Location
FROM Incidents
WHERE Country IS NULL



-- Using LIKE and NOT LIKE
SELECT name FROM companies WHERE name LIKE 'Data%';

SELECT name FROM people WHERE name NOT LIKE 'B%';



-- Aggregate functions:
SELECT AVG(budget) FROM films;

SELECT MAX(budget) FROM films;

SELECT SUM(budget) FROM films;



-- Case with arithmetic fucntions:
-- Example 1:
SELECT (4 * 3);
-- this will result in 12

SELECT (4 / 3);
-- this will result in 1. Division of integers always returns integers

SELECT (4.0 / 3.0) AS result;
-- this will result in 1.333. You have to define the inputs as floats to get the precised value

-- Example 2:
SELECT 45 / 10 * 100.0;
-- this will give us 400

SELECT 45 * 100.0 / 10;
-- this will give us 450.0

-- Example 3:
SELECT COUNT(death) * 100.0 / COUNT(*) AS percentage_dead FROM people;



-- Using ORDER BY:
-- Example 1:
SELECT title FROM films ORDER BY release_year DESC;
-- by default ORDER BY will sort in ascending order. If you want to sort the results in descending order, use the DESC keyword.

-- Example 2:
SELECT birthdate, name FROM people ORDER BY birthdate, name;
-- sorts on birth dates first (oldest to newest) and then sorts on the names in alphabetical order. The order of columns is important!



-- Use of except or NOT IN:
-- Method 1:
SELECT * FROM films WHERE release_year NOT IN 2015 ORDER BY duration;

-- Method 2:
SELECT * FROM films WHERE release_year <> 2015 ORDER BY duration;



-- GROUP BY clause:
SELECT sex, count(*) FROM employees GROUP BY sex;



-- Aggregate, group by, and order by all together:
SELECT country, release_year, MIN(gross) FROM films 
GROUP BY country, release_year
ORDER BY country, release_year;



-- HAVING clause:
SELECT release_year FROM films GROUP BY release_year HAVING COUNT(title) > 10;
-- if you want to filter based on the result of an aggregate function, HAVING clause is used. WHERE clause doesn't work in this case
-- group by is an aggregate fucntion



-- All of the above clauses and styles together:
SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross FROM films WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
ORDER BY avg_gross DESC;



-- ALTER table:
-- Example 1:
ALTER TABLE Customers DROP COLUMN Email;
-- Example 2:
ALTER TABLE Customers ALTER COLUMN Firstname TYPE varchar(64);
-- Example 3:
-- Disallow NULL values in firstname
ALTER TABLE Customers ALTER COLUMN Firstname SET NOT NULL;
-- Example 4: (Make your columns UNIQUE with ADD CONSTRAINT)
ALTER TABLE Organizations ADD CONSTRAINT Organization_unq UNIQUE(Organization);
-- Example 5: (ADD key CONSTRAINTs to the tables)
ALTER TABLE Organizations RENAME COLUMN Organization TO ID;
ALTER TABLE Organizations ADD CONSTRAINT Organization_pk PRIMARY KEY (ID);



-- UPDATE query:
UPDATE Customers SET ContactName = 'Alfred Schmidt', City= 'Frankfurt' WHERE CustomerID = 1;



-- INSERT query:
INSERT INTO Persons (Personid,FirstName,LastName) VALUES (seq_person.nextval,'Lars','Monsen');



-- DELETE query:
DELETE FROM Customers WHERE CustomerName='Alfreds Futterkiste';



-- EXISTS Operator:
SELECT SupplierName FROM Suppliers
WHERE EXISTS (SELECT ProductName FROM Products WHERE Products.SupplierID = Suppliers.supplierID AND Price < 20);
-- The EXISTS operator is used to test for the existence of any record in a subquery.
-- The EXISTS operator returns true if the subquery returns one or more records.



-- ANY/ ALL Operator:
-- ANY
SELECT ProductName FROM Products
WHERE ProductID = ANY (SELECT ProductID FROM OrderDetails WHERE Quantity = 10);

-- ALL
SELECT ProductName FROM Products
WHERE ProductID = ALL (SELECT ProductID FROM OrderDetails WHERE Quantity = 10);
-- The ANY and ALL operators are used with a WHERE or HAVING clause.
-- The ANY operator returns true if any of the subquery values meet the condition.
-- The ALL operator returns true if all of the subquery values meet the condition.



-- DROP query:
DROP TABLE university_professors;




-- Type CASTs:
-- Calculate the net amount as amount + fee
SELECT transaction_date, amount + CAST(fee AS integer) AS net_amount 
FROM transactions;
-- Type casts are a possible solution for data type issues.
-- If you know that a certain column stores numbers as text, you can cast the column to a numeric form, i.e. to integer.



-- Adding a surrogate key with serial data type
ALTER TABLE professors ADD COLUMN id serial;
-- serial type will add an incremental number that can be treated as a unique id.



-- Concatenate columns to a surrogate key
-- Count the number of distinct rows with columns make, model
SELECT COUNT(DISTINCT(make, model)) FROM cars;

-- Add the id column
ALTER TABLE cars ADD COLUMN id varchar(128);

-- Update id with make + model
UPDATE cars SET id = CONCAT(make, model);

-- Make id a primary key
ALTER TABLE cars ADD CONSTRAINT id_pk PRIMARY KEY(id);

                      
                      
-- Rounding numbers
-- Round Cost to the nearest dollar
SELECT Cost, ROUND(Cost, 0) AS RoundedCost FROM Shipments
		      
		      
		      
-- Truncating numbers
-- Truncate cost to whole number
SELECT Cost, ROUND(Cost, 0, 1) AS TruncateCost FROM Shipments

		      
		      
-- STRING functions:
-- Example 1: (LEN'gth of a string)
SELECT LEN(description) AS description_length FROM grid;

-- Example 2: (Left and right)
SELECT LEFT(description, 25) AS first_25_left FROM grid;
		      
-- Example 3: (Stuck in the middle with you)
-- We now know where 'Weather' begins in the description column. But where does it end?
SELECT description, CHARINDEX('Weather', description) AS start_of_string, 
  LEN ('Weather') AS length_of_string
FROM grid WHERE description LIKE '%Weather%';

		      
		      
-- Trimming:
-- Trim digits 0-9, #, /, ., and spaces from the beginning and end of street.
SELECT distinct street,
       -- Trim off unwanted characters from street
       trim(street, '0123456789 #/.') AS cleaned_street
  FROM evanston311
 ORDER BY street;
		      
		      
		      
-- Concatenate strings:
-- Concatenate house_num, a space, and street
-- and trim spaces from the start of the result
SELECT ltrim(concat(house_num, ' ', street)) AS address
  FROM evanston311;
		    
		    
		    
-- Split strings on a delimiter:
-- Use split_part() to select the first word in street; alias the result as street_name.
-- Select the first word of the street value
SELECT split_part(street, ' ', 1) AS street_name, 
       count(*)
  FROM evanston311
 GROUP BY street_name
 ORDER BY count DESC
 LIMIT 20;
		    
		    
		    
-- Shorten long strings:
-- Select the first 50 chars when length is greater than 50
SELECT CASE WHEN length(description) > 50
            THEN left(description, 50) || '...'
       -- otherwise just select description
       ELSE description
       END
  FROM evanston311
 -- limit to descriptions that start with the word I
 WHERE description LIKE 'I %'
 ORDER BY description;
		    
		    
		    
-- Group and recode values:
-- Create recode with a standardized column; use split_part() and then rtrim() to remove any remaining whitespace on the result of split_part().
-- Fill in the command below with the name of the temp table
DROP TABLE IF EXISTS recode;

-- Create and name the temporary table
CREATE TEMP TABLE recode AS
-- Write the select query to generate the table 
-- with distinct values of category and standardized values
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    -- What table are you selecting the above values from?
    FROM evanston311;
       
-- Look at a few values before the next step
SELECT DISTINCT standardized 
  FROM recode
 WHERE standardized LIKE 'Trash%Cart'
    OR standardized LIKE 'Snow%Removal%';
			  
			  
			  
-- Create a table with indicator variables:
-- To clear table if it already exists
DROP TABLE IF EXISTS indicators;

-- Create the temp table
CREATE TEMP TABLE indicators AS
  SELECT id, 
         CAST (description LIKE '%@%' AS integer) AS email,
         CAST (description LIKE '%___-___-____%' AS integer) AS phone 
    FROM evanston311;

-- Select the column you'll group by
SELECT priority, 
       -- Compute the proportion of rows with each indicator
       sum(email)/count(*)::numeric AS email_prop, 
       sum(phone)/count(*)::numeric AS phone_prop 
  -- Tables to select from
  FROM evanston311
       LEFT JOIN indicators
       -- Joining condition
       ON evanston311.id=indicators.id
 -- What are you grouping by?
 GROUP BY priority;
