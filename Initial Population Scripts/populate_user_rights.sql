DELETE FROM dbo.User_File_Types 
 
INSERT INTO dbo.User_File_Types
     (User_ID, Type_ID)
     SELECT dbo.Users.User_ID, dbo.File_Types.Type_ID 
	 FROM dbo.Users, dbo.File_Types
     WHERE dbo.Users.User_Name IN ('matthewkeys','liambarkley')

SELECT TOP (10) [User_ID] ,[Type_ID]
  FROM [dbo].[User_File_Types]
