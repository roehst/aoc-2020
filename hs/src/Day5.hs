#!runghc

{-# OPTIONS_GHC  -Wall #-}

module Day5 where

import Data.Maybe (fromJust)
import Data.List (find)

type Range = (Int, Int)

rowApplyToRange :: Char -> Range -> Range
rowApplyToRange 'F' (lower, upper) = (lower, (lower + upper) `div` 2)
rowApplyToRange 'B' (lower, upper) = (1 + (lower + upper) `div` 2, upper)
rowApplyToRange _ _ = error "Invalid symbol in row locator"

colApplyToRange :: Char -> Range -> Range
colApplyToRange 'L' (lower, upper) = (lower, (lower + upper) `div` 2)
colApplyToRange 'R' (lower, upper) = (1 + (lower + upper) `div` 2, upper)
colApplyToRange _ _ = error "Invalid symbol in col locator"

decodeRowLocator :: String -> Int
decodeRowLocator locator = 
    go locator (0, 127)
    where
        go :: String -> Range -> Int
        go [] (lower, upper) | lower == upper = upper
                             | otherwise = error "Search  error"
        go (c:cs) (lower, upper) = go cs (rowApplyToRange c (lower, upper))

decodeColLocator :: String -> Int
decodeColLocator locator =
    go locator (0, 7)
    where
        go :: String -> Range -> Int
        go [] (lower, upper) | lower == upper = upper
                             | otherwise = error "Search  error"
        go (c:cs) (lower, upper) = go cs (colApplyToRange c (lower, upper)) 

decodeLocator :: String -> Int
decodeLocator locator = 
    let rowLocator = take 7 locator in
    let colLocator = reverse $ take 3 $ reverse locator in
    let row = decodeRowLocator rowLocator in
    let col = decodeColLocator colLocator in
        row * 8 + col

main :: IO ()
main = do

    seatIDs <- map decodeLocator <$> lines <$> readFile "../../inputs/Day5.txt" 

    let lowest = minimum seatIDs
    let highest = maximum seatIDs
    let allSeats = [lowest..highest]
    let mySeat = fromJust $ find (`notElem` seatIDs) allSeats

    print highest
    print mySeat