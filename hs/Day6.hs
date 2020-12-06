#!runghc

{-# OPTIONS_GHC  -Wall #-}

module Main where

import qualified Data.Set as S
import Util (splitStr)

readGroups :: IO [[S.Set Char]]
readGroups = do
    contents <- readFile "../inputs/Day6.txt"
    let groups = map lines . splitStr "\n\n" $ contents
    return $ fmap S.fromList <$> groups

main :: IO ()
main = do

    groups <- readGroups

    let union' = foldl1 S.union <$> groups
    let intersection' = foldl1 S.intersection <$> groups

    print $ sum $ map length $ union'
    print $ sum $ map length $ intersection'