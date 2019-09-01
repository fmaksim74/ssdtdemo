/*
Шаблон скрипта после развертывания              
--------------------------------------------------------------------------------------
 В данном файле содержатся инструкции SQL, которые будут добавлены в скрипт построения.    
 Используйте синтаксис SQLCMD для включения файла в скрипт после развертывания.      
 Пример:      :r .\myfile.sql                
 Используйте синтаксис SQLCMD для создания ссылки на переменную в скрипте после развертывания.    
 Пример:      :setvar TableName MyTable              
               SELECT * FROM [$(TableName)]          
--------------------------------------------------------------------------------------
*/

USE [DemoDB1]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('dbo.sf_TestObjectName') IS NOT NULL
  PRINT OBJECT_ID('dbo.sf_TestObjectName')

DROP FUNCTION [dbo].[sf_TestObjectName];


