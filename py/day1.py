lines = open("../inputs/Day1.txt", "r").readlines()
lines = [int(l) for l in lines]

for a in lines:
	for b in lines:
		if a < b:
			if (a + b == 2020):
				print(a*b)

for a in lines:
	for b in lines:
		for c in lines:
			if a < b < c:
				if (a + b + c == 2020):
					print(a*b*c)			