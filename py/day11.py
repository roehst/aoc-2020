#!python3

from copy import deepcopy

from itertools import product

def board_load():
	return [
		[c for c in line.strip()]
		for line in open("../inputs/Day11.txt", "r").readlines()
	]

def board_get(board, i, j):
	return board[i][j]

def board_set(board, i, j, v):
	board[i][j] = v

def board_copy(board):
	return deepcopy(board)

def board_get_neighbourhood(board, i, j):

	neighbours = []

	for i_ in range(max(i - 1, 0), min(i + 2, board_rows(board))):
		for j_ in range(max(j - 1, 0), min(j + 2, board_cols(board))):
			if (i_, j_) != (i, j):
				neighbours.append(board_get(board, i_, j_))

	return neighbours

def board_get_occupied_adjacent_seats(board, i, j):
	return len([
		c for c in board_get_neighbourhood(board, i, j)
		if c == "#"
	])

def board_count_in_direction(board, i, j, stride):

	start = (i, j)

	while True:

		(a, b) = start
		(c, d) = stride

		a += c
		b += d

		if a < 0:
			return 0

		if a == board_rows(board):
			return 0

		if b < 0:
			return 0
		if b == board_cols(board):
			return 0			

		ch = board_get(board, a, b)

		if ch == '#':
			return 1
		elif ch == 'L':
			return 0

		start = (a, b)	

	return 0

def board_get_occupied_adjacent_seats_2(board, i, j):

	k = 0

	k +=  board_count_in_direction(board, i, j, (-1, -1))	
	k +=  board_count_in_direction(board, i, j, (-1, +1))
	k +=  board_count_in_direction(board, i, j, (+1, -1))
	k +=  board_count_in_direction(board, i, j, (+1, +1))

	k +=  board_count_in_direction(board, i, j, (+1, +0))
	k +=  board_count_in_direction(board, i, j, (-1, +0))
	k +=  board_count_in_direction(board, i, j, (0, -1))
	k +=  board_count_in_direction(board, i, j, (0, +1))	
	

	return k


def board_rows(board):
	return len(board)

def board_cols(board):
	return len(board[0])	

def board_count_occupied_seats(board):
	return sum([
		c == '#'
		for row in board
		for c in row
	])

board = board_load()
rows = board_rows(board)
cols = board_cols(board)

# while True:

# 	new_board =  board_copy(board)

# 	for i, j in product(range(0, rows), range(0, cols)):

# 		if board_get(board, i, j) != '.':

# 			n = board_get_occupied_adjacent_seats(board, i, j)

# 			if n == 0:
# 				board_set(new_board, i, j, '#')

# 			elif n >= 4:
# 				board_set(new_board, i, j, 'L')

# 	if board == new_board:
# 		break
# 	else:
# 		board = new_board

# print(board_count_occupied_seats(board))

new_board =  board_copy(board)	

for _ in range(200):

	new_board =  board_copy(board)

	for i, j in product(range(0, rows), range(0, cols)):

		if board_get(board, i, j) != '.':

			n = board_get_occupied_adjacent_seats_2(board, i, j)

			if n == 0:
				board_set(new_board, i, j, '#')
			elif n >= 5:
				board_set(new_board, i, j, 'L')

	if board == new_board:
		print("equilibrium")
		break
	else:
		board = new_board				

print(board_count_occupied_seats(board))