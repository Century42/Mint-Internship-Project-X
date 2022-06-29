DECLARE @Date date = GETDATE()

IF ((SELECT COUNT(*) FROM dbo.Weeks WHERE Year = DATEPART(YEAR, @date) AND Week = DATEPART(WEEK, @Date)) = 0)
INSERT INTO [dbo].[Weeks]
           ([Year]
           ,[Week])
     VALUES
           (DATEPART(YEAR, @date)
           ,DATEPART(WEEK, @date))
ELSE PRINT 'This date already exists'
