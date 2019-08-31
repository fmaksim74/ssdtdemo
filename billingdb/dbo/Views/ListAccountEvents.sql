CREATE VIEW [dbo].[ListAccountEvents]
AS
SELECT 
  A.[PhoneNumber], A.[CustomerID],
  E.ID AS [EventID], E.[EventDatetime] AS [EventDatetime], T.[Name] As [EventName], T.[Description] AS [EventDescription],
  E.[EventCost] AS [EventCost]
FROM [dbo].[Accounts] A
  INNER JOIN [dbo].[AccountsEvents] E
    ON E.[AccountID] = A.[ID]
  INNER JOIN [dbo].[EventTypes] T
    ON T.[ID] = E.[EventTypeID]

GO
GRANT SELECT
    ON OBJECT::[dbo].[ListAccountEvents] TO [MobileApplication]
    AS [dbo];

