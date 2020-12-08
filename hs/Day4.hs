#!runghc

{-# OPTIONS_GHC  -Wall #-}

module Main where

import Control.Monad (guard)
import Data.List
import Data.Map (Map)
import qualified Data.Map as M
import Data.Maybe
import Util

type Record = Map String String

type Check = Maybe ()

requiredKeys :: [String]
requiredKeys = ["iyr", "byr", "ecl", "pid", "hcl", "eyr", "hgt"]

allowedEyeColors :: [String]
allowedEyeColors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

hasAllRequiredKeys :: Record -> Bool
hasAllRequiredKeys record = all (`elem` M.keys record) requiredKeys

hasValidValues :: Record -> Bool
hasValidValues record = isJust $ do

  assertInt "byr" (>= 1920)
  assertInt "byr" (<= 2002)

  assertInt "iyr" (>= 2010)
  assertInt "iyr" (<= 2020)

  assertInt "eyr" (>= 2020)
  assertInt "eyr" (<= 2030)

  assert "hcl" ((== '#') . head)
  assert "hcl" (all (`elem` "0123456789abcdef") . tail)

  assert "ecl" (`elem` allowedEyeColors)

  assert "pid" (all (`elem` "0123456789"))
  assert "pid" ((== 9) . length)

  -- hgt is a bit trickier
  hgt <- M.lookup "hgt" record

  let hgtVal = read $ reverse $ drop 2 $ reverse $ hgt :: Int

  let hgtUnit = reverse $ take 2 $ reverse $ hgt

  if hgtUnit == "cm"
    then guard $ hgtVal >= 150 && hgtVal <= 193
    else
      if hgtUnit == "in"
        then guard $ hgtVal >= 59 && hgtVal <= 76
        else guard $ False
  where
    assert :: String -> (String -> Bool) -> Check
    assert key p = do
      value <- M.lookup key record
      guard $ p value

    assertInt :: String -> (Int -> Bool) -> Check
    assertInt key p = do
      value <- read <$> M.lookup key record
      guard $ p value

(|>) :: a -> (a -> b ) -> b
(|>) x f = f x

($|>) :: [a] -> (a -> b ) -> [b]
($|>) x f = map f x

recordToMap :: String -> Map String String
recordToMap record = M.fromList $ record |> splitListBy (== ' ') $|> (split (== ':'))

main :: IO ()
main = do
  
  contents <- readFile "../../inputs/Day4.txt"

  let records = contents |> lines |> splitList "" $|> (concat . intersperse " ") $|> recordToMap

  checkRecords records

checkRecords :: [Record] -> IO ()
checkRecords records = do
  print $ count hasAllRequiredKeys records
  print $ count (\x -> hasValidValues x && hasAllRequiredKeys x) records
