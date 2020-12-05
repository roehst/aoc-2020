{-# OPTIONS_GHC -Wall #-}

module Util where

readLines :: String -> IO [String]
readLines f = lines <$> readFile f

count :: (a -> Bool) -> [a] -> Int
count p = length . filter p

xor :: Bool -> Bool -> Bool
xor a b = a /= b

splitList :: Eq a => a -> [a] -> [[a]]
splitList _   [] = []
splitList sep list = h:splitList sep t
        where (h,t)=split (==sep) list       

split :: (a -> Bool) -> [a] -> ([a], [a])
split f s = (left,right)
        where
        (left,right')=break f s
        right = if null right' then [] else tail right'

splitListBy :: (a -> Bool) -> [a] -> [[a]]
splitListBy _ [] = []
splitListBy f list = h:splitListBy f t
        where (h,t)=split f list  