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

# Create HTML table with alternating row colors for each sensor
html_table = "<table border='1' style='font-family: Verdana;'>"

sensor_colors = {}  # Dictionary to store colors for each sensor
alternate_colors = ['#0066cc', '#809fff']  # Alternating colors
color_index = 0  # Index to alternate colors

# Add the rows to the corresponding sensor in the sensor_rows dictionary
for column in columns:
    for result in column:
        sensor = result[0]  # Extract sensor name from the result
        if sensor and sensor not in sensor_colors:  # Ensure sensor name is not empty
            # Assign alternating color to each new sensor
            sensor_colors[sensor] = alternate_colors[color_index % len(alternate_colors)]
            color_index += 1

# Create a list of rows for each sensor
sensor_rows = {sensor: [] for sensor in sensor_colors}

# Add the rows to the corresponding sensor in the sensor_rows dictionary
for column in columns:
    for result in column:
        sensor = result[0]  # Extract sensor name from the result
        sensor_rows[sensor].append(result)

# Calculate the number of sensors per column
sensors_per_column = 3

# Create the HTML table
for i in range(0, len(sensor_rows), sensors_per_column):
    html_table += "<tr>"
    for j in range(sensors_per_column):
        if i + j < len(sensor_rows):
            sensor = list(sensor_rows.keys())[i + j]
            sensor_color = sensor_colors.get(sensor, '')  # Get color for the sensor
            html_table += "<td style='vertical-align: top; background-color: {}; font-family: Verdana; padding: 10px; text-align: left;'>".format(sensor_color)
            html_table += "<table border='1' style='font-family: Verdana;'>"
            html_table += "<tr><th style='font-family: Verdana;'>Sensor</th><th style='font-family: Verdana;'>Top Source IP</th><th style='font-family: Verdana;'>Count</th></tr>"
            for result in sensor_rows[sensor]:
                sensor_name = result[0]  # Extract sensor name from the result
                ip_address = result[1]  # Extract IP address from the result
                count = result[2]  # Extract count from the result
                # Create URL with IP address as POST data and open in new window
                url = "http://mercury.1on1.lan/skrull.php"
                html_table += "<tr style='background-color: {}; font-family: Verdana;'>".format(sensor_color)
                html_table += "<td style='font-family: Verdana;'>{}</td>".format(sensor_name)
                # Link IP address to URL with POST data and open in new window
                html_table += "<td style='font-family: Verdana;'><form action='{}' method='post' target='_blank' rel='noopener noreferrer'><input type='hidden' name='ip_address' value='{}'><button type='submit'>{}</button></form></td>".format(url, ip_address, ip_address)
                html_table += "<td style='font-family: Verdana;'>{}</td>".format(count)
            html_table += "</table>"
            html_table += "</td>"
        else:
            html_table += "<td></td>"
    html_table += "</tr>"

html_table += "</table>"

# Save the HTML table to a file
file_path = "/var/www/html/top_ips_table.html"
with open(file_path, "w") as file:
    file.write(html_table)

print(f"HTML table saved as '{file_path}'")
