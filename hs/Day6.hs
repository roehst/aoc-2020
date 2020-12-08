#!runghc

{-# OPTIONS_GHC  -Wall #-}

module Main where

import Data.Set (Set, intersection, union, fromList)
import Util (splitStr)

readGroups :: IO [[Set Char]]
readGroups = do
    
    contents <- readFile "../inputs/Day6.txt"
    
    -- Groups are separated by two lines
    let groups = map lines $ splitStr "\n\n" $ contents

    -- Convert groups from [String] to [Set Char]
    let groups' = map fromList <$> groups
    
    return groups'

main :: IO ()
main = do

    groups <- readGroups

    let union' = foldl1 union <$> groups
    let intersection' = foldl1 intersection <$> groups

    print $ sum $ map length $ union'
    print $ sum $ map length $ intersection'