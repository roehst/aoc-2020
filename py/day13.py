#! python3

from operator import mul
from functools import reduce
from collections import namedtuple

Problem = namedtuple("Problem", "earliest_time bus_lines")


def load_problem1(path):

    line1, line2 = open(path, "r").read().strip().split("\n")

    line2 = line2.split(",")

    earlier_departure_est = int(line1)
    bus_lines_in_service = [int(b) for b in line2 if b != "x"]

    return Problem(earlier_departure_est, bus_lines_in_service)


def load_problem2(path):

    line1, line2 = open(path, "r").read().strip().split("\n")

    line2 = line2.split(",")

    earlier_departure_est = int(line1)
    bus_lines_in_service = [(i, int(b))
                            for i, b in enumerate(line2) if b != "x"]

    return Problem(earlier_departure_est, bus_lines_in_service)


def problem1(problem):

    current_time = problem.earliest_time + 1
    bus_id = None

    for _ in range(1000):

        for bus_id in problem.bus_lines:
            if current_time % bus_id == 1:
                bus_id = bus_id
                break
        else:
            current_time += 1

    departure_time = current_time - 1

    wait = departure_time - problem.earliest_time

    print(wait * bus_id)

# https://martin-thoma.com/solve-linear-congruence-equations/
def egcd(a, b):

    aO, bO = a, b

    x = lasty = 0
    y = lastx = 1
    while b != 0:
        q = a // b
        a, b = b, a % b
        x, lastx = lastx - q * x, x
        y, lasty = lasty - q * y, y

    return (lastx, lasty, aO * lastx + bO * lasty)

def product(xs):
    return reduce(mul, xs)

def solve_lgc(rests, modulos):

    x = 0

    M = product(modulos)

    for modulo_i, rest_i in zip(modulos, rests):
        Mi = M // modulo_i
        (s, _ ,_) = egcd(Mi, modulo_i)
        e = s * Mi
        x += rest_i * e

    return ((x % M) + M) % M, M

path = "../inputs/Day13.txt"

p1 = load_problem1(path)
p2 = load_problem2(path)

problem1(p1)

rests = []
modulos = []

# checking each answer on brute forced is:
# def check(problem, timestamp):
#      return all((timestamp) % b == (-i+b) % b for (i, b) in problem.bus_lines)
# which gives a system of linear modulo equations (linear congruences)
# t % b == -i+b % b -> (t == b - i) % b

for (i, b) in p2.bus_lines:
    rest = b - i
    modulo = b
    rests.append(rest)
    modulos.append(b)
    print(rest,modulo)

    


print(solve_lgc(rests, modulos)[0])