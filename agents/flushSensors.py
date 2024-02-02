#!/usr/bin/env python3

import paramiko
import concurrent.futures

def execute_remote_commands(hostname, username, key_file, commands):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        ssh.connect(hostname, port=12222, username=username, key_filename=key_file)
        for command in commands:
            stdin, stdout, stderr = ssh.exec_command(command)
            print(f"Results for command '{command}' on {hostname}:")
            print(stdout.read().decode())
            print(stderr.read().decode())
    except Exception as e:
        print(f"Error executing commands on {hostname}: {e}")
    finally:
        ssh.close()

def main():
    with open('/data/dshieldManager/agents/sensors.config') as f:
        hostnames = f.read().splitlines()

    username = 'dshield'
    key_file = '/data/dshieldManager/bin/ssh/dshield-key.pem'
    commands = [
        "sudo find /srv/db/*.json -type f -mtime +1 -delete",
        "sudo find /pcap -type f -mtime +1 -delete",
        "sudo find /srv/cowrie/var/log/cowrie/ -type f -mtime +1 -delete",
        "sudo find /srv/cowrie/var/lib/cowrie/tty -type f -mtime +1 -delete",
        "sudo find /srv/cowrie/var/lib/cowrie/downloads -type f -mtime +1 -delete"
    ]

    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = [executor.submit(execute_remote_commands, hostname, username, key_file, commands) for hostname in hostnames]
        for future in concurrent.futures.as_completed(futures):
            try:
                future.result()
            except Exception as e:
                print(f"Error: {e}")

if __name__ == "__main__":
    main()
