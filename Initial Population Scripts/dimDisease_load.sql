-- Load diseases not yet in dimDisease
INSERT INTO [dbo].[dimDisease]
		(Disease_Name) 
SELECT DISTINCT(ft.Disease_Name) FROM File_Types ft
LEFT JOIN dimDisease dd
ON ft.Disease_Name = dd.Disease_Name
WHERE dd.Disease_ID IS NULL