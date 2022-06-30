USE [project-x]
GO

EXEC dbo.AddFileLog 
	@File_ID = 0,
	@Status = 'Status',
	@Description = 'Description'

GO


