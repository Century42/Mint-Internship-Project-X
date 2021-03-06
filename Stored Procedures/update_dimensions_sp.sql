/****** Object:  StoredProcedure [dbo].[UpdateDimensions]    Script Date: 7/11/2022 9:09:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
ALTER PROCEDURE [dbo].[UpdateDimensions]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
    /* Loading dimension tables   */
	DROP TABLE IF EXISTS #tempD, #tempF

	SELECT Disease_Name, D_Active AS Active
	INTO #tempD
	FROM dimInfo di
	WHERE di.Facility_Name IS NULL

	SELECT Facility_Name, Facility_Province, F_Active AS Active
	INTO #tempF
	FROM dimInfo di
	WHERE di.Disease_Name IS NULL

	-- Set any non-existing entity to inactive (name changed).
	/* Name changes will be infrequent, therefore duplication of results is justifiable */
	UPDATE dimDisease
	SET dimDisease.Active = 0
	FROM #tempD td
		RIGHT JOIN dimDisease dd
			ON dd.Disease_Name = td.Disease_Name
	WHERE td.Disease_Name IS NULL AND dd.Active = 1

	UPDATE dimFacilities
	SET dimFacilities.Active = 0
	FROM #tempF tf
		RIGHT JOIN dimFacilities df
			ON df.Facility_Name = tf.Facility_Name
	WHERE tf.Facility_Name IS NULL AND df.Active = 1

	-- Reactivate pre-existing entity (name changed back).
	/* If names ever get reverted back to old (inactive) identities, in order to prevent
		further duplication of existing records we must reactivate the old ones */
	UPDATE dimDisease
	SET dimDisease.Active = 1
	FROM #tempD td
		LEFT JOIN dimDisease dd
			ON td.Disease_Name = dd.Disease_Name
	WHERE dd.Active = 0

	UPDATE dimFacilities
	SET dimFacilities.Active = 1
	FROM #tempF tf
		LEFT JOIN dimFacilities df
			ON tf.Facility_Name = df.Facility_Name
	WHERE df.Active = 0

	-- Insert unseen entity (brand new disease/facility).
	INSERT INTO [dbo].[dimDisease]
			(Disease_Name, Active) 
	SELECT DISTINCT td.Disease_Name, 1
	FROM #tempD td
		LEFT JOIN dimDisease dd
			ON td.Disease_Name = dd.Disease_Name
	WHERE dd.Disease_ID IS NULL

	INSERT INTO [dbo].[dimFacilities]
			([Facility_Province], [Facility_Name], [Active])
	SELECT DISTINCT tf.Facility_Province, tf.Facility_Name, 1
	FROM #tempF tf
		LEFT JOIN dimFacilities df
			ON tf.Facility_Name = df.Facility_Name
	WHERE df.Facility_ID IS NULL

	-- Deactivate deleted entity (Active type set to inactive).
	UPDATE dimDisease
	SET dimDisease.Active = 0
	FROM #tempD td
		RIGHT JOIN dimDisease dd
			ON dd.Disease_Name = td.Disease_Name
	WHERE td.Active = 0 AND dd.Active = 1

	UPDATE dimFacilities
	SET dimFacilities.Active = 0
	FROM #tempF tf
		RIGHT JOIN dimFacilities df
			ON df.Facility_Name = tf.Facility_Name
	WHERE tf.Active = 0 AND df.Active = 1
	END
