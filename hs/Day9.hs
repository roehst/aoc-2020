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

    let cumsum = scanl (+) 0 numbers

    let answer1 = fromJust $ check (take 25 numbers) (drop 25 numbers)

    let fromto i j = cumsum !! j - cumsum !! i

    print answer1

    let (i, j) = head $ [(i, j) | i <- [0 .. length numbers - 1],
                                 j <- [0 .. length numbers - 1],
                                 fromto i j == answer1]

    let slice = take (j - i) $ drop i $ numbers                            

    let answer2 = minimum slice + maximum slice

    print $ answer2

    return ()
