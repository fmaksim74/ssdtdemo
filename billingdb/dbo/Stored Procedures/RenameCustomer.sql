CREATE PROCEDURE [dbo].[RenameCustomer]
  @id BIGINT,
  @name NVARCHAR(128)
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @proc_name NVARCHAR(128) = 'BillingDB.RenameCustomer ', @msg NVARCHAR(128);

  IF (@name is NULL) or (LEN(TRIM(@name)) = 0) 
  BEGIN
    SET @msg = @proc_name + 'Error: Customer name expected.';
	  THROW 50001, @msg, 1;
  END

  IF NOT EXISTS(SELECT [ID] FROM [dbo].[Customers] WHERE [ID] = @id)
  BEGIN
    SET @msg = @proc_name + 'Error: There is no customers with ID = ' + CAST(@id AS NVARCHAR(128));
    THROW 50003, @msg, 1
  END
	BEGIN TRY
		UPDATE [dbo].[Customers] SET [Name] = @name WHERE [ID] = @id;
	END TRY
  BEGIN CATCH
    SET @msg = @proc_name + 'Error: Customer "' + @name + '" exists already.';
    THROW 50002, @msg, 1
  END CATCH
END
