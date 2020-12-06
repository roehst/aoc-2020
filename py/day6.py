#!python3

from functools import reduce


def main1():

    groups = open("../inputs/Day6.txt", "r").read().split("\n\n")

    total = 0

    for group in groups:
        group = group.replace("\n", "")
        group = set(sorted(group))
        total += len(group)

    print(total)


def main2():

    groups = open("../inputs/Day6.txt", "r").read().split("\n\n")

    total = 0

    for group in groups:

        individuals = group.split("\n")

        individuals = [set(individual) for individual in individuals]

        rules = reduce(lambda a, b: a.intersection(b), individuals)

        total += len(rules)

    print(total)


if __name__ == '__main__':
    main1()
    main2()
