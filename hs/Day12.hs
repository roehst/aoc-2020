#! runghc

module Main where

data Op = N | S | W | E | L | R | F deriving Show

data Instruction = Instruction { op :: Op, arg :: Int } deriving Show

data Point = Point { px :: Int, py :: Int } deriving Show

parseInstruction :: String -> Instruction
parseInstruction (x:xs) =
    case x of
        'N' -> Instruction N (read xs)
        'S' -> Instruction S (read xs)
        'W' -> Instruction W (read xs)
        'E' -> Instruction E (read xs)
        'L' -> Instruction L (read xs)
        'R' -> Instruction R (read xs)
        'F' -> Instruction F (read xs)

readInputs :: FilePath -> IO [Instruction]
readInputs path = do
    s <- lines <$> readFile path
    return $ map parseInstruction s

moveNorth :: Point -> Int -> Point
moveNorth (Point x y) arg = Point x (y + arg)

moveSouth :: Point -> Int -> Point
moveSouth (Point x y) arg = Point x (y - arg)

moveWest :: Point -> Int -> Point
moveWest (Point x y) arg = Point (x - arg) y

moveEast :: Point -> Int -> Point
moveEast (Point x y) arg = Point (x + arg) y

rotatePoint :: Point -> Int -> Point
rotatePoint (Point x y) degrees = 
    

    let x' = cos' * x - sin' * y in
    let y' = sin' * x + cos' * y in
            Point x' y'

    where 
        cos' = case degrees `mod` 360 of
                    0 -> 1
                    90 -> 0
                    180 -> negate 1
                    270 -> 0
        sin' = case degrees `mod` 360 of
                    0 -> 0
                    90 -> 1
                    180 -> 0
                    270 -> negate 1

navigate :: Point -> Point -> [Instruction] -> IO Point
navigate ship waypoint [] = return ship
navigate ship waypoint (c:cs) = do

    let ship' = case c of
            Instruction N arg -> do
                moveNorth ship arg
            Instruction S arg -> do
                moveSouth ship arg
            Instruction W arg -> do
                moveWest ship arg
            Instruction E arg -> do
                moveEast ship arg
            Instruction L arg -> do
                ship
            Instruction R arg -> do
                ship
            Instruction F arg -> do
                addManyTimes ship waypoint arg

    let waypoint' = case c of
            Instruction N arg -> do
                waypoint
            Instruction S arg -> do
                waypoint
            Instruction W arg -> do
                waypoint
            Instruction E arg -> do
                waypoint
            Instruction L arg -> do
                rotatePoint waypoint arg
            Instruction R arg -> do
                rotatePoint waypoint (negate arg)
            Instruction F arg -> do
                waypoint

    navigate ship' waypoint' cs

navigate' :: Point -> Point -> [Instruction] -> IO Point
navigate' ship waypoint [] = return ship
navigate' ship waypoint (c:cs) = do

    let ship' = case c of
            Instruction N arg -> do
                ship
            Instruction S arg -> do
                ship
            Instruction W arg -> do
                ship
            Instruction E arg -> do
                ship
            Instruction L arg -> do
                ship
            Instruction R arg -> do
                ship
            Instruction F arg -> do
                addManyTimes ship waypoint arg

    let waypoint' = case c of
            Instruction N arg -> do
                moveNorth waypoint arg
            Instruction S arg -> do
                moveSouth waypoint arg
            Instruction W arg -> do
                moveWest waypoint arg
            Instruction E arg -> do
                moveEast waypoint arg
            Instruction L arg -> do
                rotatePoint waypoint arg
            Instruction R arg -> do
                rotatePoint waypoint (negate arg)
            Instruction F arg -> do
                waypoint

    navigate' ship' waypoint' cs

addManyTimes :: Point -> Point -> Int -> Point
addManyTimes (Point a b) (Point c d) n = Point (a + n * c)  (b + n * d)

size :: Point ->  Int
size (Point x y) = abs x + abs y

main :: IO ()
main = do

    instructions <- readInputs "../inputs/Day12.txt"
    
    point <- navigate (Point 0 0) (Point 1 0) instructions

    print $ size point

    point <- navigate' (Point 0 0) (Point 10 1) instructions

    print $ size point

    return ()