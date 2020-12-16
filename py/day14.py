#! python3

from collections import defaultdict

import re


def read_input(path):

    f = open(path, "r")

    set_mask_re = re.compile(r"mask = ([01X]+)")
    write_re = re.compile(r"mem\[([0-9]+)\] = ([0-9]+)")

    commands = []

    for line in f.readlines():

        line = line.strip()

        m = set_mask_re.match(line)

        if m:
            (mask,) = m.groups()
            mask0, mask1 = mask_str_to_int(mask)
            commands.append(("SET_MASK", mask0, mask1))

        m = write_re.match(line)

        if m:
            (addr, value) = m.groups()
            commands.append(("WRITE", int(addr), int(value)))

    f.close()

    return commands


def mask_str_to_int(mask):

    mask0 = 0
    mask1 = 0

    for i, c in enumerate(reversed(mask)):
        if c == "0":
            mask0 |= (1 << i)
        elif c == "1":
            mask1 |= (1 << i)

    return (int(mask0), int(mask1))


def find_bit_positions(n, width=36):

    return set(i for i in range(width) if n & (1 << i))


def iterate_submasks(n, width=36):

    positions = find_bit_positions(n, width)

    for p in powerset(positions):
        p_ = positions - p
        yield (p, p_)


def powerset(lst):
    # the power set of the empty set has one element, the empty set
    result = [[]]
    for x in lst:
        result.extend([subset + [x] for subset in result])
    result = [set(r) for r in result]
    return result


def find_floating_mask(mask0, mask1):

    maskf = ((2**36-1) & ~ mask1) & ~ mask0

    return maskf


def make_bits(positions):
    return sum(1 << p for p in positions)


commands = read_input("../inputs/Day14.txt")

# Problem 1

memory = defaultdict(lambda: 0)

mask0, mask1 = None, None

for command in commands:

    if command[0] == 'SET_MASK':

        _, mask0, mask1 = command

    elif command[0] == 'WRITE':

        _, addr, value = command

        memory[addr] = (value | mask1) & ~ mask0

print(sum(memory.values()))

# Problem 2


# import sys; sys.exit(0)


memory = defaultdict(lambda: 0)

for command in commands:

    if command[0] == 'SET_MASK':

        _, mask0, mask1 = command

        maskf = ((2 ** 36 - 1) & ~ mask1) & ~ mask0

        assert mask0 | mask1 | maskf == 2 ** 36 - 1

    elif command[0] == 'WRITE':

        _, addr, value = command

        addr = addr | mask1

        for mask0_, mask1_ in iterate_submasks(maskf):

            mask0_ = make_bits(mask0_)
            mask1_ = make_bits(mask1_)

            assert maskf == mask0_ + mask1_

            addr_ = (addr | mask1_) & ~ mask0_

            memory[addr_] = value

print(sum(memory.values()))
