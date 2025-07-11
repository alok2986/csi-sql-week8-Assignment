# csi-sql-week8-Assignment
# Time Dimension Stored Procedure

## Description
This project contains a SQL Server script to create a `TimeDimension` table and a stored procedure `PopulateTimeDimension` that populates date attributes for all days in a given year.

## How it works
- Input: Any date inside the year you want to generate.
- Output: Inserts one row per day for the entire year.

## How to run
1. Open SQL Server Management Studio (SSMS).
2. Copy the contents of `PopulateTimeDimension.sql` and execute it.
3. Run the stored procedure:
```sql
EXEC PopulateTimeDimension '2020-07-14';
