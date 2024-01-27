#!/usr/bin/env python3
# fileSizeDistribution.py
# For a given path graph file size distribution including subdirectories.

import os
import sys
import matplotlib.pyplot as plt
from collections import defaultdict
import subprocess

def get_file_sizes(directory, min_size=600):
    file_sizes = defaultdict(list)

    for root, dirs, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            size = os.path.getsize(file_path) / (1024 ** 2)  # Convert bytes to megabytes
            if size > min_size:
                file_sizes[root].append((file_path, size))

    # Sort file sizes within each directory by size in descending order
    for directory, sizes in file_sizes.items():
        file_sizes[directory] = sorted(sizes, key=lambda x: x[1], reverse=True)

    return file_sizes

def plot_distribution(file_sizes):
    plt.figure(figsize=(15, 5))

    for directory, sizes in file_sizes.items():
        largest_files = sizes[:5]  # Display information about the top 3 largest files
        sizes = [size[1] for size in sizes]

        plt.hist(sizes, bins=15, alpha=0.8, label=directory)

        # Calculate y-coordinate for annotation to stack them vertically with space
        y_annotation = [35 * (i + 1) for i in range(len(largest_files))]  # Adjust the value (35) for desired space

        # Annotate the largest files with their names and sizes
        for i, (file_path, size) in enumerate(largest_files):
            plt.annotate(f"{os.path.basename(file_path)}\n({size:.2f} MB)",
                         xy=(size, 0), xycoords=('data', 'axes fraction'),
                         xytext=(0, y_annotation[i]), textcoords='offset points',
                         ha='center', va='bottom', color='red', fontsize=12, rotation=45)

    plt.title(f'File Size Distribution for Directory and Subdirectories)')
    plt.xlabel('File Size (MB)')
    plt.ylabel('Frequency')

    # Move the legend outside the plot area
    plt.legend(loc='upper left', bbox_to_anchor=(1, 1))

    plt.grid(True)

    plt.savefig('/tmp/dshieldManager.fileSizeDistribution.png', bbox_inches='tight')
    plt.show()

def open_with_gpicview(image_path):
    try:
        subprocess.run(['gpicview', image_path])
    except FileNotFoundError:
        print("gpicview is not installed. Please install it or use another image viewer.")

def main():
    if len(sys.argv) != 2:
        print("Usage: {} <directory>".format(sys.argv[0]))
        sys.exit(1)

    directory = sys.argv[1]

    if not os.path.exists(directory):
        print("Invalid directory path. Please provide a valid directory.")
        return

    file_sizes = get_file_sizes(directory)
    plot_distribution(file_sizes)

    print("File size distribution graph saved as '/tmp/dshieldManager.fileSizeDistribution.png'")
    open_with_gpicview('/tmp/dshieldManager.fileSizeDistribution.png')

if __name__ == "__main__":
    main()
