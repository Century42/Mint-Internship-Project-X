INSERT INTO [dbo].[dimFacilities]
		([Facility_Province])
SELECT DISTINCT
	f.Facility_Province
FROM Facilities f
	LEFT JOIN dimFacilities d
		ON d.Facility_Province = f.Facility_Province
	WHERE d.Facility_ID IS NULL


		


