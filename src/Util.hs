{-# OPTIONS_GHC -Wall #-}

module Util where

readLines :: String -> IO [String]
readLines f = lines <$> readFile f

fromRight :: Either a b -> b
fromRight (Right r) = r
fromRight (Left _) = error "fromRight failed"

count :: (a -> Bool) -> [a] -> Int
count p = length . filter p

xor :: Bool -> Bool -> Bool
xor a b = a /= b