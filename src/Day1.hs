module Day1 where

import Control.Monad

-- Day 1 was easy. We are given a list
-- of numbers and we must find a pair of numbers that
-- adds to 2020, and then a triple of numbers that adds
-- to 2020.

-- The solution was easy using the list monad.

day1 :: IO ()
day1 = do

    numbers <- map read <$> lines <$> readFile "inputs/Day1.txt"

    -- We could pick all solutions, but
    -- we only need one for the puzzle.
    let (a, b) = head $ solve2 numbers

    print a
    print b
    print (a*b)

    -- Same story but with 3 numbers.
    let (a, b, c) = head $ solve3 numbers

    print a
    print b
    print c
    print (a*b*c)


-- Here I use the list monad to filter through all pairs of
-- numbers and return only those that satisfy some
-- criteria.
-- This is equivalent to using list comprehensions.
solve2 :: [Int] -> [(Int, Int)
solve2 numbers = do
    a <- numbers
    b <- numbers 
    guard $ a + b == 2020
    return (a, b)

solver3 :: [Int] -> [(Int, Int, Int)]
solve3 numbers = do
    a <- numbers
    b <- numbers 
    c <- numbers 
    guard $ a + b +c == 2020
    return (a, b, c)