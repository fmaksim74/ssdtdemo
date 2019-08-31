CREATE TABLE [dbo].[EventTypes] (
    [ID]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [CreateDatetime] DATETIME       CONSTRAINT [DF_EventTypes_CreateDatetime] DEFAULT (getdate()) NOT NULL,
    [State]          TINYINT        CONSTRAINT [DF_EventTypes_State] DEFAULT ((1)) NOT NULL,
    [Name]           NVARCHAR (64)  NOT NULL,
    [Description]    NVARCHAR (255) NULL,
    CONSTRAINT [PK_EventTypes_ID] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [UN_EventTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[EventTypes] TO [PhoneStation]
    AS [dbo];

