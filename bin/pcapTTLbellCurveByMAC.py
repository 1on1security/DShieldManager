#!/usr/bin/env python3
# pcapTTLbellCurveByMAC
# For a given .pcap file graph TTLs per MAC address against a Bell Curve

import matplotlib.pyplot as plt
import numpy as np
from scapy.all import rdpcap, IP, Ether
import os

def extract_ttl_and_mac_from_pcap(file_path):
    try:
        # Read the pcap file
        packets = rdpcap(file_path)

        # Extract TTL values and MAC addresses from IP packets
        ttl_and_mac_values = [(packet[IP].ttl, packet[Ether].src) for packet in packets if IP in packet and Ether in packet]

        return ttl_and_mac_values

    except Exception as e:
        print(f"Error reading pcap file: {e}")
        return None

def plot_ttl_bell_curve_per_mac(ttl_and_mac_values, output_file):
    try:
        # Separate TTL values and MAC addresses
        ttl_values, mac_addresses = zip(*ttl_and_mac_values)

        # Get unique MAC addresses
        unique_mac_addresses = list(set(mac_addresses))
        num_unique_macs = len(unique_mac_addresses)
        colors = plt.cm.viridis(np.linspace(0, 1, num_unique_macs))  # Use viridis colormap for colors

        # Plot the TTL values over a bell curve with different colors for different MAC addresses
        plt.figure(figsize=(12, 8))  # Increase the graph size by 1/3
        for i, mac_address in enumerate(unique_mac_addresses):
            mac_ttl_values = [ttl for ttl, mac in ttl_and_mac_values if mac == mac_address]
            plt.hist(mac_ttl_values, bins=30, density=True, alpha=0.6, color=colors[i], label=f'MAC: {mac_address}', width=2)

        plt.legend()
        plt.title('IP TTL Distribution and Bell Curve per MAC Address')
        plt.xlabel('TTL Value')
        plt.ylabel('Probability Density')
        plt.grid(True)

        # Save the graph as an image
        plt.savefig(output_file)
        plt.close()

        # Open the image using gpicview
        os.system(f"gpicview {output_file} &")

    except Exception as e:
        print(f"Error plotting graph: {e}")

if __name__ == "__main__":
    try:
        # Ask the user for the pcap file
        pcap_file_path = input("Enter the path to the pcap file: ").strip()

        # Extract TTL values and MAC addresses from the pcap file
        ttl_and_mac_values = extract_ttl_and_mac_from_pcap(pcap_file_path)

        if ttl_and_mac_values:
            # Save and open the TTL graph with a bell curve per MAC address
            output_file = "/tmp/dshieldManager.ttl_bell_curve_per_mac.png"
            plot_ttl_bell_curve_per_mac(ttl_and_mac_values, output_file)

    except KeyboardInterrupt:
        print("\nScript terminated by the user.")
