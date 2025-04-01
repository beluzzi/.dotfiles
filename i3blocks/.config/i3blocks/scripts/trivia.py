#!/usr/bin/env python3
import requests
import json

url = 'https://opentdb.com/api.php?amount=1'

r = requests.get(url)

if r.status_code == 200:
    j = r.json()
    print(j['results'][0]['question']
)
else:
    print(f"Error: {response.status_code}")
