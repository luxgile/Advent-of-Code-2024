left = []
right = []
with open("day_01.txt") as input:
    for line in input:
        left.append(int(line[0:5]))
        right.append(int(line[8:13]))

right.sort()
left.sort()

total_distance = 0
for l, r in zip(left, right):
    total_distance += abs(l - r)

print(total_distance)