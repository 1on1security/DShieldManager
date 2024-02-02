#!/usr/bin/env python3

import subprocess
import os
from concurrent.futures import ThreadPoolExecutor


def rsync_transfer(hostname):
    # SSH parameters
    ssh_user = 'dshield'
    ssh_port = 12222
    private_key_path = '/data/dshieldManager/bin/ssh/dshield-key.pem'

    # Local and remote directory paths
    local_directory = f'/data/dshieldManager/_incoming/{hostname}/downloads'
    remote_directory = f'{ssh_user}@{hostname}:/srv/cowrie/var/lib/cowrie/downloads/'

    try:
        # Change ownership of /pcap and contents to dshield user
        subprocess.run(['ssh', '-i', private_key_path, '-p', str(ssh_port), f'{ssh_user}@{hostname}', f'sudo chown -R {ssh_user}:{ssh_user} {remote_directory}'])

        # Create local directory if it doesn't exist
        os.makedirs(local_directory, exist_ok=True)

        # Use rsync to transfer files from remote to local
        print(f"Transfer {hostname}")
        subprocess.run(['rsync', '-e', f'ssh -i {private_key_path} -p {ssh_port}', '-av', '--progress', f'{remote_directory}/', local_directory])

        print(f"Transfer completed for {hostname}")

    except Exception as e:
        print(f"Error transferring files for {hostname}: {e}")

def main():
    # Read hostnames from file
    with open('/data/dshieldManager/agents/sensors.config', 'r') as file:
        hostnames = [line.strip() for line in file.readlines()]

    # Use ThreadPoolExecutor for parallel execution
    with ThreadPoolExecutor(max_workers=len(hostnames)) as executor:
        executor.map(rsync_transfer, hostnames)

if __name__ == "__main__":
    main()
