CREATE TABLE [dbo].[Customers] (
    [ID]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [CreateDatetime] DATETIME       CONSTRAINT [DF_Customers_CreateDatetime] DEFAULT (getdate()) NOT NULL,
    [State]          TINYINT        CONSTRAINT [DF_Customers_State] DEFAULT ((1)) NOT NULL,
    [Name]           NVARCHAR (128) NOT NULL,
    CONSTRAINT [PK_Customers_ID] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [UN_Customers_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);

