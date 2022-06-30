TRUNCATE TABLE dbo.Facts;

-- get date of last file added
DECLARE @lastDate datetime = 
(SELECT MAX(Date) AS 'Max' FROM (SELECT Files.File_ID AS ID, Files.Insert_Date AS Date
FROM stg_HIV
INNER JOIN Files ON stg_HIV.File_ID = Files.File_ID GROUP BY Files.File_ID, Insert_Date) s)

-- get File_ID of last file added
DECLARE @lastFileID int = (SELECT File_ID FROM Files WHERE Insert_Date = @lastDate)
/****** Need to change so that it gets the IDs of the latest file for each week ******/

--insert from hiv staging table
	INSERT INTO [dbo].[Facts]
           ([Data_Element]
           ,[Data_Element_Value],
		   [DateKey])
	SELECT Data_Element, Data_Element_Value, DateKey
	FROM DimDate, stg_HIV
		INNER JOIN Files ON stg_HIV.File_ID = Files.File_ID 
		INNER JOIN Weeks ON Files.Week_ID = Weeks.Week_ID WHERE Files.File_ID = @lastFileID 
			-- get DateKey from dimDate
			AND WeekOfYear = (SELECT Week From Weeks WHERE 
					Week_ID = (SELECT Week_ID FROM Files WHERE File_ID = stg_HIV.File_ID))
/****** Need to change so that script can work for a general staging table ******/