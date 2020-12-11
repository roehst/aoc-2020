#!runghc
{-# OPTIONS_GHC -Wall #-}

module Main where

import Data.List
import Data.Map (Map)
import qualified Data.Map as M
import Data.Maybe

readInputs :: IO [Int]
readInputs = sort . map read . lines <$> readFile "../inputs/Day10.txt"

reachable :: [Int] -> Int -> [Int]
reachable adapters pos = reachable' pos
  where
    size = length adapters
    joltage = adapters !! pos
    reachable' cur
      | cur == size = []
      | otherwise =
        if adapters !! cur - joltage <= 3
          then cur : reachable' (cur + 1)
          else []

ways :: [Int] -> Int
ways adapters = fromJust $ M.lookup 0 $ foldl f initialMemo reversedIndices
  where
    size = length adapters
    initialMemo = M.fromList [(size - 1, 1)]
    indices = [0 .. size - 1]
    reversedIndices = reverse indices
    f :: Map Int Int -> Int -> Map Int Int
    f memo pos = M.insert pos res memo
      where
        reachableFromPos = reachable adapters pos
        res = sum $ map readOrZero reachableFromPos
        readOrZero = fromMaybe 0 . flip M.lookup memo

main :: IO ()
main = do
  adapters <- readInputs
  let pairs = mkPairs adapters
  let diff k = 1 + length (filter (\(a, b) -> b - a == k) pairs)
  print $ diff 1
  print $ diff 3
  print $ diff 3 * diff 1
  print $ ways (0 : adapters)
  where
    mkPairs x = zip x (tail x)
