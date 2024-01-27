
# SKRULL
I honestly don't know where the term "skrull" entered my brain.  I don't think the Marvel Cinematic Universe 
is nearly as responsible as the movie "Krull" back in the day but I digress.

My "I want informaton about a specific IP address" process cobbles togther output from four sources, all of 
which require an account and an API key.

- ipInfo.io via the ipinfo.bash script
(Edit to declare YOUR API key.)

- criminalIP.io via the criminalIpReport.py script
(Edit to declare YOUR API key.) 

- virustotal via the vt executable in $dshieldDirectory/bin
(https://github.com/VirusTotal/vt-cli_)
vt init to add your API key.

- Shodan via the Shodan CLI 
(Install via "pip install -U --user shodan", then initialize with "shodan init YOUR_API_KEY".)

Usage:
skrull.bash $ipAddress $ipAddress $ipAddress
($1, $2, $3 are captured allowing a total of three IP addresses per query.)


(/img/SkrullReport.png)