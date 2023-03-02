import sys

article = sys.argv[1]
score = sys.argv[2]
article_out = sys.argv[3]

with open(article) as fp:
    Lines = fp.readlines()
    
    f = open(article_out, "a")

    for line in Lines:
        line_split = line.split("\t")
        line_score = line_split[2].strip()
        if float(line_score) > float(score):
            f.write(line)

    f.close()

