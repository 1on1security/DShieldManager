#!/usr/bin/bash

/data/dshieldManager/agents/honeypotSync.py
/data/dshieldManager/agents/cowrieJson.py
/data/dshieldManager/agents/cowrieDownloads.py
/data/dshieldManager/agents/cowrieTTY.py
/data/dshieldManager/agents/packetSync.py
find /data/dshieldManager/_incoming/ -name .gitignore -delete
find /data/dshieldManager/_liveData/ -name .gitignore -delete
