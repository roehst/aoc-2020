module Day1 where

import Control.Monad


day1 :: IO ()
day1 = do

    numbers <- map read <$> lines <$> readFile "inputs/Day1.txt"

    let (a, b) = head $ solve2 numbers

    print a
    print b
    print (a*b)

    let (a, b, c) = head $ solve3 numbers

    print a
    print b
    print c
    print (a*b*c)


solve2 numbers = do
    a <- numbers
    b <- numbers 
    guard $ a + b == 2020
    return (a, b)

solve3 numbers = do
    a <- numbers
    b <- numbers 
    c <- numbers 
    guard $ a + b +c == 2020
    return (a, b, c)