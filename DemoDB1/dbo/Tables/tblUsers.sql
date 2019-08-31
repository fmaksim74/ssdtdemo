CREATE TABLE [dbo].[Table1]
(
	[ID] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_tblUsers_ID PRIMARY KEY, 
    [Login] NVARCHAR(64) NOT NULL CONSTRAINT UC_tblUsers_Login UNIQUE, 
    [CreataDate] DATETIME NOT NULL CONSTRAINT DF_tblUsers_CreateDate DEFAULT CURRENT_TIMESTAMP, 
	[State] TINYINT NOT NULL CONSTRAINT DF_tblUsers_State DEFAULT 0, 
    [ApplicationConfig] NTEXT NULL
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Внутренний идентификатор пользователя',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Table1',
    @level2type = N'COLUMN',
    @level2name = N'ID'