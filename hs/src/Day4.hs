module Day4 where

import Control.Monad (guard)
import Data.Either
import Data.Map (Map)
import qualified Data.Map as M
import Data.Maybe
import Text.ParserCombinators.Parsec hiding (count)
import Util

type Key = String

type Value = String

type Record = Map Key Value

type Check = Maybe ()

parseKey :: Parser String
parseKey = many1 letter

parseValue :: Parser String
parseValue = many1 (letter <|> digit <|> char '#')

parseTag :: Parser (String, String)
parseTag = (,) <$> (parseKey <* char ':') <*> parseValue

parseLine :: Parser [(Key, Value)]
parseLine = parseTag `sepBy` space

parseFile :: [String] -> Either ParseError [Record]
parseFile lines = parseFile' lines []

parseFile' :: [String] -> [(Key, Value)] -> Either ParseError [Record]
parseFile' [] buf = return [M.fromList buf]
parseFile' (x : xs) buf =
  case parse parseLine "" x of
    Right [] -> do
      rest <- parseFile' xs []
      return $ M.fromList buf : rest
    Right r ->
      parseFile' xs (r ++ buf)

requiredKeys :: [Key]
requiredKeys = ["iyr", "byr", "ecl", "pid", "hcl", "eyr", "hgt"]

allowedEyeColors :: [String]
allowedEyeColors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

hasAllRequiredKeys :: Record -> Bool
hasAllRequiredKeys record = all (`elem` M.keys record) requiredKeys

hasValidValues :: Record -> Bool
hasValidValues dict = isJust $ do
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
  hgt <- M.lookup "hgt" dict

  let hgtVal = read $ reverse $ drop 2 $ reverse $ hgt

  let hgtUnit = reverse $ take 2 $ reverse $ hgt

  if hgtUnit == "cm"
    then guard $ hgtVal >= 150 && hgtVal <= 193
    else
      if hgtUnit == "in"
        then guard $ hgtVal >= 59 && hgtVal <= 76
        else guard $ False
  where
    assert key pred = do
      value <- M.lookup key dict
      guard $ pred value

    assertInt key pred = do
      value <- read <$> M.lookup key dict
      guard $ pred value

day4 :: IO ()
day4 = do
  contents <- readFile "../inputs/Day4.txt"

  let records = parseFile $ lines contents

  checkRecords (fromRight undefined records)

  return ()

checkRecords :: [Record] -> IO ()
checkRecords records = do
  print $ count hasAllRequiredKeys records
  print $ count (\x -> hasValidValues x && hasAllRequiredKeys x) records
