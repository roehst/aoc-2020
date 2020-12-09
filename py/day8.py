#!/usr/bin/python3

def read_operations():
	ops = []
	for line in open("../inputs/Day8.txt", "r"):
		op, arg = line.strip().split(" ")
		arg = int(arg)
		ops.append((op, arg))
	return ops
		
def execute_1(ops):

	i = 0
	acc = 0
	visited = set()

	while i < len(ops):

		if i in visited:
			raise Exception("Loop detected", acc)

		visited.add(i)

		(op, arg) = ops[i]

		if op == "acc":
			acc += arg
			i = i + 1
		elif op == "jmp":
			i = i + arg
		elif op == "nop":
			i += 1

	return acc


def make_programs(ops):

	for i in range(0, len(ops)):

		(op, arg) = ops[i]

		if op == "jmp":

			copy = ops[:]
			copy[i] = ("nop", arg)

			yield copy

		elif op == "nop":

			copy = ops[:]
			copy[i] = ("jmp", arg)

			yield copy


if __name__ == '__main__':
		
	ops = read_operations()

	try:
		result = execute_1(ops)
		print(result)
	except Exception as e:
		print(e.args[1])

	programs = make_programs(ops)

	for p in programs:
		try:
			result = execute_1(p)
			print(result)
			break
		except:
			pass
