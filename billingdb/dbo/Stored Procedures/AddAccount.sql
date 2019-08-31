CREATE PROCEDURE [dbo].[AddAccount]
  @customer_id BIGINT,
  @phoneNumber NUMERIC(11,0),
  @tariff_id BIGINT,
  @account_id BIGINT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
  DECLARE @proc_name NVARCHAR(128) = 'BillingDB.AddAccount ', @msg NVARCHAR(128), @err_msg NVARCHAR(4000), @err_code INT;

	DECLARE @inserted table ([ID] BIGINT)
  DECLARE @cust_id BIGINT
  
  SELECT @account_id = [ID], @cust_id = [CustomerID] FROM [dbo].[Accounts] WHERE [PhoneNumber] = @phoneNumber AND [State] = 1;
  IF (@account_id IS NOT NULL)
  BEGIN
    IF (@cust_id <> @customer_id)
    BEGIN
      SET @msg = @proc_name + 'Error: The phone number "' + CAST(@phoneNumber AS NVARCHAR(11)) + '"in use already.';
      THROW 50012, @msg, 1
    END
    ELSE
    BEGIN
      SET @msg = @proc_name + 'Error: The account for customer "' + CAST(@customer_id AS NVARCHAR(16))
                  + '" and phone number "' + CAST(@phoneNumber AS NVARCHAR(11)) + '" exists already.';
      THROW 50013, @msg, 1
    END
  END

	BEGIN TRY
		INSERT INTO [dbo].[Accounts]
		([CustomerID],[PhoneNumber],[TariffID])
    OUTPUT INSERTED.[ID] INTO @inserted
		VALUES (@customer_id,@phoneNumber,@tariff_id);
		SELECT @account_id = [ID] FROM @inserted
	END TRY
  BEGIN CATCH
    SELECT @err_msg = ERROR_MESSAGE()
    SELECT @err_code=(CASE
                        WHEN @err_msg LIKE '%FK_Accounts_CustomerID%' THEN 0
                        WHEN @err_msg LIKE '%FK_Accounts_PhoneNumber%' THEN 4
                        WHEN @err_msg LIKE '%FK_Accounts_TariffID%' THEN 3
                        WHEN @err_msg LIKE '%UN_Account_Customer_Number%' THEN 5
                      END);
    SELECT @msg=(CASE @err_code
                    WHEN 0 THEN
                      @proc_name + 'Error: There is no customer with ID = "' + CAST(@customer_id AS NVARCHAR(16)) + '"'
                    WHEN 4 THEN 
                      @proc_name + 'Error: There is no phone number with ID = "' + CAST(@phoneNumber AS NVARCHAR(16)) + '"'
                    WHEN 3 THEN 
                      @proc_name + 'Error: There is no tariff with ID = "' + CAST(@tariff_id AS NVARCHAR(16)) + '"'
                    WHEN 5 THEN 
                      @proc_name + 'Error: For customer ' + CAST(@customer_id AS NVARCHAR(16)) +
                                             ' and phone number ' + CAST(@phoneNumber AS NVARCHAR(16)) + ' account exists already.'
                  END);
    SET @err_code = @err_code + 50003;
    THROW @err_code, @msg, 1;
  END CATCH
END
