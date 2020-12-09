#!runghc
module Main where

import Control.Monad.Writer
import Data.Either
import Data.Set (Set)
import qualified Data.Set as S
import Text.ParserCombinators.Parsec

data Op =
  Op
    { opName :: String
    , opArg :: Int
    }
  deriving (Show)

parseLine :: Parser Op
parseLine = do
  name <- many1 letter
  space
  sign <-
    do ch <- anyChar
       (if ch == '+'
          then return 1
          else return (-1))
  arg <- read <$> many1 digit
  return $ Op name (sign * arg)

loadOps :: IO [Op]
loadOps = do
  lines' <- lines <$> readFile "../inputs/Day8.txt"
  let ops = fromRight undefined . parse parseLine "" <$> lines'
  return ops

execute1 :: [Op] -> Int -> Int -> Set Int -> Int
execute1 program cur acc visited =
  if cur `elem` visited
    then acc
    else if cur < length program
           then let visited' = S.insert cur visited
                 in case program !! cur of
                      Op "acc" arg ->
                        execute1 program (cur + 1) (acc + arg) visited'
                      Op "jmp" arg -> execute1 program (cur + arg) acc visited'
                      Op "nop" _ -> execute1 program (cur + 1) acc visited'
           else acc

execute2 :: [Op] -> Int -> Int -> Set Int -> Maybe Int
execute2 program cur acc visited =
  if cur `elem` visited
    then Nothing
    else if cur < length program
           then let visited' = S.insert cur visited
                 in case program !! cur of
                      Op "acc" arg ->
                        execute2 program (cur + 1) (acc + arg) visited'
                      Op "jmp" arg -> execute2 program (cur + arg) acc visited'
                      Op "nop" _ -> execute2 program (cur + 1) acc visited'
           else return acc

repair :: [Op] -> Int -> [Op]
repair (p:ps) 0 =
  case p of
    Op "acc" arg -> p : ps
    Op "jmp" arg -> Op "nop" arg : ps
    Op "nop" arg -> Op "jmp" arg : ps
repair (p:ps) n = p : repair (ps) (n - 1)

main :: IO ()
main = do
  ops <- loadOps
  print $ execute1 ops 0 0 S.empty
  let jmps = [i | (i, op) <- zipWith (,) [0 ..] ops, opName op == "jmp"]
  let nops = [i | (i, op) <- zipWith (,) [0 ..] ops, opName op == "nop"]
  let targets = jmps ++ nops
  let programs = [repair ops i | i <- targets]
  flip mapM_ programs $ \x -> do
    case execute2 x 0 0 S.empty of
      Just i -> print i
      Nothing -> return ()
