-- Counting the number of days between dates
-- Return the difference in OrderDate and ShipDate
SELECT OrderDate, ShipDate, 
       DATEDIFF(DD, OrderDate, ShipDate) AS Duration
FROM Shipments
-- DD for Day, MM for Month, YY for Year, HH for Hour



-- Adding days to a date
-- Return the DeliveryDate as 5 days after the ShipDate
SELECT OrderDate, 
       DATEADD(DD, 5, ShipDate) AS DeliveryDate 
FROM Shipments



-- Write a query to determine how many transactions exist per day.
-- Use of CONVERT function:
SELECT
  -- Select the date portion of StartDate
  CONVERT(DATE, StartDate) as StartDate,
  -- Measure how many records exist for each StartDate
  COUNT(ID) as CountOfRows 
FROM CapitalBikeShare 
-- Group by the date portion of StartDate
GROUP BY CONVERT(DATE, StartDate)
-- Sort the results by the date portion of StartDate
ORDER BY CONVERT(DATE, StartDate);
-- StartDate format in the table is as 2018-03-01 00:02:41



-- Complete the first CASE statement, using DATEPART() to evaluate the SECOND date part of StartDate.
-- Use of DATEPART function:
SELECT
	-- Count the number of IDs
	COUNT(ID) AS Count,
    -- Use DATEPART() to evaluate the SECOND part of StartDate
    "StartDate" = CASE WHEN DATEPART(SECOND, StartDate) = 0 THEN 'SECONDS = 0'
					   WHEN DATEPART(SECOND, StartDate) > 0 THEN 'SECONDS > 0' END
FROM CapitalBikeShare
GROUP BY
    -- Complete the CASE statement
	CASE WHEN DATEPART(SECOND, StartDate) = 0 THEN 'SECONDS = 0'
		 WHEN DATEPART(SECOND, StartDate) > 0 THEN 'SECONDS > 0' END




-- Which day of week is busiest?
-- Use of DATENAME, DATEDIFF functions:
SELECT
    -- Select the day of week value for StartDate
	DATENAME(weekday, StartDate) as DayOfWeek,
    -- Calculate TotalTripHours
	SUM(DATEDIFF(second, StartDate, EndDate))/ 3600 as TotalTripHours 
FROM CapitalBikeShare 
-- Group by the day of week
GROUP BY DATENAME(weekday, StartDate)
-- Order TotalTripHours in descending order
ORDER BY TotalTripHours DESC
               
               
               
-- 
