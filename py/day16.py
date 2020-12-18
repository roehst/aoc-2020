#! python3

from collections import namedtuple
from pprint import pprint
import re

Problem = namedtuple("Problem", "constraints my_ticket other_tickets")
Constraint = namedtuple("Constraint", "variable range1 range2")
Range = namedtuple("Range", "a b")

RANGE_SPEC = re.compile(
    "([a-z ]+): ([0-9]+)-([0-9]+) or ([0-9]+)-([0-9]+)")


def read_input(path):

    constraints = []
    other_tickets = []
    my_ticket = None

    with open(path, "r") as i:

        match = RANGE_SPEC.match(next(i))

        while match is not None:

            variable, range_1_a, range_1_b, range_2_a, range_2_b = match.groups()

            range_1_a, range_1_b, range_2_a, range_2_b = int(range_1_a), int(range_1_b), int(range_2_a), int(range_2_b)

            constraints.append(Constraint(variable, Range(
                range_1_a, range_1_b), Range(range_2_a, range_2_b)))

            match = RANGE_SPEC.match(next(i))

        assert next(i) == "your ticket:\n"

        my_ticket = list(
            map(int, next(i).strip().split(","))
        )

        assert next(i) == "\n"

        assert next(i) == "nearby tickets:\n"

        for line in i:
            other_tickets.append(
                list(map(int, line.strip().split(",")))
            )

        return Problem(constraints, my_ticket, other_tickets)


def constraint_contains(constraint, value):

    c1 = (constraint.range1.a <= value <= constraint.range1.b)
    c2 = (constraint.range2.a <= value <= constraint.range2.b)

    # print(constraint, value, c1, c2)

    return c1 or c2


def is_simply_valid(problem, value):

    for c in problem.constraints:
        if constraint_contains(c, value):
            return True

    return False


def solve1(problem):

    n = 0

    tickets = problem.other_tickets + [problem.my_ticket]

    for ticket in tickets:

        for value in ticket:

            if not is_simply_valid(problem, value):

                n += value

    return n


def is_ticket_valid(problem, ticket):

    return all(is_simply_valid(problem, value) for value in ticket)


def find_fields(problem, value):

    fields = set()

    for constraint in problem.constraints:
        if constraint_contains(constraint, value):
            fields.add(constraint.variable)

    return fields


def solve2(problem):

    tickets = problem.other_tickets# + [problem.my_ticket]

    tickets = [t for t in tickets if is_ticket_valid(problem, t)]

    ticket = tickets[0]

    columns = set(c.variable for c in problem.constraints)

    columns = {
        i: set(c.variable for c in problem.constraints)
        for i in range(len(problem.other_tickets))
    }

    for ticket in tickets:

        for i, value in enumerate(ticket):

            fs = find_fields(problem, value)

            columns[i] = columns[i] & fs

    # pprint(columns)

    results = {}

    i = 0

    while any(len(v) > 0 for _, v in columns.items()):

        i += 1

        if i > 20:
            break

        for (k, v) in columns.items():
            if len(v) == 1:
                results[k] = v
                delete = v
                break

        for k in columns.keys():
            columns[k] = columns[k] - delete

    results = {
        list(v)[0]:k for k, v in results.items()
    }

    j = 1
    for k, v in results.items():
        if k.startswith("departure"):
            print(k, v, problem.my_ticket[v])
            j *= problem.my_ticket[v]

    return j


problem = read_input("../inputs/Day16.txt")

pprint(solve2(problem))
