CREATE PROCEDURE [dbo].[UpdateTariff]
  @id BIGINT,
  @name NVARCHAR(128) = NULL,
  @description NVARCHAR(255) = NULL,
  @callCost SMALLINT = NULL,
  @smsCost SMALLINT = NULL,
  @cashTransferCost SMALLINT = NULL
AS
BEGIN
	SET NOCOUNT ON;
  DECLARE @proc_name NVARCHAR(128) = 'BillingDB.UpdateTariff ', @msg NVARCHAR(128),@err_msg NVARCHAR(4000);

	IF NOT EXISTS(SELECT [ID] FROM [dbo].[Tariffes] WHERE [ID] = @id)
  BEGIN
    SET @msg = @proc_name + 'Error: There is no tariff with ID = ' + CAST(@id AS NVARCHAR(128));
    THROW 50006, @msg, 1
  END
 
	BEGIN TRY
    UPDATE [dbo].[Tariffes]
      SET [Name] = (CASE
                      WHEN @name IS NULL OR LEN(TRIM(@name)) = 0  THEN [Name] ELSE @name
                    END),
          [Description] = (CASE
                              WHEN @description IS NULL THEN [Description]
                              ELSE @description
                            END), 
          [CallCost] = (CASE
                          WHEN @callCost IS NULL THEN [CallCost]
                          ELSE @callCost
                        END), 
          [SMSCost] = (CASE
                          WHEN @smsCost IS NULL THEN [SMSCost]
                          ELSE @smsCost
                        END), 
          [CashTransferCost] = (CASE
                                  WHEN @cashTransferCost IS NULL THEN [CashTransferCost]
                                  ELSE @cashTransferCost
                                END)
    WHERE [ID] = @id;
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
    THROW 50007, @msg, 1;
  END CATCH
END
