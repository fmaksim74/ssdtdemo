CREATE TABLE [dbo].[tblPersons]
(
	[ID] INT NOT NULL  IDENTITY(1, 1) CONSTRAINT PK_tblPersons_ID PRIMARY KEY, 
	[CreateDate] DATETIME NOT NULL CONSTRAINT DF_tblPersons_CreateDate DEFAULT CURRENT_TIMESTAMP,
    [LoginID] INT NOT NULL CONSTRAINT DF_tblPersons_LoginID DEFAULT 0,
	[FirstName] NVARCHAR(128) NULL,
	[MiddleName] NVARCHAR(128) NULL,
	[LastName] NVARCHAR(128) NULL,
	[Gender] CHAR(1) CONSTRAINT CK_tblPersons_Gender CHECK (Gender IN ('M','F'))
					 CONSTRAINT DF_tglPersons_Gender DEFAULT 'M', 
    CONSTRAINT [FK_tblPersons_tblUsers] FOREIGN KEY ([LoginID]) REFERENCES [tblUsers]([ID])
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Идентификатор персоны',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'tblPersons',
    @level2type = N'COLUMN',
    @level2name = N'ID'