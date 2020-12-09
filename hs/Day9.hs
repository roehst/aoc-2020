#!runghc

{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import qualified Data.Map as M

import Data.Map (Map)
import Data.Maybe

readInput :: IO [Int]
readInput = map read <$> lines <$> readFile "../inputs/Day9.txt"

check :: [Int] -> [Int] -> Maybe Int
check past [] = Nothing
check past (x:xs) =
  let validatingPairs = [(a, b) | a <- past, b <- past, a /= b, a + b == x]
   in case validatingPairs of
        (p:_) -> check (tail past ++ [x]) xs
        _ -> Just x

allContiguous :: [Int] -> [[Int]]
allContiguous xs =
  let ix = [0 .. length xs - 1]
   in [slice i j xs | i <- ix, j <- ix, i < j]
  where
    slice start end xs = take (end - start) $ drop start xs

main :: IO ()
main = do
  numbers <- readInput

  let cumsum :: Map Int Int = M.fromList $ zipWith (,) [0..] (scanl (+) 0 numbers)

  let lookupUnsafe k = fromJust . M.lookup k

  let answer1 = fromJust $ check (take 25 numbers) (drop 25 numbers)

  let fromto i j = (lookupUnsafe j cumsum) - (lookupUnsafe i cumsum)
  
  let (i, j) =
        head $
        [ (i, j)
        | i <- [0 .. length numbers - 1]
        , j <- [i .. length numbers - 1]
        , fromto i j == answer1
        ]
  
  let slice = take (j - i) $ drop i $ numbers
  
  let answer2 = minimum slice + maximum slice
  
  print answer1
  print answer2