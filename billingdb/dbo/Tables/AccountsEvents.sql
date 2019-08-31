CREATE TABLE [dbo].[AccountsEvents] (
    [ID]            BIGINT   IDENTITY (1, 1) NOT NULL,
    [EventDatetime] DATETIME CONSTRAINT [DF_AccountsEvents_EventDatetime] DEFAULT (getdate()) NOT NULL,
    [AccountID]     BIGINT   NOT NULL,
    [EventTypeID]   BIGINT   NOT NULL,
    [EventAmount]   SMALLINT CONSTRAINT [DF_AccountsEvents_EventAmount] DEFAULT ((0)) NOT NULL,
    [EventCost]     SMALLINT CONSTRAINT [DF_AccountsEvents_EventCost] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_AccountsEvents_ID] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [CHK_AccountsEvents_EventAmount_Positive] CHECK ([EventAmount]>=(0)),
    CONSTRAINT [FK_AccountsEvents_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Accounts] ([ID]),
    CONSTRAINT [FK_AccountsEvents_EventTypeID] FOREIGN KEY ([EventTypeID]) REFERENCES [dbo].[EventTypes] ([ID])
);

