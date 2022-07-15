# Introduction 
A collection of stored procedures and SQL scripts made and used during my internship at Mint Group.

# Getting Started
This is just a collection of scripts used to populate the OLTP database. To run, execute the "DB Generation.sql" script within SSMS, as well as the other Initial Population Scripts. Then, to import a file, use the SSMS import tool to import it to the Temp table. Files have to be csv in the format "Cases" OR "Deaths" OR "Treated","value". Copying to the OLAP database is within an Azure Data Factory pipeline and thus cannot be accessed.
