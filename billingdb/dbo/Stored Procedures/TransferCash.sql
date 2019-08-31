CREATE PROCEDURE [dbo].[TransferCash]
  @from_account BIGINT,
  @to_account BIGINT,
  @cash_amount SMALLINT
AS
BEGIN
  EXEC [dbo].[AddAccountEvent] @account1_id = @from_account, @account2_id = @to_account, @eventType_id = 5, @eventCost = @cash_amount;
END
--Create view for events history
IF EXISTS(SELECT [object_id] FROM [sys].[all_objects] WHERE [type] = 'V' AND [name] = 'ListAccountEvents')
  DROP VIEW [dbo].[ListAccountEvents]

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[TransferCash] TO [MobileApplication]
    AS [dbo];

