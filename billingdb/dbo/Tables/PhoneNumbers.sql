CREATE TABLE [dbo].[PhoneNumbers] (
    [ID]             NUMERIC (11) NOT NULL,
    [CreateDatetime] DATETIME     CONSTRAINT [DF_PhoneNumbers_CreateDatetime] DEFAULT (getdate()) NOT NULL,
    [State]          TINYINT      CONSTRAINT [DF_PhoneNumbers_State] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PhoneNumbers_ID] PRIMARY KEY CLUSTERED ([ID] ASC)
);

