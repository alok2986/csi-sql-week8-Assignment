-- STEP 1: Create the table
CREATE TABLE dbo.TimeDimension (
    SKDate INT PRIMARY KEY,
    KeyDate DATE,
    [Date] DATE,
    CalendarDay INT,
    CalendarMonth INT,
    CalendarQuarter INT,
    CalendarYear INT,
    DayNameLong VARCHAR(20),
    DayNameShort VARCHAR(5),
    DayNumberOfWeek INT,
    DayNumberOfYear INT,
    DaySuffix VARCHAR(5)
);
GO

-- STEP 2: Create the stored procedure
CREATE PROCEDURE dbo.PopulateTimeDimension
    @InputDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartDate DATE = DATEFROMPARTS(YEAR(@InputDate), 1, 1);
    DECLARE @EndDate DATE = DATEFROMPARTS(YEAR(@InputDate), 12, 31);

    INSERT INTO dbo.TimeDimension
    (
        SKDate, KeyDate, [Date],
        CalendarDay, CalendarMonth, CalendarQuarter, CalendarYear,
        DayNameLong, DayNameShort,
        DayNumberOfWeek, DayNumberOfYear, DaySuffix
    )
    SELECT
        CONVERT(INT, FORMAT(CurrentDate, 'yyyyMMdd')) AS SKDate,
        CurrentDate AS KeyDate,
        CurrentDate AS [Date],
        DAY(CurrentDate),
        MONTH(CurrentDate),
        DATEPART(QUARTER, CurrentDate),
        YEAR(CurrentDate),
        DATENAME(WEEKDAY, CurrentDate),
        LEFT(DATENAME(WEEKDAY, CurrentDate), 3),
        DATEPART(WEEKDAY, CurrentDate),
        DATEPART(DAYOFYEAR, CurrentDate),
        FORMAT(DAY(CurrentDate), '0') +
            CASE 
                WHEN DAY(CurrentDate) IN (11,12,13) THEN 'th'
                WHEN RIGHT(CAST(DAY(CurrentDate) AS VARCHAR(2)),1) = '1' THEN 'st'
                WHEN RIGHT(CAST(DAY(CurrentDate) AS VARCHAR(2)),1) = '2' THEN 'nd'
                WHEN RIGHT(CAST(DAY(CurrentDate) AS VARCHAR(2)),1) = '3' THEN 'rd'
                ELSE 'th'
            END
    FROM (
        SELECT DATEADD(DAY, Number, @StartDate) AS CurrentDate
        FROM (
            SELECT TOP (DATEDIFF(DAY, @StartDate, @EndDate) + 1)
                ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS Number
            FROM sys.all_objects
        ) AS Numbers
    ) AS Dates;
END
GO
