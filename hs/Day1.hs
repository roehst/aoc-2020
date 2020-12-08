#!runghc

{-# OPTIONS_GHC  -Wall #-}

module Main where

readNumbers :: IO [Int]
readNumbers = map read . lines <$> readFile "../inputs/Day1.txt"

main :: IO ()
main = do

  numbers <- readNumbers

  let (a1, b1) = head $ problem1 numbers
  let x1 = a1 * b1
  putStrLn $ "x1=" ++ show x1

  let (a2, b2, c2) = head $ problem2 numbers
  let x2 = a2 * b2 * c2

  putStrLn $ "x2=" ++ show x2

problem1 :: [Int] -> [(Int, Int)]
problem1 numbers = [(a, b) | a <- numbers, let b = 2020 - a, b`elem` numbers]


problem2 :: [Int] -> [(Int, Int, Int)]
problem2 numbers = [(a, b, c) | a <- numbers, b <- numbers, let c = 2020 - a - b, c `elem` numbers]