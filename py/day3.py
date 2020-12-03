#!/usr/bin/python3

from functools import reduce
from operator import mul


class Toboggan:

    def __init__(self):
        self.__rows = [
            line.strip()
            for line in open("../inputs/Day3.txt", "r")
        ]

    @property
    def nrows(self):
        return len(self.__rows)

    @property
    def ncols(self):
        return len(self.__rows[0])

    def is_tree(self, i, j):

        return self.__rows[i][j % self.ncols] == "#"

    def run(self, down, right):

        cur_i, cur_j = 0, 0

        trees = 0

        while cur_i < self.nrows:

            if self.is_tree(cur_i, cur_j):
                trees += 1

            cur_i += down
            cur_j += right

            if cur_i > self.nrows:
                break

        return trees


def product(xs):
    return reduce(mul, xs)


def main():

    toboggan = Toboggan()

    slides = [
        (1, 1),
        (1, 3),
        (1, 5),
        (1, 7),
        (2, 1)
    ]

    answer1 = toboggan.run(1, 3)
    answer2 = product(toboggan.run(d, r) for (d, r) in slides)

    print(f"Problem 1: {answer1}")
    print(f"Problem 2: {answer2}")


if __name__ == '__main__':
    main()
