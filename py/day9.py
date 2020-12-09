#!/usr/bin/python3

from itertools import product

def check_1(past, future):

	cur = future[0]

	possible = False

	for (a, b) in product(past, past):
		if a + b == cur:
			possible = True
			break
	
	if not possible:
		return cur

	past.append(cur)

	return check_1(past[1:], future[1:])

def contiguous(xs):

	for i in range(0, len(xs)):
		for j in range(i, len(xs)):
			if i < j:
				yield xs[i:j]

if __name__ == '__main__':
	
	numbers = [
		int(i)
		for i in open("../inputs/Day9.txt", "r").readlines()
	]

	answer = check_1(numbers[:25], numbers[25:])

	print(answer)

	upto = {}

	upto[0] = numbers[0]

	for i in range(1, len(numbers)):
		upto[i] = numbers[i] + upto[i-1]

	try:

		for i in range(1, len(numbers)):
			for j in range(0, len(numbers)):
				i_to_j = upto[j] - upto[i-1]
				if i_to_j == answer:
					s = numbers[i:j+1]
					raise Exception((max(s) + min(s)))
	except Exception as e:
		print(e.args[0])