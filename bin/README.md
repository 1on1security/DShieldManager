## /bin
This folder contains

```
.
├── ALIASES
├── analyze
├── banner.txt
├── fileSizeDistribution.py
├── fileSizeDistributionSubs.py
├── FUNCTIONS
├── mostUnique10Files.py
├── pcapTTLbellCurveByMAC.py
├── pcapTTLbellCurve.py
├── playlog
├── README.md
├── simpleCursedDshield.bash
├── skrull
├── ssh
│   ├── dshield-key.pem
│   ├── north-america-east -> ssh-to
│   ├── north-america-west -> ssh-to
│   ├── pre-dshield
│   └── ssh-to
├── VARS
└── vt


```

## ALIASES, FUNCTIONS, VARS
These three files are **_crucial_** to executing the *simpleCursedDshieldManager.bash* script, the primary executable for the project.

My *.bashrc* file on my development workstation contains the following alias:

alias dshield="cd /dshieldManager/; source /dshieldManager/bin/VARS; source /dshieldManager/bin/ALIASES"

I also export */dshieldManager/bin* to my current PATH.

ALIASES is fairly straightforward, and provides shortcuts for the overall project.

FUNCTIONS contains the meat and potatoes of execution, as 99% of going on inside the much smaller *simpleCursedDshieldManager.bash* is a call to a function in this file.

banner.txt contains my pretty ASCII artwork that scrolls up the screen when launching *dshieldManager.bash* which is quickly being replaced by *cursedDshieldManager.bash* with an ncurses dialog menu.


**playlog** is used for replaying TTY logs.<br>
**vt** is a command-line interface from Virus Total.

## ssh
SSH management tools live here, along with a copy of your *dshield-key.pem* key.

There are two executable bash scripts in the directory, *pre-dshield* and *ssh-to*.  Both scripts evaluate the first argument passed to them to identify which host to connect to.  It does **NOT** use a *FQDN* and will fail if you provide it in this format.

The *pre-dshield* script is used briefly to connect to a brand-spanking-new Linux host in Azure prior to deploying DShield.<br>
Example:

>./pre-dshield westus

Presuming a dns A record resolves for *westus* in the domain you have declared in VARS, a connection will be established on TCP Port 22.  You can then begin installing DShield on the host.

Once you've installed DShield and made all post-installation edits, you'll reboot the host.  At that point SSH on TCP Port 22 is no longer available, and we start using the *ssh-to" script instead.  The beauty of this script is that you merely create a symbolic link to it with the name of your host.  Once in place you can simply type the name of the host at the command line to establish an administrative connection on TCP Port 12222.  This script also evaluates the first arguement passed to it, allowing remote execution of commands without interactive logon.

Example:

>westus sudo /srv/dshield/status.sh
