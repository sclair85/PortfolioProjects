-- McDonalds broken Ice Cream Machine Data As Of 9-20-2022

-- All data
SELECT * FROM mcdonalds_dataset

-- Broken Icecream Machines for each country **skip visualization**
SELECT SUM(CASE WHEN country = 'UK' THEN 1 END) AS UK,
SUM(CASE WHEN country = 'USA' THEN 1 END) AS USA,
SUM(CASE WHEN country = 'CA' THEN 1 END) AS Canada,
SUM(CASE WHEN country = 'DE' THEN 1 END) AS Germany
FROM mcdonalds_dataset
WHERE is_broken = 'True'

-- All broken machines 
SELECT * FROM mcdonalds_dataset
WHERE is_broken = 'True'

-- All working machines
SELECT * FROM mcdonalds_dataset
WHERE is_broken = 'False'

--Active Machines from major cities
SELECT is_broken AS Broken, (CASE WHEN is_broken = 'False' THEN 1 ELSE 0 END) AS Working,
state, city, country
FROM mcdonalds_dataset
--WHERE is_active = 'True'
--AND city IN ('New York', 'Washington', 'Winnipeg', 'Ottawa', 'Berlin', 'Hannover', 'London', 'Glasgolw')
WHERE city IN ('New York', 'Washington') AND state IN ('NY', 'DC') AND country = 'USA' AND city 
NOT IN ('Manchester', 'Glasgow')
OR city IN ('Manchester', 'Glasgow', 'Edinburgh') AND country = 'UK' 
OR city IN ('Winnipeg', 'Ottawa') AND country = 'CA' 
OR city IN ('Berlin', 'Hannover') AND country = 'DE' 

-- Percentage of working/broken machines by major city
SELECT city, SUM(CAST(is_broken AS INT) * .01) / COUNT(*) * 100 AS brokenPercentage,
SUM((CASE WHEN is_broken = 'False' THEN 1 ELSE 0 END) * .01) / COUNT(*) * 100 AS workingPercentage
FROM mcdonalds_dataset
WHERE city IN ('New York', 'Washington') AND state IN ('NY', 'DC') AND country = 'USA' AND city 
NOT IN ('Manchester', 'Glasgow')
OR city IN ('Manchester', 'Glasgow', 'Edinburgh') AND country = 'UK' 
OR city IN ('Winnipeg', 'Ottawa') AND country = 'CA' 
OR city IN ('Berlin', 'Hannover') AND country = 'DE' 
GROUP BY city

-- Total percentage of broken machines
SELECT SUM(CAST(is_broken AS INT) * .01) / COUNT(*) * 100 AS brokenPercentage
FROM mcdonalds_dataset

SELECT * FROM mcdonalds_dataset
WHERE country = 'UK'
AND city IN ('Liverpool', 'Manchester') 

-- All Machines In USA
SELECT * FROM mcdonalds_dataset
WHERE country = 'USA'

-- All broken machines in USA
SELECT * FROM mcdonalds_dataset
WHERE country = 'USA'
AND is_broken = 'True'



