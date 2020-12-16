#! runghc
module Main where

import Data.Char as Char

data Problem = Problem { problemTs :: Int, problemBuses :: [(Int, Int)] } deriving Show

split :: Char -> String -> [String]
split ch s =
  case dropWhile (== ch) s of
    "" -> []
    s' -> w : split ch s''
      where (w, s'') = break (== ch) s'

loadProblem :: String -> IO Problem
loadProblem path = do
  lines' <- lines <$> readFile path
  let line1 = lines' !! 0
  let line2 = lines' !! 1
  let ts = read line1 :: Int
  let entries = do
        (i, b) <- filter ((/=) "x" . snd) $ zip [0 ..] $ split ',' line2
        return (i, read b)
  return $ Problem ts entries


egcd :: Int -> Int -> (Int, Int, Int)
egcd a b =
    egcd' a b 0
    where
        

main = do

    problem <- loadProblem "../inputs/Day13.txt"

    let eqs = map (\(i, b) ->  (b - i, b)) $ problemBuses problem

    mapM_ print eqs

    print problem
