## Remote Deploy Tools
Primary documentation for the phases of installation are being documented in 
**<a href="../GETTING_STARTED.md">GETTING_STARTED.md</a>**.

And Hey!  Did you know this has been fleshed out for Terraform over at:
https://github.com/DShield-ISC/dshield/blob/main/README_Terraform.md

This folder contains the files listed below.  It's not as complex as it may appear.

```
├── README.md
├── azureDShieldHoneypot.template       Template for Azure automation
├── deployAzureDShieldSensor.bash       Meat and Potatoes script
├── dshield-key.pub                     Public Key, added to .json
├── files2upload.zip                    Files we will upload to the Host
├── files2zip                           
│   ├── crontab                         (This folder contains the files
│   ├── iptables                        from which files2upload.zip is derived.)
│   ├── packagePackets.bash
│   ├── packetCapture.bash
│   └── updateLinux.bash
├── phonyWebsite                        I'm not presently automating anything
│   ├── README.md                       related to this directory.  A quick
│   ├── fakeHUD                         stroll through files will explain it.
│   │   ├── images
│   │   │   ├── favicon.ico
│   │   │   ├── nobody.gif
│   │   │   ├── worldMap1.jpg
│   │   │   ├── worldMap2.jpg
│   │   │   ├── worldMap3.jpg
│   │   │   ├── worldMap4.jpg
│   │   │   ├── worldMap5.jpg
│   │   │   └── worldMap6.jpg
│   │   ├── index.html
│   │   ├── nobody.html
│   │   └── worldMap.jpg
│   └── randomImage.bash
└── sites.csv                           A list of site/location pairs - I hope to 
                                        use this to deploy more than one host at a time.
```
