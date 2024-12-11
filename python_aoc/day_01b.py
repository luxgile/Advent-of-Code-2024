left = []
right = []
with open("day_01.txt") as input:
    for line in input:
        left.append(int(line[0:5]))
        right.append(int(line[8:13]))

right.sort()
left.sort()

total_similarity = 0
for l in left:
    total_similarity += l * right.count(l)

print(total_similarity)