
# Initial Azure Needs
This project presumes at a minimum you already have a functioning Azure account. 

(This is defined as, I can log onto the Portal with a valid Subscription, and I've also installed the Azure CLI in Linux and have authenticated with it.)

You might even consider creating a brand new Microsoft account/subscription to segregate everything, given the nature of the project.

Were we to presume you've decided a brand new Asure account is the way to go, it is recommended to first create a Resource Group named "dshield" to house a Global Network Security Group and a Storage Account. (Mine are named dshield-global and globaldshield respectively and live in US Central) The "Location" you select for this Resource Group will be where your ssh-key is stored.

These two links can get you up and running with CLI installation, and logging on, to support the remainder of the project.<br>
Information on installing the Azure CLI for Linux: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt<br>
Getting started with Azure CLI: https://learn.microsoft.com/en-us/cli/azure/get-started-with-azure-cli

The project also presumes you have a custom domain name to fiddle with.

(Mine is quite similar to [nobodyspecial.com])

If you DON'T have a domain to work with... just make one up!<br>
Place it in the ~/bin/VARS file and use your local /etc/hosts file to manage your DNS resolution manually.

---

## Internet Storm Center
You'll need to visit https://isc.sans.edu/ and sign up for an account.  Once you've created an account you can obtain your API key, necessary for installation and operation of the DShield Honeypot.

---

## Let's consider "Location" for a minute
My intention is to deploy (for my own purposes) a DShield Honeypot on every continent.

This will impact my <a href="../img/potentialExpense.png">cloud spend signifigantly</a>, although the thirty-day $200 credit trial is fairly nifty.  More important are questions such as, what Hardware/VM size can I select in my template that will work in *all* of the locations I'm interested in?

Through several nights of trial and error I've settled on "vmSize": "Standard_B1s" in the .json template.<br>
04 DEC 2023: Analysis of spend for the month of November has me changing this up for "Standard_B1ls".


(Tested in locations: africa australia eastasia eastus europe india israel korea southamerica southeastasia westus)

There are **SEVERAL** locations that do **not** support this size and I have avoided them on purpose.

## Create an SSH key-pair in Azure
**MUST BE PRESENT OR _ALL_ WILL FAIL!**<br>
*(Step-by-step with screencaps will go here if/when I get to them.)*<br>

Save **dshield-key.pem** to path $dshieldManager/remoteDeploy/

The *deployAzureDShieldSensor.bash* script in this path will use it when generating custom .json.

Save **dshield-key.pem** to path $dshieldManager/bin/ssh and set file permissions on this key to 400.

ALL of our scripting relies upon this private SSH key for authentication.

---

## A few words about "my" process.
I am developing this repository from within Windows Subsystem for Linux, Ubuntu 22.04.3 LTS.<br>
My "insance" of this codebase lives in /dshieldManager in my filesystem.  My personal ~/.bashrc contains the following alias:

>alias dshield="cd /dshieldManager/; source /dshieldManager/bin/VARS; source /dshieldManager/bin/ALIASES"

So I toss out a quick "dshield"[CR] and I'm in the /dshieldManger directory.  From here I can run dshieldManager by typing "dshieldmanager" 
followed by carriage return.<br>
When developing or updaing code, I execute "*code .*" to open the directory in Visual Studio Code and manage the codebase with Git.

I will make references in this documentation to *$dshieldManager*.  This is the primary variable in VARS that you set to the absolute 
path in your linux filesystem. When making such references, I'm pointing to a relative subdirectory.  For example, *$manageDshield/bin* 
on my dev system would resolve to */dshieldManager/bin*.

I will also make use of *eastus* throughout documentation to reference Resource Group or host name.

---

# So what exactly am I looking at here?

The overall directory structure:

```
├── INSTALL_NOTES.md    <-- You're reading it now
├── README.md           <-- Top-level readme
├── archive             <-- This will be a local repository of Logs and Packets for your Honeypots
├── bin                 <-- The majority of binary or executable script live here.
├── db                  <-- This is a scratch directory with a template for importing .json into sqlite3
├── img                 <-- Images referenced in documentation.
├── logs                <-- This is where we download live logs, packets, TTY and download files.
├── packets             <-- This is where tarballs are extracted before being archived; a working copy of .pcap files for current period.
└── remoteDeploy        <-- Files supporting the deployment of sensors to azure.
```
I suppose I should bust out Visio and make something really detailed and pretty.  Or even like, in a simple series of circles and lines 
in MS Paint. Alas, I haven't gone there yet.  Here's what you need to know at 10,000 feet.<br>

You're going to deploy, at a minimum, one linux host into Azure and then install and configure the DShield Honeypot.  From there, you'll use this local project to PULL data from the Honeypots.  While there is some automation via cron on the honeypot, *the device is also already involved in exporting information to isc.sans.org*, which we do not wish to interrupt.  What we're doing is creating a local copy of the most interesting of the logs it already produces, and then manipulating/searching/analyzing it.

---

# For the Impatient
1. Get a DShield Account at https://isc.sans.org

2. Install and configure Azure CLI in Linux.

3. Fetch the repo locally.  If you put it in /dshieldManager on your local machine it will mirror mine.  Doesn't really matter.

4. Create an SSH keypair in Azure and save files where they belong.
    a.) *dshield-key.pem* to ~/bin/ssh
    b.) *dshield-key.pub* to ~/remoteDeploy

5. Edit $dshieldDirectory/bin/VARS

Set the first variable *dshieldDirectory* to the root of where you placed the repo.

>example: dshieldDirectory=/dshieldManager

If you have a custom domain of your own for use in this project, set it in this file.  If you don'thave one, you MUST make one up.

If you have a local instance of Security Onion for analysis, that too is set here.  (It presumes you have exported your SSH ID to the onion server.)

I place the following alias in my local ~/.bashrc file

>alias dshield="cd /dshieldManager/; source /dshieldManager/bin/VARS; source /dshieldManager/bin/ALIASES"

I can now execute "*source ~/.bashrc*" to make the changes active (they'll be active on all subsequent logins with bash), and then type "dshield" at the command line.

You'll find yourself in the /dshieldManger foler [or alternate path if you opted] and can excute "dshieldmanager" to launch.

---

## Deploy Linux Host to Azure
6. While in the *dshieldDirectory* cd into the remoteDeploy directory.

If you need to search for Azure locations, let's say for "United States", you can excute the following:

>az account list-locations -o table | grep '(US)'

A list of **tested/verified** locations for our project is also present in **sites.csv**

For our example, we're going to deploy a host named "*eastus*" to location *eastus2*

We accomplish this by simply executing "*./deployAzureDShieldSensor.bash eastus eastus2*". This will generate custom .json and deploy to your chosen location.

### DO NOT USE Hypnens or other characters in your hostnames!!!  (Causes some failures.)

The PUBLIC IP address of the new system will be provided; update your DNS or hosts records accordingly.

Immediately after deployment the Linux host is accepting SSH connections on TCP Port 22.  I've created a pair of handy scripts in the /bin/ssh directory; "*pre-dshield*" and "*ssh-to*".  They both make use of the private key for authentication and take a single input:

hostname.  **Not 'FQDN', just hostname**.  Whatever you used in /bin/VARS earlier for domain will be appended.

They're in your path by virtue of having sourced /bin/VARS so we can execute "*pre-dshield eastus*" to be connected.

The second script, "*ssh-to*" makes use of *BASENAME $0* to quickly establish connections at the command line.  By creating a symbolic link in the /bin/ssh directory merely typing a hostname will initiate a connection.

>example: ln -s ssh-to eastus

I can now execute "*eastus*" to initiate SSH to that sensor on TCP Port 12222.
(This functions AFTER DShield Installation changes SSH management to port 12222.)

---

## Install DShield Honeypot
7. The DShield Honeypot git repository has already been downloaded for you during deployment, and
you can begin the install by issuing "*sudo ./dshield/bin/install.sh*" once logged on.

## Post DShield Installation Edits
8. For my own purposes, I must custom edit /etc/network/iptables to include several IP ranges from Starlink, my ISP.

This file also will NOT survive an automatic update. (A fix from Dr. Ulrich is in the works.)

In the file /etc/dshield.ini you may wish to include:<br>
*localcopy=/logs/localDshield.log*<br>
to create a separate copy of the dshield logfile.

In /srv/cowrie/cowrie.cfg replace "ttylog = false" with "ttylog = true".

Once all post-install edits have been completed, reboot the Honeypot.