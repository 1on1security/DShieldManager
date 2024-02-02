# AGENTS
THis directory contains python scripts to fetch cowrie downloads and tty, honeypot logs, and packets.<br>
Additional utility scripts to clear files older than 48 hours from sensors, and to remove zero-byte files also live here.<p>

gatherAll.bash executes each of the python scripts, syncing data over rsync/ssh to the _incoming directory.<br>

sync2liveData.bash then performs an rsync to the _liveData directory.<br>

archive.bash syncronizes our _liveData back to /data/productionArchives/dshield<br>

The extractPackets function accessed via Menu Item 2 will extract any unprocessed tarballs into _packets, backup a copy of the tarball to archive, and delete the file in _liveData.  This leaves all packets separate from the TTY/Download/Honeypot data in a structure anticipated by the "analyze" script provided by Enclave.