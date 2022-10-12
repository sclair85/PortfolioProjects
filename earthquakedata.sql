SELECT date, time, Latitude, Longitude, Depth, Type, Magnitude, [Magnitude Type]
FROM SignificantEarthquakes..significant_Earthquakes$

-- All disturbances not labeled as an Earthquake
SELECT date, time, Latitude, Longitude, Depth, Type, Magnitude, [Magnitude Type]
FROM SignificantEarthquakes..significant_Earthquakes$
WHERE type != 'Earthquake'

-- All disturbances between 2006 - 2016
SELECT date, time, Latitude, Longitude, Depth, Magnitude, [Magnitude Type]
FROM SignificantEarthquakes..significant_Earthquakes$
WHERE date BETWEEN '2006-01-01' AND '2016-12-30'
ORDER BY date DESC

-- Average Depth
SELECT date, AVG(Depth) AS average_depth
FROM SignificantEarthquakes..significant_Earthquakes$
WHERE date BETWEEN '2006-01-01' AND '2016-12-30'
GROUP BY date
ORDER BY date

-- Significant Earthquakes In North America
SELECT date, time, Latitude, Longitude, Depth, Magnitude, [Magnitude Type]
FROM SignificantEarthquakes..significant_Earthquakes$
WHERE Latitude BETWEEN 5.000 AND 65.000
AND Longitude BETWEEN -180.000 AND -35.000 
AND type = 'Earthquake'
AND date BETWEEN '2006-01-01' AND '2016-12-30'

-- Total Earthquakes
SELECT COUNT(*) AS total_all, SUM((CASE WHEN Type = 'Earthquake' THEN 1 ELSE 0 END)) AS total_eq,
SUM((CASE WHEN Type != 'Earthquake' THEN 1 ELSE 0 END)) AS total_other
FROM SignificantEarthquakes..significant_Earthquakes$

-- Percentage of Earthquake and Non-earthquake Disturbances
SELECT COUNT(*) AS total_all, 
SUM((CASE WHEN Type = 'Earthquake' THEN 1 ELSE 0 END) * 1.0) / COUNT(*) AS total_eq,
SUM((CASE WHEN Type != 'Earthquake' THEN 1 ELSE 0 END) * 1.0) / COUNT(*) AS total_other
FROM SignificantEarthquakes..significant_Earthquakes$