{-# OPTIONS_GHC -Wall #-}

module Util where

readLines :: String -> IO [String]
readLines f = lines <$> readFile f

count :: (a -> Bool) -> [a] -> Int
count p = length . filter p

xor :: Bool -> Bool -> Bool
xor a b = a /= b