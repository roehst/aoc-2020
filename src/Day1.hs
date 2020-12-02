{-# OPTIONS_GHC -Wall #-}

module Day1 where


readNumbers :: IO [Int]
readNumbers = map read . lines <$> readFile "inputs/Day1.txt"

day1 :: IO ()
day1 = do

  numbers <- readNumbers
  let (a1, b1) = problem1 numbers
  let x1 = a1 * b1
  let (a2, b2, c2) = problem2 numbers
  let x2 = a2 * b2 * c2
  putStrLn $ "x1=" ++ show x1
  putStrLn $ "x2=" ++ show x2

problem1 :: [Int] -> (Int, Int)
problem1 numbers = head [(a, b) | a <- numbers, b <- numbers, a + b == 2020]

problem2 :: [Int] -> (Int, Int, Int)
problem2 numbers =
  head [(a, b, c) | a <- numbers, b <- numbers, c <- numbers, a + b + c == 2020]
