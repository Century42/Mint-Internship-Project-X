USE [project-x]
GO
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
           ,1
           ,2
           ,1
           ,GETDATE())
GO


