with open("CERNnews/CERNnews21.en") as fp:
    Lines = fp.readlines()
    count=0
    for line in Lines:
        line = line.split()
        count += 1
        if len(line) > 100: 
            print(str(count))

with open("CERNnews/CERNnews22.en") as fp:
    Lines = fp.readlines()
    count=0
    for line in Lines:
        line = line.split()
        count += 1
        if len(line) > 100: 
            print(str(count))
