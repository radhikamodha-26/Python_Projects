CREATE DATABASE Job_Market_Analysis;
USE Job_Market_Analysis;

-- Fetching all records
SELECT * FROM ai_job_market_insights;

-- Count total records
SELECT COUNT(*) AS total_records FROM ai_job_market_insights;

-- Checking for Duplicates (Case-Insensitive)
SELECT LOWER(Job_Title) AS Job_Title, LOWER(Industry) AS Industry, LOWER(Location) AS Location, 
       COUNT(*) AS Duplicate_Count
FROM ai_job_market_insights
GROUP BY LOWER(Job_Title), LOWER(Industry), LOWER(Location)
HAVING COUNT(*) > 1;

-- Checking for Missing (NULL) Values
SELECT 
    SUM(CASE WHEN Job_Title IS NULL THEN 1 ELSE 0 END) AS Missing_Job_Title,
    SUM(CASE WHEN Industry IS NULL THEN 1 ELSE 0 END) AS Missing_Industry,
    SUM(CASE WHEN Salary_USD IS NULL THEN 1 ELSE 0 END) AS Missing_Salary,
    SUM(CASE WHEN Remote_Friendly IS NULL THEN 1 ELSE 0 END) AS Missing_Remote_Friendly
FROM ai_job_market_insights;

-- Removing Leading & Trailing Spaces
SET SQL_SAFE_UPDATES = 0;
UPDATE ai_job_market_insights
SET Job_Title = TRIM(Job_Title),
    Industry = TRIM(Industry),
    Location = TRIM(Location);
SET SQL_SAFE_UPDATES = 1;

-- Average Salary by Industry (Excluding NULL salaries)
SELECT Industry, ROUND(AVG(COALESCE(Salary_USD, 0)), 2) AS Avg_Salary
FROM ai_job_market_insights
WHERE Salary_USD IS NOT NULL
GROUP BY Industry
ORDER BY Avg_Salary DESC;

-- Top 10 High-Paying AI Jobs
SELECT Job_Title, Industry, Salary_USD
FROM ai_job_market_insights
WHERE Salary_USD IS NOT NULL
ORDER BY Salary_USD DESC
LIMIT 10;

-- Salary Range by Company Size (Avoiding NULL values)
SELECT Company_Size, 
       MIN(COALESCE(Salary_USD, 0)) AS Min_Salary, 
       MAX(COALESCE(Salary_USD, 0)) AS Max_Salary, 
       ROUND(AVG(COALESCE(Salary_USD, 0)), 2) AS Avg_Salary
FROM ai_job_market_insights
WHERE Salary_USD IS NOT NULL
GROUP BY Company_Size
ORDER BY Avg_Salary DESC;

-- AI Adoption Levels Across Industries
SELECT Industry, AI_Adoption_Level, COUNT(*) AS Count
FROM ai_job_market_insights
GROUP BY Industry, AI_Adoption_Level
ORDER BY Industry, AI_Adoption_Level;

-- Remote-Friendly Jobs vs. On-Site
SELECT Remote_Friendly, COUNT(*) AS Job_Count
FROM ai_job_market_insights
GROUP BY Remote_Friendly;

-- Automation Risk by Job Title
SELECT Job_Title, Automation_Risk, COUNT(*) AS Count
FROM ai_job_market_insights
GROUP BY Job_Title, Automation_Risk
ORDER BY Automation_Risk DESC;

-- High Automation Risk Jobs (Sorted by Salary)
SELECT Job_Title, Industry, Salary_USD
FROM ai_job_market_insights
WHERE Automation_Risk = 'High' AND Salary_USD IS NOT NULL
ORDER BY Salary_USD DESC;

-- Job Growth Projection Analysis
SELECT Job_Growth_Projection, COUNT(*) AS Job_Count
FROM ai_job_market_insights
GROUP BY Job_Growth_Projection;

-- Most In-Demand Skills (Avoiding NULL values)
SELECT Required_Skills, COUNT(*) AS Demand
FROM ai_job_market_insights
WHERE Required_Skills IS NOT NULL
GROUP BY Required_Skills
ORDER BY Demand DESC
LIMIT 10;

-- Top 10 Cities for AI Jobs
SELECT Location, COUNT(*) AS Job_Count
FROM ai_job_market_insights
WHERE Location IS NOT NULL
GROUP BY Location
ORDER BY Job_Count DESC
LIMIT 10;
