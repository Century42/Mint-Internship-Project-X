DROP TABLE [dbo].[dimFacilities];
CREATE TABLE [dbo].[dimFacilities]
	(	[Facility_ID] INT IDENTITY(1,1) primary key, 
		[Facility_Province] VARCHAR(50)
	)
GO