
# DShieldManager

DShield provides a platform for users of firewalls to share intrusion information. DShield is a free and open service.

If you use a firewall, please submit your logs to the DShield database. We recently culled our list of supported firewalls as most uses use our honeypot. But if you have a firewall you would like to see supported, contact us here. You will need to register for a free account to submit data.

Everybody is welcome to use the information collected by us and desimminated via this site to protect their network from intrusion attempts. Let us know how it helps you or how we can improve the data. <a href="https://www.dshield.org/howto.html" target="_blank">Source</a> 

The DShieldManager project is intended for use with multiple DShield honeypots to gather and aggregate data into a large local data store for research and analysis.

For the impatient, consult [Getting Started](/docs/GETTING_STARTED.md)

![DShieldManager](https://github.com/1on1security/DShieldManager/blob/main/img/00-banner.png "DShieldManager")

## Features
- Collect honeypot, firewall, tty and download logs from DShield honeypots into local storage.
- Perform and collect full packet capture (hourly files, daily wrapup) for all honeypots.
- Import honeypot .json logs for all sensors by date into sqlite3 database for analyisis.
- Import ALL honeypot .json logs for all sensors for ALL OF TIME into sqlite3 database for analyis.
- Execute remote commands on sensors.
- Provide graphic analysis of honeypot, firewall, tty and download log file sizes to detect abnormaly sized logfiles.
- Provide graphic analysis of packet file sizes in both daily "YYYY-MM-DD.tar.gz" format as well as extracted .pcap files.
- Perform a full archive of all logged data over time for historical analysis


## Acknowledgements

 - Dr. Johannes Ullrich: Dr. Johannes Ullrich is the Dean of Research for SANS Technology Institute, a SANS Faculty Fellow, and founder of the Internet Storm Center [DShield.org] which provides a free analysis and warning service to thousands of Internet users and organizations. <a href="https://www.sans.org/profiles/dr-johannes-ullrich/">Profile</a>

 - Jesse La Grew: Chief Information Security Officer at Madison Area Technical College and my Mentor in the SANS-4499 internship with the SANS Internet Storm Center. <a href="https://www.linkedin.com/in/jesselagrew/" target="_blank">Profile</a>

 Binaries from other projects that live in ./bin:

- [./bin/analyze] Copyright 2008-2019 <a href="https://www.enclavesecurity.com/" target="_blank">Enclave Forensics, Inc</a> / David Hoelzer

- [./bin/playlog] Copyright (C) 2003-2011 Upi Tamminen desaster@dragonlight.fi

- <a href="https://github.com/VirusTotal/vt-cli)" target=_blank">[./bin/vt]</a>

- <a href="" target="_blank">[./bin/sqlitebrowser]</a>

## Documentation

[Documentation](https://github.com/1on1security/DShieldManager/blob/main/docs/GETTING_STARTED.md)

## Authors

- [@1on1security](https://1on1security.com)
