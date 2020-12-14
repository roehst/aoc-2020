#! python3

from dataclasses import dataclass


@dataclass
class Point:
    x: float
    y: float

    def copy(self):
        return Point(self.x, self.y)

    @property
    def size(self):
        return abs(self.x) + abs(self.y)

    def move(self, dx, dy):
        self.x += dx
        self.y += dy

    def move_north(self, n):
        self.move(0, n)

    def move_south(self, n):
        self.move(0, -n)

    def move_east(self, n):
        self.move(n, 0)

    def move_west(self, n):
        self.move(-n, 0)

    def rotate(self, degrees):

        cos_ = cos(degrees)
        sin_ = sin(degrees)

        new_x = self.x * cos_ - self.y * sin_
        new_y = self.x * sin_ + self.y * cos_

        self.x = new_x
        self.y = new_y


@dataclass
class Instruction:
    op: str
    arg: int


def sin(theta):

    return {
        0: 0,
        90: 1,
        180: 0,
        270: -1
    }[theta % 360]


def cos(theta):

    return {
        0: 1,
        90: 0,
        180: -1,
        270: 0
    }[theta % 360]


def line_to_instruction(line):

    instruction = line[0]
    argument = int(line[1:])

    return Instruction(instruction, argument)


def load_instructions(path):

    return [
        line_to_instruction(line)
        for line in open(path, "r").readlines()
    ]

def run_instructions1(location: Point, waypoint: Point, instructions: Instruction):

    for instruction in instructions:

        op = instruction.op
        arg = instruction.arg

        if op == "N":
            location.move_north(arg)
        elif op == "S":
            location.move_south(arg)
        elif op == "W":
            location.move_west(arg)
        elif op == "E":
            location.move_east(arg)
        elif op == "L":
            waypoint.rotate(arg)
        elif op == "R":
            waypoint.rotate(-arg)
        elif op == "F":
            location.x += waypoint.x * arg
            location.y += waypoint.y * arg

    return (location, waypoint)


def run_instructions2(location, waypoint, instructions):

    for instruction in instructions:

        op = instruction.op
        arg = instruction.arg

        if op == "N":
            waypoint.move_north(arg)
        elif op == "S":
            waypoint.move_south(arg)
        elif op == "W":
            waypoint.move_west(arg)
        elif op == "E":
            waypoint.move_east(arg)
        elif op == "L":
            waypoint.rotate(arg)
        elif op == "R":
            waypoint.rotate(-arg)

        elif op == "F":

            location.x += waypoint.x * arg
            location.y += waypoint.y * arg

    return (location, waypoint)


instructions = load_instructions("../inputs/Day12.txt")

(location, direction) = run_instructions1(Point(0, 0), Point(1, 0), instructions)

print(location.size)

(location, waypoint) = run_instructions2(
    Point(0, 0), Point(10, 1), instructions)

print(location.size)
