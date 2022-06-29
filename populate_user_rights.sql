DELETE FROM dbo.User_File_Types 
 
INSERT INTO dbo.User_File_Types
     (User_ID, Type_ID)
     SELECT dbo.Users.User_ID, dbo.File_Types.Type_ID 
	 FROM dbo.Users, dbo.File_Types
     WHERE dbo.Users.User_Name = 'matthewkeys'

INSERT INTO dbo.User_File_Types
     (User_ID, Type_ID)
     SELECT dbo.Users.User_ID, dbo.File_Types.Type_ID 
	 FROM dbo.Users, dbo.File_Types
     WHERE dbo.Users.User_Name = 'liambarkley';

SELECT TOP (1000) [User_ID] ,[Type_ID]
  FROM [dbo].[User_File_Types]
