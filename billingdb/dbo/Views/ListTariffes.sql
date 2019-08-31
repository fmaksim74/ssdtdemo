CREATE VIEW [dbo].[ListTariffes]
AS
SELECT [ID],[CreateDatetime],
  CASE [State] WHEN 0 THEN 'Inactive' WHEN 1 THEN 'Active' END AS [State],
  [Name],[Description],[CallCost],[SMSCost],[CashTransferCost]
FROM [dbo].[Tariffes]

GO
GRANT SELECT
    ON OBJECT::[dbo].[ListTariffes] TO [ARMApplication]
    AS [dbo];

