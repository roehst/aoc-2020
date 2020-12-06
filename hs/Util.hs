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
        (left,right') = break f s
        right = if null right' then [] else tail right'

splitListBy :: (a -> Bool) -> [a] -> [[a]]
splitListBy _ [] = []
splitListBy f list = h:splitListBy f t
        where (h,t)=split f list  

split' :: String -> String -> String -> [String]
split' [] _ buf = [buf]
split' text sep buf | text `startsWith` sep = buf : split' (drop (length sep) text) sep []
                    | otherwise = split' (tail text) sep (head text : buf)


splitStr :: String -> String -> [String]
splitStr sep  text = split' text sep []

startsWith :: Eq a => [a] -> [a] -> Bool
startsWith (x:xs) (y:ys) | y == x = startsWith xs ys
                         | otherwise = False
startsWith _ [] = True
startsWith [] _ = False