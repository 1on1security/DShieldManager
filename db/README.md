## /db
This is a working directory for building sqlite3 database from honeypot.json files.<br>
In production it contain artifacts of the most recent execution of the "View honeypot .json files as sqlite3" function as well as the matching 
function for "all honeypot logs", etc.

Canned SQL queries for Top/Bottom IP/URL stats, etc. live in ./sql

./sql also holds two sqlitebrowser projects.  Each contain canned queries and bind to the appropriate daily/every database upon opening.<br>
A fresh install will contain only the files in ./sql until some imports have been executed.  Both are called from the menu.