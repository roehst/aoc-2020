#!/usr/bin/python3

def localize_row(row_locator):

    lower = 0
    upper = 127

    for r in row_locator:

        if r == "F":
            upper = (upper + lower) // 2

        elif r == "B":
            lower = (upper + lower) // 2 + 1

    return upper


def localize_column(column_locator):

    lower = 0
    upper = 7

    for r in column_locator:

        if r == "L":
            upper = (upper + lower) // 2

        elif r == "R":
            lower = (upper + lower) // 2 + 1

    return upper


def localize_seat_id(locator):

    row_locator = locator[:7]
    column_locator = locator[-3:]

    row = localize_row(row_locator)
    column = localize_column(column_locator)

    return row * 8 + column


def find_highest_seat_id(occupied_seats):
    return max(occupied_seats)


def find_my_seat(occupied_seats):

    first_seat = min(occupied_seats)
    last_seat = max(occupied_seats)

    for i in range(first_seat, last_seat):
        if i not in occupied_seats:
            return i


def main():

    occupied_seats = [
        localize_seat_id(line.strip())
        for line in open("../inputs/Day5.txt", "r")
    ]

    print(find_highest_seat_id(occupied_seats))
    print(find_my_seat(occupied_seats))


if __name__ == '__main__':
    assert localize_seat_id("FBFBBFFRLR") == 357
    main()
