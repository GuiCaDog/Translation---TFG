import sys, json

with open('crawl.json', 'r') as f:
    data = json.load(f)
    for new in data['objects']:
        if int(new['date'][0:4]) < int("2021"):
            print(new['id'])


