import re

x1 = 0
x2 = 0

for line in open("../inputs/Day2.txt", "r"):
    line = line.strip()
    m = re.match("([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)", line)

    (a, b, c, d) = m.groups()

    a = int(a)
    b = int(b)

    ocurrences = len([ch for ch in d if ch == c])

    if a <= ocurrences <= b:
        x1 += 1
    if (d[a-1] == c) != (d[b-1] == c):
        x2 += 1

print(x1, x2)
