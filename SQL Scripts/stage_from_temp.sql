USE [project-x]
GO
DECLARE @id int;
DECLARE @filetype nvarchar(50);

EXEC dbo.AddFileMeta
	@Facility = 'KwaZulu-Natal', --This can be changed to take input from front-end at a later stage
	@File_Type = 'tb_csv',
	@User_Name = 'matthewkeys';

SELECT @id =  IDENT_CURRENT('[dbo].[Files]');

--User should upload csv file into staging
SELECT @filetype = File_Type FROM dbo.File_Types
WHERE Type_ID = (SELECT Type_ID FROM dbo.Files WHERE File_ID = @id)

IF (@filetype = 'hiv_csv') 
BEGIN
	--insert into hiv staging table
	INSERT INTO [dbo].[stg_HIV]
           ([File_ID]
           ,[Data_Element]
           ,[Data_Element_Value])
     VALUES
           (@id
           ,(SELECT Data_Element FROM dbo.Temp)
           ,(SELECT Data_Element_Value FROM dbo.Temp));
END

ELSE
BEGIN
	--insert into tb staging table
	INSERT INTO [dbo].[stg_TB]
           ([File_ID]
           ,[Data_Element]
           ,[Data_Element_Value])
     VALUES
           (@id
           ,(SELECT Data_Element FROM dbo.Temp)
           ,(SELECT Data_Element_Value FROM dbo.Temp));
END

TRUNCATE TABLE dbo.Temp;
GO


