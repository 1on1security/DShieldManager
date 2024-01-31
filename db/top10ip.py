#!/usr/bin/env python3

import sqlite3

# Connect to the database
conn = sqlite3.connect('/data/dshieldManager/db/webhoneypot.db3')
cursor = conn.cursor()

# Query to fetch the top SIP
top_sip_query = """
SELECT sip
FROM (
    SELECT sip, COUNT(*) AS sip_count
    FROM webHoneyPot
    GROUP BY sip
    ORDER BY sip_count DESC
    LIMIT 1
)
"""

# Execute the query to find the top SIP
cursor.execute(top_sip_query)
top_sip = cursor.fetchone()[0]

# Query to fetch the data, excluding the top SIP
query = f"""
WITH SensorSIPCounts AS (
    SELECT sensorName, sip, COUNT(sip) AS sip_count
    FROM webHoneyPot
    WHERE sip != ?
    GROUP BY sensorName, sip
    ORDER BY sensorName, sip_count DESC
)
SELECT sensorName AS Sensor, sip AS "Top Source IP", sip_count AS "Count"
FROM (
    SELECT sensorName, sip, sip_count,
            ROW_NUMBER() OVER (PARTITION BY sensorName ORDER BY sip_count DESC) AS row_num
    FROM SensorSIPCounts
) ranked
WHERE row_num <= 5
"""

# Execute the query
cursor.execute(query, (top_sip,))

# Fetch the results
results = cursor.fetchall()

# Close the connection
conn.close()

# Split the results into three lists, one for each column
num_sensors = len(results)
num_per_column = (num_sensors + 2) // 3  # Ceiling division to ensure all columns are balanced
columns = [results[i:i + num_per_column] for i in range(0, num_sensors, num_per_column)]

# Create HTML table with alternating row colors for each column
html_table = "<table border='1'>"

for column in columns:
    html_table += "<td style='vertical-align: top;'>"
    html_table += "<table border='1'>"
    html_table += "<tr><th>Sensor</th><th>Top Source IP</th><th>Count</th></tr>"
    for i, result in enumerate(column):
        if i % 2 == 0:
            html_table += "<tr class='even'>"
        else:
            html_table += "<tr class='odd'>"
        for item in result:
            html_table += "<td>{}</td>".format(item)
        html_table += "</tr>"
    html_table += "</table>"
    html_table += "</td>"

html_table += "</table>"

# Style the alternating row colors with CSS
html_table += """
<style>
tr.even { background-color: #FFFFFF; }
tr.odd { background-color: #9FC5F5; }
</style>
"""

# Save the HTML table to /var/www/html directory
file_path = "/var/www/html/top_ips_table.html"
with open(file_path, "w") as file:
    file.write(html_table)

print(f"HTML table saved as '{file_path}'")
