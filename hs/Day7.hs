#!runghc

module Main where

import Control.Monad
import Data.Maybe
import Text.ParserCombinators.Parsec hiding (count)

lexeme :: String -> Parser ()
lexeme s = spaces >> string s >> spaces

parseName :: Parser String
parseName = do
    name1 <- many1 letter
    space
    name2 <- many1 letter
    return $ name1 ++ " " ++ name2

parseContents :: Parser [(Int, String)]
parseContents = do
    try containsNothing <|> try containsThings
    where
        containsNothing = string "no other bags" >> return []
        containsThings = thing `sepBy1` (lexeme ",")
        thing = do
            n <- read <$> many digit
            spaces
            name <- parseName
            if n == 1 then
                lexeme "bag"
            else
                lexeme "bags"
            return (n, name)

parseLine :: Parser (String, [(Int, String)])
parseLine = do
    name <- parseName
    lexeme "bags contain"
    contents <- parseContents
    return (name, contents)

parse' :: String -> [Rule]
parse' str = 
    case parse parseLine "" str of
        Right (outer, inners) -> [Rule outer inner count | (count, inner) <- inners]
        e -> error $ show e

data Rule = Rule { outer :: String, inner :: String, count :: Int } deriving Show

inputs :: IO [Rule]
inputs = do
    lines' <- lines <$> readFile "inputs/Day7.txt"
    return $ join $ map parse' lines'

countUp :: String -> [Rule] -> [String]
countUp name rules =
    let parents = [outer rule | rule <- rules, inner rule == name] :: [String] in
        name : concatMap (flip countUp rules) parents

countDown :: String -> [Rule] -> Int
countDown name rules = 1 + sum [count rule * countDown (inner rule) rules | rule <- rules, outer rule == name]

for :: [a] -> (a -> b) -> [b]
for = flip map

uniq :: Eq a => [a] -> [a]
uniq [] = []
uniq (x:xs) | x `elem` xs = uniq xs
            | otherwise = x : uniq xs

main :: IO ()
main = do

    rules <- inputs

    print $ (length $ uniq $ countUp "shiny gold" rules) - 1
    print $ countDown "shiny gold" rules - 1

