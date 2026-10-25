CREATE DATABASE kickstarter_db;
USE kickstarter_db;

CREATE TABLE campaigns (
    campaign_id INT AUTO_INCREMENT PRIMARY KEY,  -- unique surrogate key
    ID INT,                                      -- original dataset ID (may repeat)
    Name VARCHAR(500),
    Category VARCHAR(100),
    Subcategory VARCHAR(100),
    Country VARCHAR(50),
    Launched DATE,
    Deadline DATE,
    Goal INT,
    Pledged INT,
    Backers INT,
    State VARCHAR(50)
);
SELECT COUNT(*) FROM campaigns;


#Find the number of campaigns grouped by category and country.
SELECT COUNT(ID) AS total_campaigns,
       Category,
       Country
FROM campaigns
GROUP BY Country, Category;

#Calculate the success rate of campaigns for each country.
SELECT Country,
       100.0 * SUM(Goal)/SUM(Pledged)
FROM campaigns
GROUP BY Country;

#Compare the average funding goal versus the average pledged amount by category.
SELECT Category,
       AVG(Goal) AS avg_goal,
       AVG(Pledged) AS avg_pledged
FROM campaigns
GROUP BY Category;

#Analyze how many campaigns were launched per month and year.
SELECT COUNT(*),
       EXTRACT(YEAR FROM Launched) AS year,
       EXTRACT(MONTH FROM Launched) AS month
FROM campaigns
GROUP BY year, month;

#Identify the top 20 campaigns with the highest pledged amounts.
SELECT ID,
       MAX(Pledged) AS highest_pledged
FROM campaigns
GROUP BY ID
ORDER BY highest_pledged DESC
LIMIT 20;

#Calculate the average duration of successful campaigns compared to failed ones.
WITH SuccessfulCampaignDuration AS(
	 SELECT 
     TIMESTAMPDIFF(DAY, Launched, Deadline) AS SuccessfulCampaignDays
FROM campaigns
WHERE State = 'Successful'
),
FailedCampaignDuration AS(
SELECT TIMESTAMPDIFF(DAY, Launched, Deadline) AS FailedCampaignDays
FROM campaigns
WHERE State = 'Failed'
)
SELECT AVG(SuccessfulCampaignDays) AS avg_successful
FROM SuccessfulCampaignDuration
UNION
SELECT AVG(FailedCampaignDays) AS avg_failed
FROM FailedCampaignDuration;

