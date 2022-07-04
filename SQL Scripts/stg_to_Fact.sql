-- get date of last file added
DECLARE @lastDate datetime = 
(SELECT MAX(Date) AS 'Max' FROM (SELECT Files.File_ID AS ID, Files.Insert_Date AS Date
FROM stg_HIV
INNER JOIN Files ON stg_HIV.File_ID = Files.File_ID GROUP BY Files.File_ID, Insert_Date) s)

-- get File_ID of last file added
DECLARE @lastFileID int = (SELECT File_ID FROM Files WHERE Insert_Date = @lastDate)
/****** Need to change so that it gets the IDs of the latest file for each week ******/
TRUNCATE TABLE FACTS

-- Load diseases not yet in dimDisease
INSERT INTO [dbo].[dimDisease]
		(Disease_Name) 
SELECT DISTINCT(ft.Disease_Name) FROM File_Types ft
LEFT JOIN dimDisease dd
ON ft.Disease_Name = dd.Disease_Name
WHERE dd.Disease_ID IS NULL

--insert from hiv staging table
	INSERT INTO [dbo].[Facts]
           ([Data_Element]
           ,[Data_Element_Value],
		   [DateKey], [Disease_ID])
	SELECT stgTemp.Data_Element, stgTemp.Data_Element_Value, stgTemp.DateKey, stgTemp.Disease_ID
	FROM (SELECT hiv.Data_Element, hiv.Data_Element_Value, dd.DateKey, ds.Disease_ID, Insert_Date
		FROM stg_HIV hiv 
		INNER JOIN Files f 
			ON hiv.File_ID = f.File_ID 
		INNER JOIN Weeks w 
			ON f.Week_ID = w.Week_ID  
		INNER JOIN DimDate dd
			ON dd.WeekOfYear = w.Week
			AND dd.Year = w.Year
			AND dd.DateKey = (SELECT Max(DateKey) FROM DimDate dSub WHERE dSub.WeekOfYear = w.Week AND dSub.Year = w.Year) -- return max day of week
		INNER JOIN (
			SELECT Week_ID, MAX(f.Insert_Date) maxdate
			FROM stg_HIV hiv
				INNER JOIN Files f
					ON hiv.File_ID = f.File_ID
			GROUP BY Week_ID
		) maxdatetbl
		ON f.Insert_Date = maxdatetbl.maxdate
		INNER JOIN File_Types ft
			ON ft.Type_ID = f.Type_ID
		INNER JOIN dimDisease ds
			ON ds.Disease_Name = ft.Disease_Name
		) stgTemp
	LEFT JOIN Facts 
	ON stgTemp.DateKey = Facts.DateKey 
	WHERE Facts.DateKey IS NULL


	WHERE
		Insert_Date = (
		SELECT MAX(fLast.Insert_Date)
		FROM Files fLast
		INNER JOIN Weeks ON w.Week_ID = fLast.Week_ID
		)

SELECT hiv.Data_Element, hiv.Data_Element_Value, DateKey, f.Insert_Date
	FROM stg_HIV hiv
		INNER JOIN Files f 
			ON hiv.File_ID = f.File_ID 
		INNER JOIN Weeks w 
			ON f.Week_ID = w.Week_ID  
		INNER JOIN DimDate dd
			ON dd.WeekOfYear = w.Week
			AND dd.Year = w.Year
			AND dd.DateKey = (SELECT Max(DateKey) FROM DimDate dSub WHERE dSub.WeekOfYear = w.Week AND dSub.Year = w.Year) -- return max day of week

		

SELECT Week, Max(Insert_Date)
FROM Files f 
	INNER JOIN Weeks w
	ON w.Week_ID = f.Week_ID
GROUP BY Week
		
/****** Need to change so that script can work for a general staging table ******/

-- get date of last file added
SET @lastDate = 
(SELECT MAX(Date) AS 'Max' FROM (SELECT Files.File_ID AS ID, Files.Insert_Date AS Date
FROM stg_TB
INNER JOIN Files ON stg_TB.File_ID = Files.File_ID GROUP BY Files.File_ID, Insert_Date) s)

-- get File_ID of last file added
SET @lastFileID = (SELECT File_ID FROM Files WHERE Insert_Date = @lastDate)

--insert from tb staging table
	INSERT INTO [dbo].[Facts]
           ([Data_Element]
           ,[Data_Element_Value],
		   [DateKey])
	SELECT Data_Element, Data_Element_Value, DateKey
	FROM DimDate, stg_TB
		INNER JOIN Files ON stg_TB.File_ID = Files.File_ID 
		INNER JOIN Weeks ON Files.Week_ID = Weeks.Week_ID WHERE Files.File_ID = @lastFileID 
			-- get DateKey from dimDate
			AND WeekOfYear = (SELECT Week From Weeks WHERE 
					Week_ID = (SELECT Week_ID FROM Files WHERE File_ID = stg_TB.File_ID))