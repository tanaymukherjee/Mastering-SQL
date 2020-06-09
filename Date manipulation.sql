-- Counting the number of days between dates:
-- Return the difference in OrderDate and ShipDate
SELECT OrderDate, ShipDate, 
       DATEDIFF(DD, OrderDate, ShipDate) AS Duration
FROM Shipments
-- DD for Day, MM for Month, YY for Year, HH for Hour



-- Adding days to a date:
-- Return the DeliveryDate as 5 days after the ShipDate
SELECT OrderDate, 
       DATEADD(DD, 5, ShipDate) AS DeliveryDate 
FROM Shipments



-- Break out a date into year, month, and day:
-- Why we use datetime 2: https://stackoverflow.com/questions/1334143/datetime2-vs-datetime-in-sql-server
-- datetime2(7) is the default standard
DECLARE
	@SomeTime DATETIME2(7) = SYSUTCDATETIME();
-- Retrieve the year, month, and day
SELECT
	YEAR(@SomeTime) AS TheYear,
	MONTH(@SomeTime) AS TheMonth,
	DAY(@SomeTime) AS TheDay;



-- Break a date and time into component parts:
DECLARE
	@BerlinWallFalls DATETIME2(7) = '1989-11-09 23:49:36.2294852';
-- Fill in each date part
SELECT
	DATEPART(YEAR, @BerlinWallFalls) AS TheYear,
	DATEPART(MONTH, @BerlinWallFalls) AS TheMonth,
	DATEPART(DAY, @BerlinWallFalls) AS TheDay,
	DATEPART(DAYOFYEAR, @BerlinWallFalls) AS TheDayOfYear,
    -- Day of week is WEEKDAY
	DATEPART(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
	DATEPART(WEEK, @BerlinWallFalls) AS TheWeek,
	DATEPART(SECOND, @BerlinWallFalls) AS TheSecond,
	DATEPART(NANOSECOND, @BerlinWallFalls) AS TheNanosecond;




-- Date math and leap years:
-- Example 1:
-- To understand date parts and intervals needed to determine how SQL Server works on February 29th of a leap year.
DECLARE
	@LeapDay DATETIME2(7) = '2012-02-29 18:00:00';
-- Fill in the date parts and intervals as needed
SELECT
	DATEADD(DAY, -1, @LeapDay) AS PriorDay,
	DATEADD(DAY, 1, @LeapDay) AS NextDay,
    -- For leap years, we need to move 4 years, not just 1
	DATEADD(YEAR, -4, @LeapDay) AS PriorLeapYear,
	DATEADD(YEAR, 4, @LeapDay) AS NextLeapYear,
	DATEADD(YEAR, -1, @LeapDay) AS PriorYear,
	DATEADD(YEAR, 1, @LeapDay) AS NextYear;
	
-- Example 2:
DECLARE
	@PostLeapDay DATETIME2(7) = '2012-03-01 18:00:00',
    @TwoDaysAgo DATETIME2(7);

SELECT
	@TwoDaysAgo = DATEADD(DAY, -2, @PostLeapDay);

SELECT
	@TwoDaysAgo AS TwoDaysAgo,
	@PostLeapDay AS SomeTime,
    -- Fill in the appropriate function and date types
	DATEDIFF(DAY, @TwoDaysAgo, @PostLeapDay) AS DaysDifference,
	DATEDIFF(HOUR, @TwoDaysAgo, @PostLeapDay) AS HoursDifference,
	DATEDIFF(MINUTE, @TwoDaysAgo, @PostLeapDay) AS MinutesDifference;



-- Rounding dates:
DECLARE
	@SomeTime DATETIME2(7) = '2018-06-14 16:29:36.2248991';
-- Fill in the appropriate functions and date parts
SELECT
	DATEADD(DAY, DATEDIFF(DAY, 0, @SomeTime), 0) AS RoundedToDay,
	DATEADD(HOUR, DATEDIFF(HOUR, 0, @SomeTime), 0) AS RoundedToHour,
	DATEADD(MINUTE, DATEDIFF(MINUTE, 0, @SomeTime), 0) AS RoundedToMinute;



-- Formatting dates with CAST() and CONVERT():
DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245',
	@OlderDateType DATETIME = '2016-11-03 00:30:29.245';

SELECT
	-- Fill in the missing function calls
	CAST(@CubsWinWorldSeries AS DATE) AS DateForm,
	CAST(@CubsWinWorldSeries AS NVARCHAR(30)) AS StringForm,
	CAST(@OlderDateType AS DATE) AS OlderDateForm,
	CAST(@OlderDateType AS NVARCHAR(30)) AS OlderStringForm,
	-- Turn this first into a date and then into a string
	CAST(CAST(@CubsWinWorldSeries AS DATE) AS NVARCHAR(30)) AS DateStringForm,
	-- Note the different function parameters
	-- Fill in the function call and missing styles
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 0) AS DefaultForm,
        -- This is a two-digit year code
        CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 3) AS UK_dmy,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 1) AS US_mdy,
        -- All of these are four-digit year codes
        CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 112) AS ISO_yyyymmdd,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 126) AS ISO8601,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 104) AS DE_dmyyyy,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 111) AS JP_yyyymd;

							   
							   
-- Formatting dates with FORMAT():
-- Example 1:
-- Use the 'd' format parameter (note that this is case sensitive!)
DECLARE
	@Python3ReleaseDate DATETIME2(3) = '2008-12-03 19:45:00.033';

SELECT
	-- Fill in the function call and format parameter
	FORMAT(@Python3ReleaseDate, 'd', 'en-US') AS US_d,
	FORMAT(@Python3ReleaseDate, 'd', 'de-DE') AS DE_d,
	-- Fill in the locale for Japan
	FORMAT(@Python3ReleaseDate, 'd', 'jp-JP') AS JP_d,
	FORMAT(@Python3ReleaseDate, 'd', 'zh-cn') AS CN_d;
-- Use the 'D' format parameter (this is case sensitive!) to build long dates
-- Like 12/3/2008 when we use 'd' for US_d but when we use 'D' format it comes as - Wednesday, December 3, 2008

-- Example 2:
-- Custom format strings needed to generate the results in preceding comments.
-- Use date parts such as yyyy, MM, MMM, and dd.
DECLARE
	@Python3ReleaseDate DATETIME2(3) = '2008-12-03 19:45:00.033';
    
SELECT
	-- 20081203
	FORMAT(@Python3ReleaseDate, 'yyyyMMdd') AS F1,
	-- 2008-12-03
	FORMAT(@Python3ReleaseDate, 'yyyy-MM-dd') AS F2,
	-- Dec 03+2008 (the + is just a "+" character)
	FORMAT(@Python3ReleaseDate, 'MMM dd+yyyy') AS F3,
	-- 12 08 03 (month, two-digit year, day)
	FORMAT(@Python3ReleaseDate, 'MM yy dd') AS F4,
	-- 03 Dec 07:45 2008.00
    -- (day, short month name, hour, minute, year, ".", second)
	FORMAT(@Python3ReleaseDate, 'dd MMM HH:mm yyyy.ss') AS F5;
							   
-- Result:
--    F1	    F2	             F3            F4	                 F5
-- 20081203	2008-12-03	Dec 03+2008	12 08 03	03 Dec 19:45 2008.00
-- NOTE: Capitalization is important for the FORMAT() function!

							   
							   
-- Calendar tables:
-- Calculate fiscal year without a calendar table
-- Fill in the fiscal day of the year in the SELECT clause.
-- In the CROSS APPLY function, fill in the function (using date part WEEK) to determine the fiscal week of the year.
-- In the WHERE clause, fill in fiscal year 2019, which runs from July 1 of 2019 through June 30 of 2020.
-- In the WHERE clause, check whether we are past the 30th week of the fiscal year and determine if the date is a weekend by using the DATEPART() function.
-- Show data during weekends in FY2019 after fiscal week 30
-- Limit results to incident type 4
SELECT
	ir.IncidentDate,
    -- Fiscal day of year: days since the start of the FY
	DATEDIFF(DAY, fy.FYStart, ir.IncidentDate) + 1 AS FiscalDayOfYear,
	fyweek.FiscalWeekOfYear
FROM dbo.IncidentRollup ir
	CROSS APPLY (SELECT '2019-07-01' AS FYStart) fy
    -- Number of weeks since the fiscal year began
	CROSS APPLY (
      SELECT DATEDIFF(WEEK, fy.FYStart, ir.IncidentDate) + 1 AS FiscalWeekOfYear
    ) fyweek
WHERE
	ir.IncidentTypeID = 4
    -- Fiscal year 2019, in dates
	AND ir.IncidentDate BETWEEN '2019-07-01' AND '2020-06-30'
	-- Determine if we are past the 30th fiscal week of the year
	AND fyweek.FiscalWeekOfYear > 30
	-- Determine if this is a weekend by using WEEKDAY
	AND DATEPART(WEEKDAY, ir.IncidentDate) IN (1, 7);
							   
							   
							   

-- Build dates from parts:
-- The DATEFROMPARTS() function allows us to turn a series of numbers representing date parts into a valid DATE data type.
-- Example 1:
SELECT TOP(10)
	c.CalendarQuarterName,
	c.MonthName,
	c.CalendarDayOfYear
FROM dbo.Calendar c
WHERE
	-- Create dates from component parts
	DATEFROMPARTS(c.CalendarYear, c.CalendarMonth, c.Day) >= '2018-06-01'
	AND c.DayName = 'Tuesday'
ORDER BY
	c.FiscalYear,
	c.FiscalDayOfYear ASC;

-- We use this clause when days, months, years are gievn seperately in different formats.
-- Example 2:
SELECT
	-- Mark the date and time the lunar module touched down
    -- Use 24-hour notation for hours, so e.g., 9 PM is 21
	DATETIME2FROMPARTS(1969, 07, 20, 20, 17, 00, 000, 0) AS TheEagleHasLanded,
	-- Mark the date and time the lunar module took back off
    -- Use 24-hour notation for hours, so e.g., 9 PM is 21
	DATETIMEFROMPARTS(1969, 07, 21, 18, 54, 00, 000) AS MoonDeparture;
-- Result:
--  TheEagleHasLanded	   MoonDeparture
-- 1969-07-20 20:17:00	1969-07-21 18:54:00
							   
							   
							   
-- Build dates and times with offsets from parts:
-- Miscellaneous case
-- The DATETIMEOFFSETFROMPARTS() function builds a DATETIMEOFFSET out of component values.
-- It has the most input parameters of any date and time builder function.
-- On January 19th, 2038 at 03:14:08 UTC, we will experience the Year 2038 (or Y2.038K) problem.
-- This is the moment that 32-bit devices will reset back to the date 1900-01-01.
-- This runs the risk of breaking every 32-bit device using POSIX time, which is the number of seconds elapsed since January 1, 1970 at midnight UTC.

-- Build a DATETIMEOFFSET which represents the last millisecond before the Y2.038K problem hits. The offset should be UTC.
-- Build a DATETIMEOFFSET which represents the moment devices hit the Y2.038K issue in UTC time. Then use the AT TIME ZONE operator to convert this to Eastern Standard Time.
SELECT
	-- Fill in the millisecond PRIOR TO chaos
	DATETIMEOFFSETFROMPARTS(2038, 01, 19, 03, 14, 07, 999, 0, 0, 3) AS LastMoment,
    -- Fill in the date and time when we will experience the Y2.038K problem
    -- Then convert to the Eastern Standard Time time zone
	DATETIMEOFFSETFROMPARTS(2038, 01, 19, 03, 14, 08, 0, 0, 0, 3) AT TIME ZONE 'Eastern Standard Time' AS TimeForChaos;
-- Result:
-- LastMoment	                        TimeForChaos
-- 2038-01-19 03:14:07.9990000 +00:00	2038-01-18 22:14:08.0000000 -05:00

							   
							   
							   
-- Cast strings to dates:
-- The CAST() function allows us to turn strings into date and time data types.
-- In this example, we will review many of the formats CAST() can handle.							   
SELECT
	d.DateText AS String,
	-- Cast as DATE
	CAST(d.DateText AS DATE) AS StringAsDate,
	-- Cast as DATETIME2(7)
	CAST(d.DateText AS DATETIME2(7)) AS StringAsDateTime2
FROM dbo.Dates d;
							   
							   
							   
-- Convert strings to dates
-- The CONVERT() function behaves similarly to CAST().
-- When translating strings to dates, the two functions do exactly the same work under the covers.
-- Although we used all three parameters for CONVERT() during a prior exercise, we will only need two parameters here: the data type and input expression.
SET LANGUAGE 'GERMAN'
SELECT
	d.DateText AS String,
	-- Convert to DATE
	CONVERT(DATE, d.DateText) AS StringAsDate,
	-- Convert to DATETIME2(7)
	CONVERT(DATETIME2(7), d.DateText) AS StringAsDateTime2
FROM dbo.Dates d;
				     
				     
				     
-- Parse strings to dates
-- Changing our language for data loading is not always feasible.
-- Instead of using the SET LANGUAGE syntax, we can instead use the PARSE() function to parse a string as a date type using a specific locale.
-- We will once again use the dbo.Dates table, this time parsing all of the dates as German using the de-de locale.				     
SELECT
	d.DateText AS String,
	-- Parse as DATE using German
	PARSE(d.DateText AS DATE USING 'de-de') AS StringAsDate,
	-- Parse as DATETIME2(7) using German
	PARSE(d.DateText AS DATETIME2(7) USING 'de-de') AS StringAsDateTime2
FROM dbo.Dates d;

				     
				     
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
