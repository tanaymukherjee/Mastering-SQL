-- Calculate the factorial of 5:
-- Define the target factorial number
DECLARE @target float = 5
-- Initialization of the factorial result
DECLARE @factorial float = 1

WHILE @target > 0 
BEGIN
	-- Calculate the factorial number
	SET @factorial = @factorial * @target
	-- Reduce the termination condition  
 	SET @target = @target - 1
END

SELECT @factorial;



-- How to query the factorial of 6 recursively:
WITH calculate_factorial AS (
	SELECT 
		-- Initialize step and the factorial number      
      	1 AS step,
        1 AS factorial
	UNION ALL
	SELECT 
      	step + 1,
     	-- Calculate the recursive part by n!*(n+1)
        factorial * (step + 1)
	FROM calculate_factorial        
	-- Stop the recursion reaching the wanted factorial number
	WHERE step < 6)
     
SELECT factorial 
FROM calculate_factorial;



-- Counting numbers recursively:
-- Define the CTE
WITH counting_numbers AS ( 
	SELECT 
  		-- Initialize number
  		1 AS number
  	UNION ALL 
  	SELECT 
  		-- Increment number by 1
  		number + 1 
  	FROM counting_numbers
	-- Set the termination condition
  	WHERE number < 50)
    
SELECT number
FROM counting_numbers;



-- Calculate the sum of potencies:
-- In this exercise, you will calculate the sum of potencies recursively. This mathematical series is defined as:
-- result=1 for step = 1
-- result + step^step for step > 1
-- Define the CTE calculate_potencies with the fields step and result
WITH calculate_potencies (step, result) AS (
    SELECT 
  		-- Initialize step and result
  		1,
  		1
    UNION ALL
    SELECT 
  		step + 1,
  		-- Add the POWER calculation to the result  
  		result + POWER(step + 1, step + 1)
    FROM calculate_potencies
    WHERE step < 9)
    
SELECT 
	step, 
    result
FROM calculate_potencies;



-- Create the alphabet recursively:
-- The task of this exercise is to create the alphabet by using a recursive CTE.
-- To solve this task, you need to know that you can represent the letters from A to Z by a series of numbers from 65 to 90.
-- Accordingly, A is represented by 65 and C by 67. The function char(number) can be used to convert a number its corresponding letter.
WITH alphabet AS (
	SELECT 
  		-- Initialize letter to A
	    65 AS number_of_letter
	-- Statement to combine the anchor and the recursive query
  	UNION ALL
	SELECT 
  		-- Add 1 each iteration
	    number_of_letter + 1
  	-- Select from the defined CTE alphabet
	FROM alphabet
  	-- Limit the alphabet to A-Z
  	WHERE number_of_letter < 90)

SELECT char(number_of_letter)
FROM alphabet;



-- Create a time series of a year:
-- To get a series of days for a year you need 365 recursion steps.
-- Therefore, increase the number of iterations by OPTION (MAXRECURSION n) where n represents the number of iterations.
WITH time_series AS (
	SELECT 
  		-- Get the current time
	    GETDATE() AS time
  	UNION ALL
	SELECT 
	    DATEADD(day, 1, time)
  	-- Call the CTE recursively
	FROM time_series
  	-- Limit the time series to 1 year minus 1 (365 days -1)
  	WHERE time < GETDATE() + 364)
    
SELECT time
FROM time_series
-- Increase the number of iterations (365 days)
OPTION(MAXRECURSION 365)



-- Get the hierarchy position:
-- An important problem when dealing with recursion is tracking the level of recursion.
-- In the IT organization, this means keeping track of the position in the hierarchy of each employee.
-- For this, you will use a LEVEL field which keeps track of the current recursion step.
-- You have to introduce the field in the anchor member, and increment this value on each recursion step in the recursion member.
WITH employee_hierarchy AS (
	SELECT
		ID, 
  		NAME,
  		Supervisor,
  		-- Initialize the field LEVEL
  		1 as LEVEL
	FROM employee
  	-- Start with the supervisor ID of the IT Director
	WHERE Supervisor = 0
	UNION ALL
	SELECT 
  		emp.ID,
  		emp.NAME,
  		emp.Supervisor,
  		-- Increment LEVEL by 1 each step
  		LEVEL + 1
	FROM employee emp
		JOIN employee_hierarchy
  		-- JOIN on supervisor and ID
  		ON emp.Supervisor = employee_hierarchy.ID)
    
SELECT 
	cte.Name, cte.Level,
    emp.Name as ManagerID
FROM employee_hierarchy as cte
	JOIN employee as emp
	ON cte.Supervisor = emp.ID 
ORDER BY Level;



-- Which supervisor do I have?:
WITH employee_Hierarchy AS (
	SELECT
		ID, 
  		NAME,
  		Supervisor,
  		-- Initialize the Path with CAST
  		CAST('0' AS VARCHAR(MAX)) as Path
	FROM employee
	WHERE Supervisor = 0
	-- UNION the anchor query
  	UNION ALL
    -- Select the recursive query fields
	SELECT 
  		emp.ID,
  		emp.NAME,
  		emp.Supervisor,
  		-- Add the supervisor in each step. CAST the supervisor.
        Path + '->' + CAST(emp.Supervisor AS VARCHAR(MAX))
	FROM employee emp
		INNER JOIN employee_Hierarchy
  		ON emp.Supervisor = employee_Hierarchy.ID
)

SELECT Path
FROM employee_Hierarchy
-- Select the employees Christian Feierabend and Jasmin Mentil
WHERE ID = 16 OR ID = 18;
                           
                           
                           
-- Get the number of generations?:
WITH children AS (
    SELECT 
  		ID, 
  		Name,
  		ParentID,
  		0 as LEVEL
  	FROM family 
  	-- Set the targeted parent as recursion start
  	WHERE ParentID = 101
    UNION ALL
    SELECT 
  		child.ID,
  		child.NAME,
  		child.ParentID,
  		-- Increment LEVEL by 1 each step
  		LEVEL + 1
  	FROM family child
  		INNER JOIN children 
		-- Join the anchor query with the CTE   
  		ON child.ParentID = children.ID)
    
SELECT
	-- Count the number of generations
	COUNT(LEVEL) as Generations
FROM children
OPTION(MAXRECURSION 300);
                           
                           
                           
-- Get all possible parents in one field?:
-- Your final task in this chapter is to find all possible parents starting from one ID and combine the IDs of all found generations into one field.
WITH tree AS (
	SELECT 
  		ID,
  		Name, 
  		ParentID, 
  		CAST('0' AS VARCHAR(MAX)) as Parent
	FROM family
  	-- Initialize the ParentID to 290 
  	WHERE ParentId = 290   
    UNION ALL
    SELECT 
  		Next.ID, 
  		Next.Name, 
  		Parent.ID,
    	CAST(CASE WHEN Parent.ID = ''
        	      -- Set the Parent field to the current ParentID
                  THEN(CAST(Next.ParentID AS VARCHAR(MAX)))
        	 -- Add the ParentID to the current Parent in each iteration
             ELSE(Parent.Parent + ' -> ' + CAST(Next.ParentID AS VARCHAR(MAX)))
    		 END AS VARCHAR(MAX))
        FROM family AS Next
        	INNER JOIN tree AS Parent 
  			ON Next.ParentID = Parent.ID)
        
-- Select the Name, Parent from tree
Select Name, Parent
FROM tree;
                                                                         
                                                                         
                                                                         
-- Get all possible airports:
-- The task of the next two exercises is to search for all possible flight routes. This means that, first, you have to find out all possible departure and destination airports from the table flightPlan.
-- In this exercise, you will create a CTE table named possible_Airports using the UNION syntax which will consist of all possible airports.
-- One query of the UNION element selects the Departure airports and the second query selects the Arrival airports.
-- Definition of the CTE table
WITH possible_Airports (Airports) AS(
  	-- Select the departure airports
  	SELECT Departure
  	FROM flightPlan
  	-- Combine the two queries
  	UNION
  	-- Select the destination airports
  	SELECT Arrival
  	FROM flightPlan)

-- Get the airports from the CTE table
SELECT Airports
FROM possible_Airports;
                                                                         
                                                                         
                                                                         
-- Create a car's bill of material:
-- In this exercise, you will answer the following question: What are the levels of the different components that build up a car?
-- For example, an SUV (1st level), is made of an engine (2nd level), and a body (2nd level), and the body is made of a door (3rd level) and a hood (3rd level).
-- Your task is to create a query to get the hierarchy level of the table partList.
-- You have to create the CTE construction_Plan and should keep track of the position of a component in the hierarchy. Keep track of all components starting at level 1 going up to level 2.
-- Define CTE with the fields: PartID, SubPartID, Title, Component, Level
WITH construction_Plan (PartID, SubPartID,Title, Component, Level) AS (
	SELECT 
  		PartID,
  		SubPartID,
  		Title,
  		Component,
  		-- Initialize the field Level
  		1
	FROM partList
	WHERE PartID = '1'
	UNION ALL
	SELECT 
		CHILD.PartID, 
  		CHILD.SubPartID,
  		CHILD.Title,
  		CHILD.Component,
  		-- Increment the field Level each recursion step
  		PARENT.Level + 1
	FROM construction_Plan PARENT, partList CHILD
  	WHERE CHILD.SubPartID = PARENT.PartID
  	-- Limit the number of iterations to Level < 2
	  AND PARENT.Level < 2)
      
SELECT DISTINCT PartID, SubPartID, Title, Component, Level
FROM construction_Plan
ORDER BY PartID, SubPartID, Level;
                                                                         
                                                                         
                                                                         
-- Get power lines to maintain
-- In the provided GridStructure table, the fields that describe the connection between lines (EquipmentID,EquipmentID_To,EquipmentID_From) and the characteristics of the lines (e.g. Description, ConditionAssessment, VoltageLevel) are already defined.
-- Now, your task is to find the connected lines of the line with EquipmentID = 3 that have bad or repair as ConditionAssessment and have a VoltageLevel equal to HV.
-- By doing this, you can answer the following question:
-- Which lines have to be replaced or repaired according to their description and their current condition?
-- Define the table CTE 
WITH maintenance_List (Line, Destination, Source, Description, ConditionAssessment, VoltageLevel) AS (
	SELECT 
  		EquipmentID,
  		EquipmentID_To,
  		EquipmentID_From,
  		Description,
  		ConditionAssessment,
  		VoltageLevel
  	FROM GridStructure
 	-- Start the evaluation for line 3
	WHERE EquipmentID = 3
	UNION ALL
	SELECT 
		Child.EquipmentID, 
  		Child.EquipmentID_To,
  		Child.EquipmentID_FROM,
  		Child.Description,
  		Child.ConditionAssessment,
  		Child.VoltageLevel
	FROM GridStructure Child
  		-- Join GridStructure with CTE on the corresponding endpoints
  		JOIN maintenance_List 
    	ON maintenance_List.Line = Child.EquipmentID_FROM)
SELECT Line, Description, ConditionAssessment 
FROM maintenance_List
-- Filter the lines based on ConditionAssessment and VoltageLevel
WHERE 
    (ConditionAssessment LIKE '%exchange%' OR ConditionAssessment LIKE '%repair%') AND 
     VoltageLevel LIKE '%HV%'                                                                       
                                                                         
