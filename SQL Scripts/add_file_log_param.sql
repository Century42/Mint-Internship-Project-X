USE [project-x]
GO

EXEC dbo.AddFileLog 
	@File_ID = 6,
	@Status = 'Successful',
	@Description = NULL;

GO


