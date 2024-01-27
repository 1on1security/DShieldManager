## CLI Commands

There are a few python bits that live in ~/bin that either don't yet have a menu entry, or don't behave well wrapped in shell.

>fileSizeDistributionSubs.py
Executed from bash prompt, it will ask for a path to a _DIRECTORY_ and the creates a graph of general filesize distribution as a .png.  It will attempt to open it with gpicview; you can of course modify to your preferred image viewer.

>pcapTTLbellCurve.py
Executed at the command line it will ask for the path to an individual .pcap file and graph the TTLs present across a Bell Curve.

>pcapTTLbellCurveByMAC.py
Same as pcapTTLBellCurve.py, except output is broken out by MAC addres.