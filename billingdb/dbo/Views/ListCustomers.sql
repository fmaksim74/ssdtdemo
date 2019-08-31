CREATE VIEW [dbo].[ListCustomers]
AS
SELECT [ID],[CreateDatetime],
  CASE [State] WHEN 0 THEN 'Inactive' WHEN 1 THEN 'Active' END AS [State],
  [Name]
FROM [dbo].[Customers]

GO
GRANT SELECT
    ON OBJECT::[dbo].[ListCustomers] TO [ARMApplication]
    AS [dbo];

