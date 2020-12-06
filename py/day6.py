#!python3

from functools import reduce


def union_many(xs):
    return reduce(lambda a, b: a | b, xs)


def intersection_many(xs):
    return reduce(lambda a, b: a & b, xs)


def main():

    groups = open("../inputs/Day6.txt", "r").read().split("\n\n")

    total1 = 0
    total2 = 0

    for group in groups:

        individuals = [set(individual) for individual in group.split("\n")]

        rules1 = union_many(individuals)
        rules2 = intersection_many(individuals)

        total1 += len(rules1)
        total2 += len(rules2)

    print(total1)
    print(total2)


if __name__ == '__main__':
    main()
