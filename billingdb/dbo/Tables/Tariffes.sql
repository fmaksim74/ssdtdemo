CREATE TABLE [dbo].[Tariffes] (
    [ID]               BIGINT         IDENTITY (1, 1) NOT NULL,
    [CreateDatetime]   DATETIME       CONSTRAINT [DF_Tariffes_CreateDatetime] DEFAULT (getdate()) NOT NULL,
    [State]            TINYINT        CONSTRAINT [DF_Tariffes_State] DEFAULT ((1)) NOT NULL,
    [Name]             NVARCHAR (64)  NOT NULL,
    [Description]      NVARCHAR (255) NULL,
    [CallCost]         SMALLINT       CONSTRAINT [DF_Tariffes_CallCost] DEFAULT ((0)) NOT NULL,
    [SMSCost]          SMALLINT       CONSTRAINT [DF_Tariffes_SMSCost] DEFAULT ((0)) NOT NULL,
    [CashTransferCost] SMALLINT       CONSTRAINT [DF_Tariffes_CashTransferCost] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Tariffes_ID] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [CHK_Tariffes_CallCost_Positive] CHECK ([CallCost]>=(0)),
    CONSTRAINT [CHK_Tariffes_CashTransferCost_Positive] CHECK ([CashTransferCost]>=(0)),
    CONSTRAINT [CHK_Tariffes_SMSCost_Positive] CHECK ([SMSCost]>=(0)),
    CONSTRAINT [UN_Tariffes_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);
