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
CREATE PROCEDURE dbo.AddFileMeta @Facility nvarchar(50), @File_Type nvarchar(10), @User_Name nvarchar(50)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
    DECLARE @Date date = GETDATE()
	EXEC dbo.CreateWeek;

	INSERT INTO [dbo].[Files]
           ([Week_ID]
           ,[Facility_ID]
           ,[Type_ID]
           ,[User_ID]
           ,[Insert_Date])
     VALUES
           ((SELECT Week_ID FROM dbo.Weeks WHERE Year = DATEPART(YEAR, @date) AND Week = DATEPART(WEEK, @Date))
           ,(SELECT Facility_ID FROM dbo.Facilities WHERE Facility_Name = @Facility)
           ,(SELECT Type_ID FROM dbo.File_Types WHERE File_Type = @File_Type)
           ,(SELECT User_ID FROM dbo.Users WHERE User_Name = @User_Name)
           ,GETDATE())
END
GO
