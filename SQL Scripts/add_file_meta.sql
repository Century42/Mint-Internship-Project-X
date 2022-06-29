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
           ,(SELECT Facility_ID FROM dbo.Facilities WHERE Facility_Name = 'KwaZulu-Natal')
           ,(SELECT Type_ID FROM dbo.File_Types WHERE File_Type = 'tb_csv')
           ,(SELECT User_ID FROM dbo.Users WHERE User_Name = 'matthewkeys')
           ,GETDATE())
GO


