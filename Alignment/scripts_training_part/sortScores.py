scores = []
with open("../all_sentences_scores") as fp:
    Lines = fp.readlines()
    for line in Lines:
        scores.append(float(line))

    scores.sort()

    for keep in range(100, 40, -10):

        keep_index = ((100-keep)*len(scores)) / 100
        print(keep, keep_index, scores[keep_index])
        #print(len(scores))
