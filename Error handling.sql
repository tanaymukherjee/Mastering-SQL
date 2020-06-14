-- Set up the TRY block:
BEGIN TRY
	-- Add the constraint
	ALTER TABLE products
		ADD CONSTRAINT CHK_Stock CHECK (stock >= 0);
END TRY
-- Set up the CATCH block
BEGIN CATCH
	SELECT 'An error occurred!';
END CATCH



-- Nesting TRY...CATCH constructs:
-- Set up the first TRY block
BEGIN TRY
	INSERT INTO buyers (first_name, last_name, email, phone)
		VALUES ('Peter', 'Thompson', 'peterthomson@mail.com', '555000100');
END TRY
-- Set up the first CATCH block
BEGIN CATCH
	SELECT 'An error occurred inserting the buyer! You are in the first CATCH block';
    -- Set up the nested TRY block
    BEGIN TRY
    	INSERT INTO errors 
        	VALUES ('Error inserting a buyer');
        SELECT 'Error inserted correctly!';
    END TRY    
    -- Set up the nested CATCH block
    BEGIN CATCH
    	SELECT 'An error occurred inserting the error! You are in the nested CATCH block';
    END CATCH    
END CATCH



-- Correcting compilation errors:
BEGIN TRY
	INSERT INTO products (product_name, stock, price)
		VALUES ('Sun Bicycles ElectroLite - 2017', 10, 1559.99);
END TRY
BEGIN CATCH
	SELECT 'An error occurred inserting the product!';
    BEGIN TRY
    	INSERT INTO errors 
        	VALUES ('Error inserting a product');
    END TRY    
    BEGIN CATCH
    	SELECT 'An error occurred inserting the error!';
    END CATCH    
END CATCH



-- Which of the following is true about the functions:
-- ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), and ERROR_MESSAGE()?
-- These functions must be placed within the CATCH block. If an error occurs within the TRY block, they return information about the error.



-- Using error functions:
-- Set up the TRY block
BEGIN TRY	
	SELECT 'Total: ' + SUM(price * quantity) AS total
  	FROM orders 
END TRY
-- Set up the CATCH block
BEGIN CATCH
	-- Show error information.
	SELECT  ERROR_NUMBER() AS number,  
        	ERROR_SEVERITY() AS severity_level,  
        	ERROR_STATE() AS state,
        	ERROR_LINE() AS line,  
        	ERROR_MESSAGE() AS message; 	    
END CATCH 



-- Using error functions in a nested TRY...CATCH:
BEGIN TRY
    INSERT INTO products (product_name, stock, price) 
    VALUES	('Trek Powerfly 5 - 2018', 2, 3499.99),   		
    		('New Power K- 2018', 3, 1999.99)		
END TRY
-- Set up the outer CATCH block
BEGIN CATCH
	SELECT 'An error occurred inserting the product!';
    -- Set up the inner TRY block
    BEGIN TRY
    	-- Insert the error
    	INSERT INTO errors 
        	VALUES ('Error inserting a product');
    END TRY    
    -- Set up the inner CATCH block
    BEGIN CATCH
    	-- Show number and message error
    	SELECT 
        	ERROR_LINE() AS line,	   
			ERROR_MESSAGE() AS message; 
    END CATCH    
END CATCH



-- CATCHING the RAISERROR:
-- Set @product_id to 5
DECLARE @product_id INT = 5;

IF NOT EXISTS (SELECT * FROM products WHERE product_id = @product_id)
	-- Invoke RAISERROR with parameters
	RAISERROR('No product with id %d.', 11, 1, @product_id);
ELSE 
	SELECT * FROM products WHERE product_id = @product_id;
  
  
  
  -- THROW without parameters:
CREATE PROCEDURE insert_product
  @product_name VARCHAR(50),
  @stock INT,
  @price DECIMAL
AS
BEGIN TRY
	INSERT INTO products (product_name, stock, price)
		VALUES (@product_name, @stock, @price);
END TRY
-- Set up the CATCH block
BEGIN CATCH	
	-- Insert the error and end the statement with a semicolon
    INSERT INTO errors VALUES ('Error inserting a product');  
    -- Re-throw the error
	THROW;  
END CATCH



-- Executing a stored procedure that throws an error:
BEGIN TRY
	-- Execute the stored procedure
	EXEC insert_product 
    	-- Set the values for the parameters
    	@product_name = 'Super bike',
        @stock = 3,
        @price = 499.99;
END TRY
-- Set up the CATCH block
BEGIN CATCH
	-- Select the error message
	SELECT ERROR_MESSAGE();
END CATCH



-- THROW with parameters:
-- You need to prepare a script to select all the information of a member from the staff table using a given staff_id.
-- If the select statement doesn't find any member, you want to throw an error using the THROW statement.
-- You need to warn there is no staff member with such id.
-- Set @staff_id to 4
DECLARE @staff_id INT = 4;

IF NOT EXISTS (SELECT * FROM staff WHERE staff_id = @staff_id)
   	-- Invoke the THROW statement with parameters
    
    
    
-- Concatenating the message:
-- You need to prepare a script to select all the information about the members from the staff table using a given first_name.
-- If the select statement doesn't find any member, you want to throw an error using the THROW statement.
-- You need to warn there is no staff member with such a name.
-- Set @first_name to 'Pedro'
DECLARE @first_name NVARCHAR(20) = 'Pedro';
-- Concat the message
DECLARE @my_message NVARCHAR(500) =
	CONCAT('There is no staff member with ', @first_name, ' as the first name.');

IF NOT EXISTS (SELECT * FROM staff WHERE first_name = @first_name)
	-- Throw the error
	THROW 50000, @my_message, 1;
  
  
  
-- FORMATMESSAGE with message string:
-- Every time you sell a bike in your store, you need to check if there is enough stock.
-- You prepare a script to check it and throw an error if there is not enough stock.
-- Today, you sold 10 'Trek CrossRip+ - 2018' bikes, so you need to check if you can sell them.
DECLARE @product_name AS NVARCHAR(50) = 'Trek CrossRip+ - 2018';
DECLARE @number_of_sold_bikes AS INT = 10;
DECLARE @current_stock INT;
-- Select the current stock
SELECT @current_stock = stock FROM products WHERE product_name = @product_name;
DECLARE @my_message NVARCHAR(500) =
	-- Customize the message
	FORMATMESSAGE('There are not enough %s bikes. You only have %d in stock.', @product_name, @current_stock);

IF (@current_stock - @number_of_sold_bikes < 0)
	-- Throw the error
	THROW 50000, @my_message, 1;
  
  
  
-- FORMATMESSAGE with message number:
-- Like in the previous exercise, you need to check if there is enough stock when you sell a product.
-- This time you want to add your custom error message to the sys.messages catalog, by executing the sp_addmessage stored procedure.
-- Pass the variables to the stored procedure
EXEC sp_addmessage @msgnum = 50002, @severity = 16, @msgtext = 'There are not enough %s bikes. You only have %d in stock.', @lang = N'us_english';

DECLARE @product_name AS NVARCHAR(50) = 'Trek CrossRip+ - 2018';
DECLARE @number_of_sold_bikes AS INT = 10;
DECLARE @current_stock INT;
SELECT @current_stock = stock FROM products WHERE product_name = @product_name;
DECLARE @my_message NVARCHAR(500) =
	-- Prepare the error message
	FORMATMESSAGE(50002, @product_name, @current_stock);

IF (@current_stock - @number_of_sold_bikes < 0)
	-- Throw the error
	THROW 50000, @my_message, 1;
  
  
  
  -- Rolling back a transaction if there is an error:
BEGIN TRY  
	-- Begin the transaction
	BEGIN TRAN;
		UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
		INSERT INTO transactions VALUES (1, -100, GETDATE());
        
		UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
        -- Correct it
		INSERT INTO transactions VALUES (5, 100, GETDATE());
    -- Commit the transaction
	COMMIT TRAN;    
END TRY
BEGIN CATCH  
	SELECT 'Rolling back the transaction';
    -- Rollback the transaction
	ROLLBACK TRAN;
END CATCH
                                     
                                     
                                     
-- Choosing when to commit or rollback a transaction:
-- The bank where you work has decided to give $100 to those accounts with less than $5,000.
-- However, the bank director only wants to give that money if there aren't more than 200 accounts with less than $5,000.
-- You prepare a script to give those $100, and of the multiple ways of doing it, you decide to open a transaction and then update every account with a balance of less than $5,000.
-- After that, you check the number of the rows affected by the update, using the @@ROWCOUNT function. If this number is bigger than 200, you rollback the transaction. Otherwise, you commit it.
-- How do you prepare the script?
-- Begin the transaction
BEGIN TRAN; 
	UPDATE accounts set current_balance = current_balance + 100
		WHERE current_balance < 5000;
	-- Check number of affected rows
	IF @@ROWCOUNT > 200 
		BEGIN 
        	-- Rollback the transaction
			ROLLBACK TRAN; 
			SELECT 'More accounts than expected. Rolling back'; 
		END
	ELSE
		BEGIN 
        	-- Commit the transaction
			COMMIT TRAN; 
			SELECT 'Updates commited'; 
		END
                                     
                                     
                                     
-- Checking @@TRANCOUNT in a TRY...CATCH construct:
-- The owner of account 10 has won a raffle and will be awarded $200.
-- You prepare a simple script to add those $200 to the current_balance of account 10. You think you have written everything correctly, but you prefer to check your code.
-- In fact, you made a silly mistake when adding the money: SET current_balance = 'current_balance' + 200.
-- You wrote 'current_balance' as a string, which generates an error.
-- The script you create should rollback every change if an error occurs, checking if there is an open transaction.
-- If everything goes correctly, the transaction should be committed, also checking if there is an open transaction.
  BEGIN TRY
	-- Begin the transaction
	BEGIN TRAN;
    	-- Correct the mistake
		UPDATE accounts SET current_balance = current_balance + 200
			WHERE account_id = 10;
    	-- Check if there is a transaction
		IF @@TRANCOUNT > 0     
    		-- Commit the transaction
			COMMIT TRAN;
     
	SELECT * FROM accounts
    	WHERE account_id = 10;      
END TRY
BEGIN CATCH  
    SELECT 'Rolling back the transaction'; 
    -- Check if there is a transaction
    IF @@TRANCOUNT > 0   	
    	-- Rollback the transaction
        ROLLBACK TRAN;
END CATCH
                                     
                                     
                                     
-- Using savepoints:
BEGIN TRAN;
	-- Mark savepoint1
	SAVE TRAN savepoint1;
	INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');

	-- Mark savepoint2
    SAVE TRAN savepoint2;
	INSERT INTO customers VALUES ('Zack', 'Roberts', 'zackroberts@mail.com', '555919191');

	-- Rollback savepoint2
	ROLLBACK TRAN savepoint2;
    -- Rollback savepoint1
	ROLLBACK TRAN savepoint1;

	-- Mark savepoint3
	SAVE TRAN savepoint3;
	INSERT INTO customers VALUES ('Jeremy', 'Johnsson', 'jeremyjohnsson@mail.com', '555929292');
-- Commit the transaction
COMMIT TRAN;
                                     
                                     
                                     
-- XACT_ABORT and THROW:
-- The wealthiest customers of the bank where you work have decided to donate the 0.01% of their current_balance to a non-profit organization.
-- You are in charge of preparing the script to update the customer's accounts, but you have to do it only for those accounts with a current_balance with more than $5,000,000.
-- The director of the bank tells you that if there aren't at least 10 wealthy customers, you shouldn't do this operation, because she wants to interview more customers.
-- You prepare a script, and of the multiple ways of doing it, you decide to use XACT_ABORT in combination with THROW.
-- This way, if the number of affected rows is less than or equal to 10, you can throw an error so that the transaction is rolled back.
-- Use the appropriate setting
SET XACT_ABORT ON;
-- Begin the transaction
BEGIN TRAN; 
	UPDATE accounts set current_balance = current_balance - current_balance * 0.01 / 100
		WHERE current_balance > 5000000;
	IF @@ROWCOUNT <= 10	
    	-- Throw the error
		THROW 55000, 'Not enough wealthy customers!', 1;
	ELSE		
    	-- Commit the transaction
		COMMIT TRAN; 
                                     
                                     
                                     
-- Doomed transactions:
-- You want to insert the data of two new customers into the customer table.
-- You prepare a script controlling that if an error occurs, the transaction rollbacks and you get the message of the error.
-- You want to control it using XACT_ABORT in combination with XACT_STATE.
-- Use the appropriate setting
SET XACT_ABORT ON;
BEGIN TRY
	BEGIN TRAN;
		INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');
		INSERT INTO customers VALUES ('Dylan', 'Smith', 'dylansmith@mail.com', '555888999');
	COMMIT TRAN;
END TRY
BEGIN CATCH
	-- Check if there is an open transaction
	IF XACT_STATE() <> 0
    	-- Rollback the transaction
		ROLLBACK TRAN;
    -- Select the message of the error
    SELECT ERROR_MESSAGE() AS Error_message;
END CATCH
