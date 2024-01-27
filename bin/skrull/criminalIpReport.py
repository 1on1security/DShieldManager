#!/usr/bin/env python3
import requests
import sys

ip = sys.argv[1]
url = "https://api.criminalip.io/v1/asset/ip/report?ip="
#url = "https://api.criminalip.io/v1/feature/ip/malicious-info?ip="
#url = "https://api.criminalip.io/v1/asset/ip/summary?ip="
#url = "https://api.criminalip.io/v1/feature/ip/suspicious-info?ip="

url = url + ip

payload={}
headers = {
  "x-api-key": "YOUR_APIKEY_HERE"
}

response = requests.request("GET", url, headers=headers, data=payload)

print(response.text)
