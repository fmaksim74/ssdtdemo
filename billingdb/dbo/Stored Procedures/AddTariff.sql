CREATE PROCEDURE [dbo].[AddTariff]
  @name NVARCHAR(128),
  @description NVARCHAR(255) = '',
  @callCost SMALLINT = 0,
  @smsCost SMALLINT = 0,
  @cashTransferCost SMALLINT = 0,
  @tariff_id BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
  DECLARE @proc_name NVARCHAR(128) = 'BillingDB.AddTariff ', @msg NVARCHAR(128),@err_msg NVARCHAR(4000);

	DECLARE @inserted table ([ID] BIGINT)
     	
	IF (@name is NULL) or (LEN(TRIM(@name)) = 0) 
  BEGIN  
    SET @msg = @proc_name + 'Error: Tariff name expected.';
		THROW  50004, @msg, 1
  END
	
	BEGIN TRY
		INSERT INTO [dbo].[Tariffes]
		([Name],[Description],[CallCost],[SMSCost],[CashTransferCost])
    OUTPUT INSERTED.[ID] INTO @inserted
		VALUES (@name,@description,@callCost,@smsCost,@cashTransferCost);
		SELECT @tariff_id = [ID] FROM @inserted
	END TRY
  BEGIN CATCH
    SELECT @err_msg = ERROR_MESSAGE()
    SELECT @msg=(CASE
                    WHEN @err_msg LIKE '%UN_Tariffes_Name%' THEN
                      @proc_name + 'Error: Tariff "' + @name + '" exists already.'
                    WHEN @err_msg LIKE '%CHK_Tariffes_CallCost_Positive%' THEN 
                      @proc_name + 'Error: Tariff "' + @name + '" call cost cannot be negative.'
                    WHEN @err_msg LIKE '%CHK_Tariffes_SMSCost_Positive%' THEN 
                      @proc_name + 'Error: Tariff "' + @name + '" SMS cost cannot be negative.'
                    WHEN @err_msg LIKE '%CHK_Tariffes_CashTransferCost_Positive%' THEN 
                      @proc_name + 'Error: Tariff "' + @name + '" cash transfer cost cannot be negative.'
                  END);
    THROW 50005, @msg, 1;
  END CATCH
END
