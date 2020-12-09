#!runghc

module Main where

import Data.Maybe

readInput :: IO [Int]
readInput = map read <$> lines <$> readFile "../inputs/Day9.txt"

check :: [Int] -> [Int] -> Maybe Int
check past [] = Nothing
check past (x:xs) =
    let validatingPairs = [(a, b) | a <- past, b <- past, a /= b, a + b == x] in
        case validatingPairs of
            (p:_) -> check (tail past ++ [x]) xs
            _ -> Just x

allContiguous :: [Int] -> [[Int]]
allContiguous xs =

    let ix = [0 .. length xs - 1] in

        [slice i j xs | i <- ix, j <- ix, i < j]

    where

        slice start end xs = take (end - start) $ drop start xs

main :: IO ()
main = do

    numbers <- readInput

    let answer1 = fromJust $ check (take 25 numbers) (drop 25 numbers)
    let slice = head $ [slice | slice <- allContiguous numbers, sum slice == answer1]
    let answer2 = minimum slice + maximum slice

    print $ answer1
    print $ answer2

    return ()
