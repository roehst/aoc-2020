#!runghc

module Main where

import Data.Maybe
import Data.Map (Map)
import qualified Data.Map as M
import Data.List

readInputs :: IO [Int]
readInputs = sort . map read . lines <$> readFile "../inputs/Day10.txt"

subsequences' :: [a] -> [[a]]
subsequences' [] = [[]]
subsequences' (x:xs) = 
    let a = [x:s | s <- subsequences' xs] in
    let b = subsequences' xs in
    a ++ b

count :: [Int] -> Int
count xs = 
    let memo = M.empty in 
        let result = go xs memo (len xs') in
            undefined

main :: IO ()
main = do

    numbers <- readInputs

    let pairs = zipWith (,) numbers (tail numbers)

    let diff k = 1 + (length $ filter (\(a, b) -> b - a == k) pairs)

    print $ diff 1
    print $ diff 3
    print $ diff 3 * diff 1

    putStrLn $ "Possible subsequences: " ++ show (count numbers)

    return ()
