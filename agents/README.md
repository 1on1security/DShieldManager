# AGENTS
This directory contains python scripts to fetch cowrie downloads and tty logs, honeypot logs, and packets.<br>
Additional utility scripts to clear files older than 48 hours from sensors and to remove zero-byte files also live here.<p>

gatherAll.bash executes each of the python scripts, syncing data over rsync/ssh to the $dshieldDirectory/_incoming directory.<br>

sync2liveData.bash then performs an rsync to the $dshieldDirectory/_liveData directory.<br>

archive.bash syncronizes our $dshieldDirectory/_liveData back to /data/productionArchives/dshield<br>

The extractPackets function accessed via the main curses menu will extract any unprocessed tarballs into $dshieldDirectory/_packets, backup a copy of the tarball to archive, and delete the file in $dshieldDirectory/_liveData.  This leaves all packets separate from the TTY/Download/Honeypot data in a structure anticipated by the "analyze" script provided by Enclave.