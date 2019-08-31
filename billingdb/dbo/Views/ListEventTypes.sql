CREATE VIEW [dbo].[ListEventTypes]
AS
SELECT [ID],[CreateDatetime],
  CASE [State] WHEN 0 THEN 'Inactive' WHEN 1 THEN 'Active' END AS [State],
  [Name],[Description]
FROM [dbo].[EventTypes]
