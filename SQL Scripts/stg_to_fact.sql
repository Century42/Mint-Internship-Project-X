/* Loading dimension tables   */

-- Set any deleted diseases to inactive
UPDATE dimDisease
SET dimDisease.Active = 0
FROM File_Types ft
	RIGHT JOIN dimDisease dd
		ON dd.Disease_Name = ft.Disease_Name
WHERE ft.Type_ID IS NULL AND dd.Active = 1

-- Reactivate deleted diseases
UPDATE dimDisease
SET dimDisease.Active = 1
FROM File_Types ft
	LEFT JOIN dimDisease dd
		ON ft.Disease_Name = dd.Disease_Name
WHERE dd.Active = 0

-- Insert unseen diseases
INSERT INTO [dbo].[dimDisease]
		(Disease_Name) 
SELECT DISTINCT ft.Disease_Name 
FROM File_Types ft
	LEFT JOIN dimDisease dd
		ON ft.Disease_Name = dd.Disease_Name
WHERE dd.Disease_ID IS NULL

--Toggle off deleted facilities
UPDATE dimFacilities
SET Active = 0
FROM Facilities f
	RIGHT JOIN dimFacilities d
		ON d.Facility_Name = f.Facility_Name
WHERE d.Active = 1 AND f.Facility_ID IS NULL

--Toggle on returning facilities
UPDATE dimFacilities
SET Active = 1
FROM Facilities f
	INNER JOIN dimFacilities d
	ON d.Facility_Name = f.Facility_Name
WHERE Active = 0

-- Load facilities not yet in dimFacility
INSERT INTO [dbo].[dimFacilities]
		([Facility_Province])
SELECT DISTINCT f.Facility_Province
FROM Facilities f
	LEFT JOIN dimFacilities d
		ON d.Facility_Province = f.Facility_Province
WHERE d.Facility_ID IS NULL

/* ETL: Write data from OLTP into OLAP  */

-- Create temp table to store info from all staging tables
SELECT * 
INTO #temp 
FROM stg_HIV
UNION
SELECT * FROM stg_TB

SELECT t.Data_Element, t.Data_Element_Value, dd.DateKey, ds.Disease_ID, df.Facility_ID, Insert_Date
INTO #query
FROM #temp t 
	INNER JOIN Files f 
		ON t.File_ID = f.File_ID 
	INNER JOIN Weeks w 
		ON f.Week_ID = w.Week_ID  
	INNER JOIN DimDate dd
		ON dd.WeekOfYear = w.Week
		AND dd.Year = w.Year
		AND dd.DateKey = (SELECT Max(DateKey) FROM DimDate dSub WHERE dSub.WeekOfYear = w.Week AND dSub.Year = w.Year) -- return max day of week
	INNER JOIN File_Types ft
		ON ft.Type_ID = f.Type_ID
	INNER JOIN dimDisease ds
		ON ds.Disease_Name = ft.Disease_Name
	INNER JOIN Facilities fa
		ON f.Facility_ID = fa.Facility_ID
	INNER JOIN dimFacilities df
		ON fa.Facility_Province = df.Facility_Province
		-- Get latest file of week for every type and facility
	INNER JOIN (
		SELECT Week_ID, MAX(f.Insert_Date) maxdate, Type_ID, Facility_ID
		FROM #temp t
			INNER JOIN Files f
				ON t.File_ID = f.File_ID
		GROUP BY Week_ID, Type_ID, Facility_ID
		) md
		ON md.maxdate = f.Insert_Date
		AND md.Facility_ID = f.Facility_ID
		AND md.Type_ID = f.Type_ID

-- Write to Facts
INSERT INTO [dbo].[Facts]
           ([Data_Element],
           [Data_Element_Value],
		   [DateKey], [Disease_ID], [Facility_ID])

SELECT q.Data_Element, q.Data_Element_Value, q.DateKey, q.Disease_ID, q.Facility_ID
FROM #query q
-- Join only files for week, type and facility not yet included
	LEFT JOIN Facts 
		ON q.DateKey = Facts.DateKey 
		AND q.Facility_ID = Facts.Facility_ID
		AND q.Disease_ID = Facts.Disease_ID
WHERE Facts.DateKey IS NULL
AND Facts.Facility_ID IS NULL
AND Facts.Disease_ID IS NULL

DROP TABLE #temp
DROP TABLE #query