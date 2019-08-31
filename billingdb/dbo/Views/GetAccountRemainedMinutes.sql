CREATE VIEW [dbo].[GetAccountRemainedMinutes]
AS
SELECT A.[RemainedCash] / T.[CallCost] AS [Remained]
FROM [dbo].[Accounts] A
  INNER JOIN [dbo].[PhoneNumbers] N
    ON N.[ID] = A.[PhoneNumber]
  INNER JOIN [dbo].[Tariffes] T
    ON T.[ID] = A.[TariffID]

GO
GRANT SELECT
    ON OBJECT::[dbo].[GetAccountRemainedMinutes] TO [PhoneStation]
    AS [dbo];

