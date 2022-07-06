/* Loading dimension tables   */

-- Set any non-existing entity to inactive (name changed).
UPDATE dimDisease
SET dimDisease.Active = 0
FROM File_Types ft
	RIGHT JOIN dimDisease dd
		ON dd.Disease_Name = ft.Disease_Name
WHERE ft.Type_ID IS NULL AND dd.Active = 1

UPDATE dimFacilities
SET dimFacilities.Active = 0
FROM Facilities f
	RIGHT JOIN dimFacilities d
		ON d.Facility_Name = f.Facility_Name
WHERE f.Facility_ID IS NULL AND d.Active = 1 

-- Reactivate pre-existing entity (name changed back).
UPDATE dimDisease
SET dimDisease.Active = 1
FROM File_Types ft
	LEFT JOIN dimDisease dd
		ON ft.Disease_Name = dd.Disease_Name
WHERE dd.Active = 0

UPDATE dimFacilities
SET dimFacilities.Active = 1
FROM Facilities f
	LEFT JOIN dimFacilities df
		ON df.Facility_Name = f.Facility_Name
WHERE df.Active = 0

-- Insert unseen entity (brand new disease/facility).
INSERT INTO [dbo].[dimDisease]
		(Disease_Name, Active) 
SELECT DISTINCT ft.Disease_Name, 1
FROM File_Types ft
	LEFT JOIN dimDisease dd
		ON ft.Disease_Name = dd.Disease_Name
WHERE dd.Disease_ID IS NULL

INSERT INTO [dbo].[dimFacilities]
		([Facility_Province], [Facility_Name], [Active])
SELECT DISTINCT f.Facility_Province, f.Facility_Name, 1
FROM Facilities f
	LEFT JOIN dimFacilities d
		ON d.Facility_Name = f.Facility_Name
WHERE d.Facility_ID IS NULL

-- Deactivate deleted entity (Active type set to inactive).
UPDATE dimDisease
SET dimDisease.Active = 0
FROM File_Types ft
	RIGHT JOIN dimDisease dd
		ON dd.Disease_Name = ft.Disease_Name
WHERE ft.Active = 0 AND dd.Active = 1

UPDATE dimFacilities
SET dimFacilities.Active = 0
FROM Facilities f
	RIGHT JOIN dimFacilities df
		ON df.Facility_Name = f.Facility_Name
WHERE f.Active = 0 AND df.Active = 1

/* ETL: Write data from OLTP into OLAP  */

-- Set records associated to inactive dimensional identities to inactive.
UPDATE Facts
SET Active = 0
FROM Facts f
INNER JOIN dimDisease dd
	ON f.Disease_ID = dd.Disease_ID
INNER JOIN dimFacilities df
	ON f.Facility_ID = df.Facility_ID
WHERE (dd.Active = 0 OR df.Active = 0) AND f.Active = 1

-- Create temp table to store info from all staging tables.
SELECT * 
INTO #temp 
FROM stg_HIV
UNION
SELECT * FROM stg_TB

-- Generate temporary query table that stores all information needed for insert into Facts table.
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
		AND (md.Facility_ID = f.Facility_ID AND fa.Active = 1)
		AND (md.Type_ID = f.Type_ID AND ft.Active = 1)
WHERE ds.Active = 1 AND df.Active = 1

/* Update previously inactive records to active */
-- Find all Facility and Disease combinations that must be reactivated.
SELECT DISTINCT q.Facility_ID, q.Disease_ID
INTO #renew 
FROM #query q
LEFT JOIN Facts f
	ON  (f.Facility_ID = q.Facility_ID AND f.Disease_ID = q.Disease_ID)
WHERE f.Active = 0
-- Set records that were previously inactive to active again.
UPDATE Facts
SET Active = 1
FROM Facts f
INNER JOIN #renew r
	ON r.Facility_ID = f.Facility_ID AND r.Disease_ID = f.Disease_ID
-- Remove reactivated records.
DELETE #query
FROM #query q
RIGHT JOIN #renew r
	ON (q.Facility_ID = r.Facility_ID) AND (q.Disease_ID = r.Disease_ID)

/* Write all new data to Facts table */
INSERT INTO [dbo].[Facts]
           ([Data_Element],
           [Data_Element_Value],
		   [DateKey], [Disease_ID], [Facility_ID], [Active])
SELECT q.Data_Element, q.Data_Element_Value, q.DateKey, q.Disease_ID, q.Facility_ID, 1
FROM #query q
-- Join only files for week, type and facility not yet included.
	LEFT JOIN Facts 
		ON q.DateKey = Facts.DateKey 
		AND q.Facility_ID = Facts.Facility_ID
		AND q.Disease_ID = Facts.Disease_ID
WHERE (Facts.DateKey IS NULL
AND Facts.Facility_ID IS NULL
AND Facts.Disease_ID IS NULL)

DROP TABLE #temp
DROP TABLE #query
DROP TABLE #renew

-- RESET TABLES
/*TRUNCATE TABLE Facts
TRUNCATE TABLE dimFacilities
DELETE FROM dimDisease
DBCC CHECKIDENT('[dbo].[dimDisease]', RESEED, 0)

TRUNCATE TABLE stg_HIV
TRUNCATE TABLE stg_TB

TRUNCATE TABLE File_Logs
DELETE FROM Files
DBCC CHECKIDENT('[dbo].[Files]', RESEED, 0)
TRUNCATE TABLE Temp*/