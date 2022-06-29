-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE dbo.CreateWeek
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
	DECLARE @Date date = GETDATE()

	IF ((SELECT COUNT(*) FROM dbo.Weeks WHERE Year = DATEPART(YEAR, @date) AND Week = DATEPART(WEEK, @Date)) = 0)
	INSERT INTO [dbo].[Weeks]
           ([Year]
           ,[Week])
     VALUES
           (DATEPART(YEAR, @date)
           ,DATEPART(WEEK, @date))
	ELSE PRINT 'This date already exists'
END
GO
