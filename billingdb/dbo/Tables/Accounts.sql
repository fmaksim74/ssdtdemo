CREATE TABLE [dbo].[Accounts] (
    [ID]             BIGINT       IDENTITY (1, 1) NOT NULL,
    [CreateDatetime] DATETIME     CONSTRAINT [DF_Accounts_CreateDatetime] DEFAULT (getdate()) NOT NULL,
    [State]          TINYINT      CONSTRAINT [DF_Accounts_State] DEFAULT ((1)) NOT NULL,
    [CustomerID]     BIGINT       NULL,
    [PhoneNumber]    NUMERIC (11) NULL,
    [TariffID]       BIGINT       NULL,
    [RemainedCash]   INT          CONSTRAINT [DF_Accounts_RemainedCash] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Accounts_ID] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Accounts_CustomerID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID]),
    CONSTRAINT [FK_Accounts_PhoneNumber] FOREIGN KEY ([PhoneNumber]) REFERENCES [dbo].[PhoneNumbers] ([ID]),
    CONSTRAINT [FK_Accounts_TariffID] FOREIGN KEY ([TariffID]) REFERENCES [dbo].[Tariffes] ([ID])
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[Accounts] TO [PhoneStation]
    AS [dbo];

