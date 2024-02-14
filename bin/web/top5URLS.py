#!/usr/bin/env python3

import sqlite3

# Connect to the database
conn = sqlite3.connect('/data/dshieldManager/db/webhoneypot.db3')
cursor = conn.cursor()

# Query to fetch the top 5 URLs per sensor
query = """
WITH SensorURLCounts AS (
    SELECT sensorName, url, sip, COUNT(url) AS url_count
    FROM webHoneyPot
    GROUP BY sensorName, url
    ORDER BY sensorName, url_count DESC
)
SELECT sensorName AS Sensor, url AS "Top URL", sip AS "Source IP", url_count AS Count
FROM (
    SELECT sensorName, url, sip, url_count,
           ROW_NUMBER() OVER (PARTITION BY sensorName ORDER BY url_count DESC) AS row_num
    FROM SensorURLCounts
) ranked
WHERE row_num <= 5;
"""

# Execute the query
cursor.execute(query)

# Fetch the results
results = cursor.fetchall()

# Close the connection
conn.close()

# Split the results into three lists, one for each column
num_sensors = len(results)
num_per_column = (num_sensors + 2) // 3  # Ceiling division to ensure all columns are balanced
columns = [results[i:i + num_per_column] for i in range(0, num_sensors, num_per_column)]

# Create HTML table with alternating row colors for each sensor
html_table = "<!DOCTYPE html><html><head><title>Webhoneypot.json Top 5 URLs per Sensor</title><style>body {background: url('images/blueCamo.jpg') no-repeat center center fixed;background-size: cover;</style></head><body>"
html_table += "<h1 style='text-align: left; font-family: Verdana;color: white;'>Webhoneypot.json Top 5 URLs per Sensor</h1>"
html_table += "<table border='1' style='font-family: Verdana; border-collapse: collapse; width: 80%;'>"

sensor_colors = {}  # Dictionary to store colors for each sensor
alternate_colors = ['#5c85d6', '#9999ff']  # Alternating colors
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
sensors_per_column = 1

# Create the HTML table
for i in range(0, len(sensor_rows), sensors_per_column):
    html_table += "<tr>"
    for j in range(sensors_per_column):
        if i + j < len(sensor_rows):
            sensor = list(sensor_rows.keys())[i + j]
            sensor_color = sensor_colors.get(sensor, '')  # Get color for the sensor
            html_table += "<td style='vertical-align: top; background-color: {}; font-family: Verdana; text-align: left; padding: 5;'>".format(sensor_color)
            html_table += "<table border='1' style='font-family: Verdana; border-collapse: collapse; padding: 10; width: 100%;'>"
            html_table += "<tr><th style='font-family: Verdana;'>Sensor</th><th style='font-family: Verdana;'>Top URL</th><th style='font-family: Verdana;'>Source IP</th><th style='font-family: Verdana;'>Count</th></tr>"
            for result in sensor_rows[sensor]:
                sensor_name = result[0]  # Extract sensor name from the result
                url = result[1]  # Extract URL from the result
                ip_address = result[2]  # Extract IP address from the result
                count = result[3]  # Extract count from the result
                html_table += "<tr style='background-color: {}; font-family: Verdana; padding: 10;'>".format(sensor_color)
                html_table += "<td style='font-family: Verdana; padding: 10; width: 18%;'>{}</td>".format(sensor_name)
                html_table += "<td style='font-family: Verdana; padding: 10; width: 60%;'>{}</td>".format(url)
                html_table += "<td style='font-family: Verdana; padding: 10; width: 18%;'>{}</td>".format(ip_address)
                html_table += "<td style='font-family: Verdana; padding: 10; text-align: right; '>{}</td>".format(count)
                html_table += "</tr>"
            html_table += "</table>"
            html_table += "</td>"
        else:
            if j == sensors_per_column - 1:  # Check if it's the last cell in the last row
                html_table += "<td><img src='images/1on1Logo.png' alt='New Logo' width='125' height='125' align=right></td>"
            else:
                html_table += "<td></td>"
    html_table += "</tr>"

html_table += "</table></body></html>"

# Save the HTML table to a file
file_path = "/var/www/html/top5URLs.html"
with open(file_path, "w") as file:
    file.write(html_table)

print(f"HTML table saved as '{file_path}'")
