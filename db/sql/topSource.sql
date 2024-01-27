WITH SensorSIPCounts AS (
  SELECT sensorName, sip, COUNT(sip) AS sip_count
  FROM webHoneyPot
  GROUP BY sensorName, sip
  ORDER BY sensorName, sip_count DESC
)
SELECT sensorName AS Sensor, sip AS "Top Source IP", sip_count AS Count
FROM (
  SELECT sensorName, sip, sip_count,
         ROW_NUMBER() OVER (PARTITION BY sensorName ORDER BY sip_count DESC) AS row_num
  FROM SensorSIPCounts
) ranked
WHERE row_num <= 5;
