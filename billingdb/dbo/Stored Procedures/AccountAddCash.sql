CREATE PROCEDURE [dbo].[AccountAddCash]
  @id BIGINT,
  @cashAmount SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
  DECLARE @proc_name NVARCHAR(128) = 'BillingDB.AccountAddCash ', @msg NVARCHAR(128), @err_msg NVARCHAR(4000), @err_code INT;

  IF NOT EXISTS(SELECT [ID] FROM [dbo].[Accounts] WHERE [ID] = @id)
  BEGIN
    SET @msg = @proc_name + 'Error: There is no account with ID = ' + CAST(@id AS NVARCHAR(128));
    THROW 50009, @msg, 1
  END

  BEGIN TRANSACTION
    INSERT INTO [dbo].[AccountsEvents] ([AccountID],[EventTypeID],[EventAmount],[EventCost])
      VALUES (@id, 3, 1, @cashAmount);
    UPDATE [dbo].[Accounts]
      SET [RemainedCash] = [RemainedCash] + @cashAmount
      WHERE [ID] = @id;
  COMMIT TRANSACTION
END
--Create tables for accounts events
IF EXISTS(SELECT [object_id] FROM [sys].[all_objects] WHERE [type] = 'U' AND [name] = 'AccountsEvents')
  DROP TABLE [dbo].[AccountsEvents]

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[AccountAddCash] TO [ARMApplication]
    AS [dbo];

