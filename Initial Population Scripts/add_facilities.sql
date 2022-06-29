USE [project-x]
GO

DELETE FROM [dbo].[Facilities]
DBCC CHECKIDENT ('[dbo].[Facilities]', RESEED, 0)

INSERT INTO [dbo].[Facilities]
           ([Facility_Name])
     VALUES
           ('KwaZulu-Natal'),
		   ('Western Cape'),
		   ('Gauteng');
GO


