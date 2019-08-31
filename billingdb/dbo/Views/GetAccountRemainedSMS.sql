CREATE VIEW [dbo].[GetAccountRemainedSMS]
AS
SELECT A.[RemainedCash] / T.[SMSCost] AS [Remained]
FROM [dbo].[Accounts] A
  INNER JOIN [dbo].[PhoneNumbers] N
    ON N.[ID] = A.[PhoneNumber]
  INNER JOIN [dbo].[Tariffes] T
    ON T.[ID] = A.[TariffID]

GO
GRANT SELECT
    ON OBJECT::[dbo].[GetAccountRemainedSMS] TO [PhoneStation]
    AS [dbo];

