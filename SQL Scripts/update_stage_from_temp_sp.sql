/****** Object:  StoredProcedure [dbo].[StageFromTemp]    Script Date: 7/1/2022 9:48:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
ALTER PROCEDURE [dbo].[StageFromTemp] @Facility_Name nvarchar(50), @File_Type nvarchar(50), @User_Name nvarchar(50)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
    -- Insert statements for procedure here
	DECLARE @id int;
	DECLARE @filetype nvarchar(50);
	DECLARE @errors bit = 0;
	DECLARE @errormsg nvarchar(100);

	EXEC dbo.AddFileMeta
		@Facility_Name = @Facility_Name, --This can be changed to take input from front-end at a later stage
		@File_Type = @File_Type,
		@User_Name = @User_Name;

	SELECT @id =  IDENT_CURRENT('[dbo].[Files]');

	--User should upload csv file into temp table

	--Check if user has rights to upload this type of file
	IF ((SELECT COUNT(Type_ID) FROM dbo.User_File_Types
		WHERE User_ID =	(SELECT User_ID FROM dbo.Users WHERE User_Name = @User_Name)
		AND Type_ID = (SELECT Type_ID FROM dbo.File_Types WHERE File_Type = @File_Type)) = 0)
	BEGIN
		SET @errors = 1; --there are errors
		SET @errormsg = 'User ' + (SELECT Display_Name FROM dbo.Users WHERE User_Name = @User_Name)
						+ ' does not have rights to insert this kind of file';
	END
	
	--Check if facility exists
	IF ((SELECT COUNT(Facility_ID) FROM Facilities
		WHERE Facility_Name = @Facility_Name AND Active = 1) = 0) 
	BEGIN	
		SET @errors = 1;
		SET @errormsg = 'Facility not found'
	END
	--Check if disease/file type exists
	IF ((SELECT COUNT(Type_ID) FROM File_Types
		WHERE File_Type = @File_Type AND Active = 1) = 0) 
	BEGIN	
		SET @errors = 1;
		SET @errormsg = 'File type not found'
	END

	IF (@errors = 0)
	BEGIN
		IF (@File_Type = 'hiv_csv') 
		BEGIN
			--insert into hiv staging table
			INSERT INTO [dbo].[stg_HIV]
				   ([File_ID]
				   ,[Data_Element]
				   ,[Data_Element_Value])
			 SELECT
				   @id,
				   Data_Element,
				   Data_Element_Value
			FROM dbo.Temp
		END
		ELSE IF (@File_Type = 'tb_csv')
		BEGIN
			--insert into tb staging table
			INSERT INTO [dbo].[stg_TB]
				   ([File_ID]
				   ,[Data_Element]
				   ,[Data_Element_Value])
			 SELECT
				   @id,
				   Data_Element,
				   Data_Element_Value
			FROM dbo.Temp
		END
		
		INSERT INTO [dbo].[File_Logs]
           ([File_ID]
           ,[Status]
           ,[Description])
		VALUES
           (@id
           ,'Successful'
           ,NULL)
	END
	ELSE
	BEGIN
		EXEC dbo.AddFileLog
			@File_ID = @id,
			@Status = 'Failed',
			@Description = @errormsg
	END

	TRUNCATE TABLE dbo.Temp;
END
