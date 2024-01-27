#!/usr/bin/env python3
# pcapTTLbellCurve.py
# For a given .pcap file graph TTLs against a Bell Curve

import matplotlib.pyplot as plt
import numpy as np
from scapy.all import rdpcap, IP
import os

def extract_ttl_from_pcap(file_path):
    try:
        # Read the pcap file
        packets = rdpcap(file_path)

        # Extract TTL values from IP packets
        ttl_values = [packet[IP].ttl for packet in packets if IP in packet]

        return ttl_values

    except Exception as e:
        print(f"Error reading pcap file: {e}")
        return None

def plot_ttl_bell_curve(ttl_values, output_file):
    try:
        # Plot the TTL values over a bell curve
        plt.figure(figsize=(12, 8))  # Increase the graph size by 1/3
        plt.hist(ttl_values, bins=30, density=True, alpha=0.6, color='g')

        # Fit the data to a normal distribution (bell curve)
        mean_ttl = np.mean(ttl_values)
        std_dev_ttl = np.std(ttl_values)
        xmin, xmax = plt.xlim()
        x = np.linspace(xmin, xmax, 100)
        p = 1 / (std_dev_ttl * np.sqrt(2 * np.pi)) * np.exp(-(x - mean_ttl)**2 / (2 * std_dev_ttl**2))
        plt.plot(x, p, 'k', linewidth=2)

        plt.title('IP TTL Distribution and Bell Curve')
        plt.xlabel('TTL Value')
        plt.ylabel('Probability Density')
        plt.grid(True)

        # Save the graph as an image
        plt.savefig(output_file)
        plt.close()

        # Open the image using gpicview
#        os.system(f"$imageViewer {output_file} &")
        os.system(f"gpicview {output_file} &")

    except Exception as e:
        print(f"Error plotting graph: {e}")

if __name__ == "__main__":
    try:
        # Ask the user for the pcap file
        pcap_file_path = input("Enter the path to a pcap file to plot TTLs on a Bell Curve: ").strip()

        # Extract TTL values from the pcap file
        ttl_values = extract_ttl_from_pcap(pcap_file_path)

        if ttl_values:
            # Save and open the TTL graph with a bell curve
            output_file = "/tmp/dshield.ttl_bell_curve.png"
            plot_ttl_bell_curve(ttl_values, output_file)

    except KeyboardInterrupt:
        print("\nScript terminated by user.")
