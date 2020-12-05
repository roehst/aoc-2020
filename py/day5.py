#!/usr/bin/python3

def localize_row(row_locator):

    lower = 0
    upper = 127

    for r in row_locator:

        if r == "F":
            upper = (upper + lower) // 2

        elif r == "B":
            lower = (upper + lower) // 2 + 1

    assert upper == lower

    return upper


def localize_column(column_locator):

    lower = 0
    upper = 7

    for r in column_locator:

        if r == "L":
            upper = (upper + lower) // 2

        elif r == "R":
            lower = (upper + lower) // 2 + 1

    assert upper == lower

    return upper


def localize_seat_id(locator):

    row_locator = locator[:7]
    column_locator = locator[-3:]

    assert len(row_locator) + len(column_locator) == len(locator)

    row = localize_row(row_locator)

    column = localize_column(column_locator)

    return row * 8 + column


def find_highest_seat_id():

    highest = 0

    for line in open("../inputs/Day5.txt", "r"):

        seat_id = localize_seat_id(line.strip())

        highest = max(seat_id, highest)

    print(highest)


def find_my_seat():

    occupied_seats = []

    for line in open("../inputs/Day5.txt", "r"):

        seat_id = localize_seat_id(line.strip())

        occupied_seats.append(seat_id)

    occupied_seats = sorted(occupied_seats)

    first_seat = min(occupied_seats)
    last_seat = max(occupied_seats)

    for i in range(first_seat, last_seat):
        if i not in occupied_seats:
            print(i)
            break


def main():

    find_highest_seat_id()
    find_my_seat()

if __name__ == '__main__':
    assert localize_seat_id("FBFBBFFRLR") == 357
    main()
