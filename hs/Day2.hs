#!runghc

{-# OPTIONS_GHC -Wall #-}

module Main where

import Control.Monad (void)
import Data.Either
import Text.ParserCombinators.Parsec hiding (count, space)
import Util

data PasswordEntry
  = PasswordEntry Int Int Char String
  deriving (Show)

parseLine :: Parser PasswordEntry
parseLine = do
  policyA <- number
  dash
  policyB <- number
  space
  policyCh <- letter
  colon
  space
  policyPwd <- word

  return $ PasswordEntry policyA policyB policyCh policyPwd
  where
    colon = void $ char ':'
    dash = void $ char '-'
    space = void $ char ' '
    number = read <$> many digit
    word = many1 letter

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
parseEntry = fromRight undefined . parse parseLine ""

main :: IO ()
main = do
  entries <- map parseEntry <$> readLines "../inputs/Day2.txt"
  print $ count check1 entries
  print $ count check2 entries
