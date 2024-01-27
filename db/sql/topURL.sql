WITH SensorURLCounts AS (
  SELECT sensorName, url, COUNT(url) AS url_count
  FROM webHoneyPot
  GROUP BY sensorName, url
  ORDER BY sensorName, url_count DESC
)
SELECT sensorName AS Sensor, url AS "Top URL", url_count AS Count
FROM (
  SELECT sensorName, url, url_count,
         ROW_NUMBER() OVER (PARTITION BY sensorName ORDER BY url_count DESC) AS row_num
  FROM SensorURLCounts
) ranked
WHERE row_num <= 5;
