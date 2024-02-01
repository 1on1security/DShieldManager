#!/usr/bin/bash

# rsync a copy of the _incoming data pulled by agents into the dshield _liveData directory for analysis.
# We exclude packets as they'll be pulled via an alternate proces from .gz to .pcap and archived.
rsync -avuP /data/dshieldManager/_liveData/ /data/productionArchive/dshield/
