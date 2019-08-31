CREATE VIEW [dbo].[ListAccounts]
AS
SELECT C.[ID] As [CustomerID], C.[Name] As [CustomerName],
       N.[ID] AS [PhoneNumber], 
       A.[ID] AS [AccountID], A.[CreateDatetime] AS [AccountDatetime], A.[RemainedCash] AS [AccountCash],
       CASE A.[State] WHEN 0 THEN 'Inactive' WHEN 1 THEN 'Active' END AS [AccountState],
       T.[ID] AS [TariffID], T.[Name] AS [TariffName]
FROM [dbo].[Accounts] A
  INNER JOIN [dbo].[Customers] C
    ON C.[ID] = A.[CustomerID] 
  INNER JOIN [dbo].[PhoneNumbers] N
    ON N.[ID] = A.[PhoneNumber]
  INNER JOIN [dbo].[Tariffes] T
    ON T.[ID] = A.[TariffID]

GO
GRANT SELECT
    ON OBJECT::[dbo].[ListAccounts] TO [ARMApplication]
    AS [dbo];

