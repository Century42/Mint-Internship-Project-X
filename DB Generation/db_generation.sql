/****** Object:  Database [project-x]    Script Date: 2022/06/29 11:00:34 ******/
CREATE DATABASE [project-x]  (EDITION = 'Basic', SERVICE_OBJECTIVE = 'Basic', MAXSIZE = 2 GB) WITH CATALOG_COLLATION = SQL_Latin1_General_CP1_CI_AS, LEDGER = OFF;
GO
ALTER DATABASE [project-x] SET COMPATIBILITY_LEVEL = 150
GO
ALTER DATABASE [project-x] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [project-x] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [project-x] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [project-x] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [project-x] SET ARITHABORT OFF 
GO
ALTER DATABASE [project-x] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [project-x] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [project-x] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [project-x] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [project-x] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [project-x] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [project-x] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [project-x] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [project-x] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [project-x] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [project-x] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [project-x] SET  MULTI_USER 
GO
ALTER DATABASE [project-x] SET ENCRYPTION ON
GO
ALTER DATABASE [project-x] SET QUERY_STORE = ON
GO
ALTER DATABASE [project-x] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 7), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 10, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
/*** The scripts of database scoped configurations in Azure should be executed inside the target database connection. ***/
GO
-- ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
GO
/****** Object:  Table [dbo].[Facilities]    Script Date: 2022/06/29 11:00:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Facilities](
	[Facility_ID] [int] IDENTITY(1,1) NOT NULL,
	[Facility_Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Facilities] PRIMARY KEY CLUSTERED 
(
	[Facility_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[File_Logs]    Script Date: 2022/06/29 11:00:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[File_Logs](
	[Log_ID] [int] IDENTITY(1,1) NOT NULL,
	[File_ID] [int] NOT NULL,
	[Status] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_File_Logs] PRIMARY KEY CLUSTERED 
(
	[Log_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[File_Types]    Script Date: 2022/06/29 11:00:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[File_Types](
	[Type_ID] [int] IDENTITY(1,1) NOT NULL,
	[File_Type] [nvarchar](50) NOT NULL,
	[File_Desc] [nvarchar](50) NULL,
 CONSTRAINT [PK_File_Types] PRIMARY KEY CLUSTERED 
(
	[Type_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Files]    Script Date: 2022/06/29 11:00:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Files](
	[File_ID] [int] IDENTITY(1,1) NOT NULL,
	[Week_ID] [int] NOT NULL,
	[Facility_ID] [int] NOT NULL,
	[Type_ID] [int] NOT NULL,
	[User_ID] [int] NOT NULL,
	[Insert_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Files] PRIMARY KEY CLUSTERED 
(
	[File_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_HIV]    Script Date: 2022/06/29 11:00:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_HIV](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[File_ID] [int] NOT NULL,
	[Data_Element] [nvarchar](50) NULL,
	[Data_Element_Value] [int] NULL,
 CONSTRAINT [PK_stg_HIV] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_TB]    Script Date: 2022/06/29 11:00:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_TB](
	[ID] [int] NOT NULL,
	[File_ID] [int] NOT NULL,
	[Data_Element] [nvarchar](50) NULL,
	[Data_Element_Value] [int] NULL,
 CONSTRAINT [PK_stg_TB] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_File_Types]    Script Date: 2022/06/29 11:00:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_File_Types](
	[User_ID] [int] NOT NULL,
	[Type_ID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 2022/06/29 11:00:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[User_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_Name] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[Display_Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[User_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Weeks]    Script Date: 2022/06/29 11:00:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Weeks](
	[Week_ID] [int] IDENTITY(1,1) NOT NULL,
	[Year] [int] NOT NULL,
	[Week] [int] NOT NULL,
 CONSTRAINT [PK_Weeks] PRIMARY KEY CLUSTERED 
(
	[Week_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[File_Logs]  WITH CHECK ADD  CONSTRAINT [FK_File_Logs_Files] FOREIGN KEY([File_ID])
REFERENCES [dbo].[Files] ([File_ID])
GO
ALTER TABLE [dbo].[File_Logs] CHECK CONSTRAINT [FK_File_Logs_Files]
GO
ALTER TABLE [dbo].[Files]  WITH CHECK ADD  CONSTRAINT [FK_Files_Facilities] FOREIGN KEY([Facility_ID])
REFERENCES [dbo].[Facilities] ([Facility_ID])
GO
ALTER TABLE [dbo].[Files] CHECK CONSTRAINT [FK_Files_Facilities]
GO
ALTER TABLE [dbo].[Files]  WITH CHECK ADD  CONSTRAINT [FK_Files_File_Types] FOREIGN KEY([Type_ID])
REFERENCES [dbo].[File_Types] ([Type_ID])
GO
ALTER TABLE [dbo].[Files] CHECK CONSTRAINT [FK_Files_File_Types]
GO
ALTER TABLE [dbo].[Files]  WITH CHECK ADD  CONSTRAINT [FK_Files_Users] FOREIGN KEY([User_ID])
REFERENCES [dbo].[Users] ([User_ID])
GO
ALTER TABLE [dbo].[Files] CHECK CONSTRAINT [FK_Files_Users]
GO
ALTER TABLE [dbo].[Files]  WITH CHECK ADD  CONSTRAINT [FK_Files_Weeks] FOREIGN KEY([Week_ID])
REFERENCES [dbo].[Weeks] ([Week_ID])
GO
ALTER TABLE [dbo].[Files] CHECK CONSTRAINT [FK_Files_Weeks]
GO
ALTER TABLE [dbo].[stg_HIV]  WITH CHECK ADD  CONSTRAINT [FK_stg_HIV_Files] FOREIGN KEY([File_ID])
REFERENCES [dbo].[Files] ([File_ID])
GO
ALTER TABLE [dbo].[stg_HIV] CHECK CONSTRAINT [FK_stg_HIV_Files]
GO
ALTER TABLE [dbo].[stg_TB]  WITH CHECK ADD  CONSTRAINT [FK_stg_TB_Files] FOREIGN KEY([File_ID])
REFERENCES [dbo].[Files] ([File_ID])
GO
ALTER TABLE [dbo].[stg_TB] CHECK CONSTRAINT [FK_stg_TB_Files]
GO
ALTER TABLE [dbo].[User_File_Types]  WITH CHECK ADD  CONSTRAINT [FK_User_File_Types_File_Types] FOREIGN KEY([Type_ID])
REFERENCES [dbo].[File_Types] ([Type_ID])
GO
ALTER TABLE [dbo].[User_File_Types] CHECK CONSTRAINT [FK_User_File_Types_File_Types]
GO
ALTER TABLE [dbo].[User_File_Types]  WITH CHECK ADD  CONSTRAINT [FK_User_File_Types_Users] FOREIGN KEY([User_ID])
REFERENCES [dbo].[Users] ([User_ID])
GO
ALTER TABLE [dbo].[User_File_Types] CHECK CONSTRAINT [FK_User_File_Types_Users]
GO
/****** Object:  StoredProcedure [dbo].[MySP]    Script Date: 2022/06/29 11:00:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[MySP]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
	SELECT *
	FROM
	[dbo].[File_Types]

END
GO
ALTER DATABASE [project-x] SET  READ_WRITE 
GO
