#! python3

import numba
import numpy as np


def solve(path, k=0):

    numbers = [
        int(x)
        for x in open(path).read().split(",")
    ]

    tight(np.array(numbers), k)


@numba.jit(nopython=True)
def tight(numbers, k):

    gaps1 = np.repeat(-1, k)
    gaps2 = np.repeat(-1, k)

    for i, n in enumerate(numbers):

        gaps2[n] = i+1

    n = numbers[-1]

    i = len(numbers) + 1

    while i < k + 1:

        (a, b) = gaps1[n], gaps2[n]

        if a == -1:
            n = 0
            gaps1[0], gaps2[0] = gaps2[0], i

        else:
            c = b - a
            n = c
            gaps1[c], gaps2[c] = gaps2[c], i

        i += 1

    print(n)


solve("../inputs/Day15.txt", 2020)
solve("../inputs/Day15.txt", 30 * 1000 * 1000)
