#!runghc

{-# OPTIONS_GHC  -Wall #-}

module Main where

data Stride
  = Stride Int Int
  deriving (Show)

data Position
  = Position Int Int
  deriving (Show)

class Toboggan a where
  isTree :: a -> Position -> Bool
  rows :: a -> Int
  cols :: a -> Int

instance Toboggan [String] where
  isTree x (Position i j) = '#' == x !! i !! (j `mod` cols x)
  rows = length
  cols = length . head

boolToInt :: Bool -> Int
boolToInt True = 1
boolToInt False = 0

runDown :: Toboggan a => a -> Stride -> Int
runDown toboggan (Stride down right) = loop (Position 0 0)
  where
    loop (Position i j)
      | i + down < rows toboggan =
        let i' = i + down
            j' = j + right
         in k + loop (Position i' j')
      | otherwise = 0
      where
        k = boolToInt $ isTree toboggan (Position i j)

day3 :: IO ()
day3 = do
  inputs <- lines <$> readFile "../inputs/Day3.txt"
  let strides = map (uncurry Stride) [(1, 1), (1, 3), (1, 5), (1, 7), (2, 1)]
  print $ runDown inputs (Stride 1 3)
  print $ product $ map (runDown inputs) strides
  return ()
