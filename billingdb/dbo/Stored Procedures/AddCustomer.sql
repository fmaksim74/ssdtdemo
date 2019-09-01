CREATE PROCEDURE [dbo].[AddCustomer]
	@name NVARCHAR(128),
	@customer_id BIGINT = 0 OUTPUT
AS
BEGIN
  /* Процедура добавления нового клиента */
	SET NOCOUNT ON;
  
  DECLARE @proc_name NVARCHAR(128) = 'BillingDB.AddCustomer ', @msg NVARCHAR(128);

	DECLARE @inserted table ([ID] BIGINT);
    	
	IF (@name is NULL) or (LEN(TRIM(@name)) = 0) 
  BEGIN  
    SET @msg = @proc_name + 'Error: Customer name expected.';
		THROW  50001, @msg, 1
  END
	ELSE
		BEGIN TRY
			INSERT INTO [dbo].[Customers]
			([Name])
      OUTPUT INSERTED.[ID] INTO @inserted
			VALUES (@name);
			SELECT @customer_id = [ID] FROM @inserted
		END TRY
    BEGIN CATCH
      SET @msg =  @proc_name + 'Error: Customer "' + @name + '" exists already.';
      THROW 50002, @msg, 1
    END CATCH
END
