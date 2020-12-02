{-# OPTIONS_GHC -Wall #-}

module Day2 where

import Control.Monad (void)
import Text.ParserCombinators.Parsec hiding (count)

import Util

data PasswordEntry =
  PasswordEntry Int Int Char String
  deriving (Show)

parseLine :: Parser PasswordEntry
parseLine = do
  policyA <- parseInt
  void $ char '-'
  policyB <- parseInt
  void space
  policyCh <- letter
  void $ char ':'
  void space
  policyPwd <- many1 letter
  return $ PasswordEntry policyA policyB policyCh policyPwd
  where
    parseInt = read <$> many1 digit

check1 :: PasswordEntry -> Bool
check1 (PasswordEntry a b x p) =
  let l = count (== x) p
   in (a <= l) && (l <= b)

check2 :: PasswordEntry -> Bool
check2 (PasswordEntry a b x p) =
  let p1 = p !! (a - 1)
   in let p2 = p !! (b - 1)
       in (p1 == x) `xor` (p2 == x)

parseEntry :: String -> PasswordEntry
parseEntry = fromRight . parse parseLine ""

day2 :: IO ()
day2 = do
  entries <- map parseEntry <$> readLines "inputs/Day2.txt"
  print $ count check1 entries
  print $ count check2 entries
