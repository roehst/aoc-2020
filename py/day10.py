#!python3

from queue import Queue

lines = open("../inputs/Day10.txt", "r").readlines()

# Problem 1

adapters = sorted([int(line) for line in lines])

counts = {1: 1, 3: 1}

for (a, b) in zip(adapters, adapters[1:]):
	counts[b - a] +=  1

print(counts[1] * counts[3])

adapters.insert(0, 0)

from collections import defaultdict

ways = defaultdict(lambda: 0)
ways[len(adapters) - 1] = 1

for cur in reversed(range(0, len(adapters))):

	try:
		if 1 <= adapters[cur + 1] - adapters[cur] <= 3:
			ways[cur] += ways[cur + 1]
	except IndexError:
		...

	try:
		if 1 <= adapters[cur + 2] - adapters[cur] <= 3:
			ways[cur] += ways[cur + 2]
	except IndexError:
		...

	try:
		if 1 <= adapters[cur + 3] - adapters[cur] <= 3:
			ways[cur] += ways[cur + 3]
	except IndexError:
			...

print(ways[0])