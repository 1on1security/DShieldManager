
# SKRULL
I honestly don't know where the term "skrull" entered my brain.  I don't think the Marvel Cinematic Universe 
is nearly as responsible as the movie "Krull" back in the day but I digress.<br>
<img src="https://github.com/1on1security/DShieldManager/blob/main/img/krull.png"  width="30%" height="30%">

> Krull is a 1983 science fantasy swashbuckler film directed by Peter Yates and written by Stanford Sherman. It follows Prince Colwyn and a fellowship of companions who set out to rescue his bride, Princess Lyssa, from a fortress of alien invaders who have arrived on their home planet.
<a href="https://en.wikipedia.org/wiki/Krull_(film)" target="_blank">https://en.wikipedia.org/wiki/Krull_(film)</a>

My "I want informaton about a specific IP address" process cobbles togther output from four sources, all of 
which require an account and an API key.

- <a href="https://ipinfo.io">ipInfo.io</a> via the ipinfo.bash script
(Edit to declare YOUR API key.)

- <a href="https://criminalip.io">criminalIP.io</a> via the criminalIpReport.py script
(Edit to declare YOUR API key.) 

- <a href="https://virustotal.com">virustotal</a> via the vt executable in $dshieldDirectory/bin
(https://github.com/VirusTotal/vt-cli_)
vt init to add your API key.

- <a href="https://www.shodan.io/">Shodan</a> via the Shodan CLI 
(Install via "pip install -U --user shodan", then initialize with "shodan init YOUR_API_KEY".)

Usage:
skrull.bash $ipAddress $ipAddress $ipAddress
($1, $2, $3 are captured allowing a total of three IP addresses per query.)

<img src="https://github.com/1on1security/DShieldManager/blob/main/img/skrullReport.png">
