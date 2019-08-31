CREATE PROCEDURE [dbo].[AddAccountEvent]
  @account1_id BIGINT,
  @account2_id BIGINT = 0,
  @eventType_id BIGINT,
  @eventAmount SMALLINT = 1,
  @eventCost SMALLINT = 0
AS
BEGIN
	SET NOCOUNT ON;
  DECLARE @proc_name NVARCHAR(128) = 'BillingDB.AddAccountEvent ', @msg NVARCHAR(128), @err_msg NVARCHAR(4000), @err_code INT;

  IF NOT EXISTS(SELECT [ID] FROM [dbo].[Accounts] WHERE [ID] = @account1_id)
  BEGIN
    SET @msg = @proc_name + 'Error: There is no account with ID = ' + CAST(@account1_id AS NVARCHAR(128));
    THROW 50009, @msg, 1
  END
  IF NOT EXISTS(SELECT [ID] FROM [dbo].[EventTypes] WHERE [ID] = @eventType_id)
  BEGIN
    SET @msg = @proc_name + 'Error: There is no event type with ID = ' + CAST(@eventType_id AS NVARCHAR(128));
    THROW 50010, @msg, 1
  END
  IF @eventAmount < 1
  BEGIN
    SET @msg = @proc_name + 'Error: Empty or incorrect event amount = ' + CAST(@eventAmount AS NVARCHAR(128));
    THROW 50011, @msg, 1;
  END

  DECLARE @tariffCallCost SMALLINT, @tariffSMSCost SMALLINT, @tariffCashTransferCost SMALLINT;
  
  SELECT @tariffCallCost = [CallCost], @tariffSMSCost = [SMSCost], @tariffCashTransferCost = [CashTransferCost]
  FROM [dbo].[Tariffes] WHERE [ID] = (SELECT [TariffID] FROM [dbo].[Accounts] WHERE [ID] = @account1_id);

  DECLARE @remained_cash SMALLINT
  SELECT @remained_cash = [RemainedCash] FROM [dbo].[Accounts] WHERE [ID] = @account1_id;

  IF @eventType_id IN (1,2)
  BEGIN
    SET @eventCost = (
      CASE @eventType_id
        WHEN 1 THEN @tariffCallCost
        WHEN 2 THEN @tariffSMSCost
      END);

    IF @remained_cash < @eventCost * @eventAmount
    BEGIN
      SET @msg = @proc_name + 'Error: Not enaugh cash on account ' + CAST(@account1_id AS NVARCHAR(128));
      THROW 50012, @msg, 1;
    END

    BEGIN TRANSACTION
      INSERT INTO [dbo].[AccountsEvents] ([AccountID],[EventTypeID],[EventAmount],[EventCost])
        VALUES (@account1_id, @eventType_id, @eventAmount, @eventCost * (-1) * @eventAmount);
      UPDATE [dbo].[Accounts]
        SET [RemainedCash] = [RemainedCash] - @eventCost * @eventAmount
        WHERE [ID] = @account1_id;
    COMMIT TRANSACTION
  END

  IF @eventType_id = 3 
  BEGIN
    BEGIN TRANSACTION
      INSERT INTO [dbo].[AccountsEvents] ([AccountID],[EventTypeID],[EventAmount],[EventCost])
        VALUES (@account1_id, @eventType_id, @eventAmount, @eventCost * @eventAmount);
      UPDATE [dbo].[Accounts]
        SET [RemainedCash] = [RemainedCash] + @eventCost * @eventAmount
        WHERE [ID] = @account1_id;
    COMMIT TRANSACTION
  END

  IF @eventType_id = 4
  BEGIN
    IF @remained_cash < @eventCost * @eventAmount
    BEGIN
      SET @msg = @proc_name + 'Error: Not enaugh cash on account ' + CAST(@account1_id AS NVARCHAR(128));
      THROW 50012, @msg, 1;
    END

    BEGIN TRANSACTION
      INSERT INTO [dbo].[AccountsEvents] ([AccountID],[EventTypeID],[EventAmount],[EventCost])
        VALUES (@account1_id, @eventType_id, @eventAmount, @eventCost * (-1) * @eventAmount);
      UPDATE [dbo].[Accounts]
        SET [RemainedCash] = [RemainedCash] - @eventCost * @eventAmount
        WHERE [ID] = @account1_id;
    COMMIT TRANSACTION
  END

  IF @eventType_id = 5
  BEGIN
    IF @remained_cash < @eventCost * @eventAmount
    BEGIN
      SET @msg = @proc_name + 'Error: Not enaugh cash on account ' + CAST(@account1_id AS NVARCHAR(128));
      THROW 50012, @msg, 1;
    END

    IF NOT EXISTS(SELECT [ID] FROM [dbo].[Accounts] WHERE [ID] = @account2_id)
    BEGIN
      SET @msg = @proc_name + 'Error: There is no account with ID = ' + CAST(@account2_id AS NVARCHAR(128));
      THROW 50009, @msg, 1
    END
    BEGIN TRANSACTION
      INSERT INTO [dbo].[AccountsEvents] ([AccountID],[EventTypeID],[EventAmount],[EventCost])
        VALUES (@account1_id, @eventType_id, @eventAmount, (-1) * (@eventCost * @eventAmount + @tariffCashTransferCost));
      UPDATE [dbo].[Accounts]
        SET [RemainedCash] = [RemainedCash] - (@eventCost * @eventAmount + @tariffCashTransferCost)
        WHERE [ID] = @account1_id;
      INSERT INTO [dbo].[AccountsEvents] ([AccountID],[EventTypeID],[EventAmount],[EventCost])
        VALUES (@account2_id, @eventType_id, @eventAmount, @eventCost * @eventAmount);
      UPDATE [dbo].[Accounts]
        SET [RemainedCash] = [RemainedCash] + @eventCost * @eventAmount
        WHERE [ID] = @account2_id;
    COMMIT TRANSACTION
  END
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[AddAccountEvent] TO [PhoneStation]
    AS [dbo];

