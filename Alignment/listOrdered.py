import sys, json

with open('crawl.json', 'r') as f:
  data = json.load(f)
  for new in data['objects']:
      if new['date'][0:4] == "2022":
          if int(new['date'][5:7]) > 0:
            print(new['id'])


