The original dshieldManager.bash was running out of screen real estate (and alphabet shortcuts) rapidly.<br>
I still like it, but it's just so busy and difficult to look at once the empty space has been consumed.<p>

<img src="../img/dshieldManager.png" alt="OG DShieldManager" width="640" height="480">

With this in mind, I've decided to upgrade to an ncurses/dialog menu system.

Here's a brief overview of the menu, which could very well change.

<a href="img/01-mainMenu.png"><img src="../img/01-mainMenu.png"></a><br>
***The Main Menu***<br>
This includes sub-menus according to the data/log type being managed.<br>
h   Manage Honeypot Logs<br>
f   Manage Firewall Logs<br>
p   Manage Packets<br>
t   Manage TTY Logs<br>
d   Manage Downloads<br>
F   Perform Get/Fetch Functions<br>
x   Exit<br>

<a href="img/02-manageHoneyPotLogs.png"><img src="../img/02-manageHoneypotLogs.png"></a><br>
***Manage Honeypot Logs***<br>
Short menu differentiating "Daily" operations, and "ALL LOGS" operations.<br>

<a href="img/03-dailyHoneypotLogs.png"><img src="../img/03-dailyHoneypotLogs.png"></a><br>
***Daily Honeypot Logs***<br>
f   Fetch Logs from Sensors<br>
i   Import Daily Logs to sqlite database for analysis<br>
v   View the Daily Database just created.<br>
ip  Display the Top 5 Source IPs for the day.<br>
URL Display the Top 5 URL Requests for the day.<br>

<a href="img/03a-dateSelect.png"><img src="../img/03a-dateSelect.png"></a><br>
***Date Select***<br>
Used when selecting the "Import Daily Logs to sqlite" function to select the date to import.<br>

<a href="img/04-manageALLhoneypotLogs.png"><img src="../img/04-manageALLhoneypotLogs.png"></a><br>
***Manage ALL Honeypot Logs***<br>
Similar to Daily Honeypot Logs menu with the exception of being focused on ALL Honeypot lots in our archive.<br>
Working with ALL logs, particularly importing, can take several minutes depending on processor speed.<br>
The remaining functions also mimic daily, with focus on ALL.<br>

<a href="img/05-manageFirewallLogs.png"><img src="../img/05-manageFirewallLogs.png"></a><br>
***Manage Firewall Logs***<br>
Fetch, Import and View the Daily logs, along with Fetch, Import and View ALL Firewall Logs for all time.

<a href="img/06-managePackets.png"><img src="../img/06-managePackets.png"></a><br>
***Manage Packets***<br>
f   Fetch packets from sensor(s)<br>
e   Extract Packets<br>
U   Upload and Ingest Packets to Security Onion Server<br>

<a href="img/07-manageTTYlogs.png"><img src="../img/07-manageTTYlogs.png"></a><br>
***Manage TTY Logs***<br>
f   Fetch TTY Logs from Sensor(s)<br>
e   Extract TTY Logs (downloaded in .zip format)<br>
R   Replay TTY Log<br>

<a href="img/08-manageDownloads.png"><img src="../img/08-manageDownloads.png"></a><br>
***Manage Downloads***<br>
f   Fetch Downloads from Sensor(s)<br>
e   Extract Downloads (downloaded in .zip format, password protected with "infected")<br>

<a href="img/09-fetchFunctions.png"><img src="../img/09-fetchFunctions.png"></a><br>
***Fetch Functions***<br>
Repeats each of the data type "fetch" functions into a single menu.<br>
h   Fetch Honeypot Logs<br>
t   Fetch TTY Logs<br>
d   Fetch Downloads<br>
f   Fetch Firewall Logs<br>
p   Fetch Packets<br>
A   Fetch ALL Logs and Packets <-- THIS CAN TAKE A LONG TIME AND A LOT OF BANDWIDTH!<br>

<a href="img/00-banner.png"><img src=../img/00-banner.png></a><br>
