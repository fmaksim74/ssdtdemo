SET IDENTITY_INSERT [dbo].[tblUsers] ON
INSERT INTO [dbo].[tblUsers] ([ID], [Login], [CreataDate], [State], [ApplicationConfig], [Note]) VALUES (1, N'user1', N'2019-08-31 13:13:02', 0, NULL, NULL)
INSERT INTO [dbo].[tblUsers] ([ID], [Login], [CreataDate], [State], [ApplicationConfig], [Note]) VALUES (2, N'user2', N'2019-08-31 13:13:07', 0, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tblUsers] OFF
