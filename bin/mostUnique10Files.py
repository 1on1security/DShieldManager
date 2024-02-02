#!/usr/bin/env python3
# mostUnique10Files.py
# For a given path path identifies the ten "most unique" files datestamp, filename, size.
# This is a BINARY hash comparison for speed and does not replay TTY files prior to compare.

import os
import sys
import datetime
import hashlib

def calculate_file_hash(file_path):
    # Initialize a hash object
    hash_object = hashlib.sha256()

    # Open the file in binary mode and read it in chunks
    with open(file_path, 'rb') as file:
        while True:
            # Read a chunk of data from the file
            data = file.read(4096)
            if not data:
                break
            # Update the hash object with the data
            hash_object.update(data)

    # Get the hexadecimal representation of the hash
    file_hash = hash_object.hexdigest()
    return file_hash

def get_file_timestamp_and_size(file_path):
    # Get the last modification time of the file
    timestamp = os.path.getmtime(file_path)
    # Get the size of the file
    size = os.path.getsize(file_path)
    return datetime.datetime.fromtimestamp(timestamp), size

def identify_unique_files(directory):
    unique_files = {}

    # Iterate over all files in the directory
    for file_name in os.listdir(directory):
        file_path = os.path.join(directory, file_name)

        try:
            # Calculate the hash of the file
            file_hash = calculate_file_hash(file_path)

            # Check if the hash is already in the dictionary
            if file_hash not in unique_files:
                # If not, add it along with the file name, timestamp, and size
                unique_files[file_hash] = (file_name, *get_file_timestamp_and_size(file_path))
        except Exception as e:
            print(f"Error processing file {file_name}: {e}")

    # Sort the unique files by timestamp
    sorted_unique_files = sorted(unique_files.values(), key=lambda x: x[1])

    return sorted_unique_files[:10]  # Return the top 10 unique files

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py /path/to/directory")
        sys.exit(1)

    directory = sys.argv[1]
    if not os.path.isdir(directory):
        print("Error: Directory not found.")
        sys.exit(1)

    unique_files = identify_unique_files(directory)

    for file_name, timestamp, size in unique_files:
        print(f"{timestamp}, {file_name}, {size} bytes")
