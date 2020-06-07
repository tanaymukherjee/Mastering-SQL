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
ALTER TABLE Customers DROP COLUMN Email;



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
