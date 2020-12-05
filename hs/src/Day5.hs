{-# OPTIONS_GHC  -Wall #-}

module Day5 where

-- import Data.List (elemIndex)

decodeRowLocator :: String -> Int
decodeRowLocator locator = 
    go locator 0 127
    where
        go :: String -> Int -> Int -> Int
        go [] _ upper = upper
        go (c:cs) lower upper =
            case c of 
                'F' -> 
                    let upper' = (lower + upper) `div` 2 in
                        go cs lower upper'
                'B' -> 
                    let lower' = (lower + upper) `div` 2 + 1 in
                        go cs lower' upper
                _ -> error "Invalid symbol in row locator"

decodeColLocator :: String -> Int
decodeColLocator locator =
    go locator 0 7
    where
        go :: String -> Int -> Int -> Int
        go [] lower upper | lower == upper = upper
                          | otherwise = error "Search error"
        go (c:cs) lower upper =
            case c of 
                'L' -> 
                    let upper' = (lower + upper) `div` 2 in
                        go cs lower upper'
                'R' -> 
                    let lower' = (lower + upper) `div` 2 + 1 in
                        go cs lower' upper
                _ -> error "Invalid symbol in row locator"    

decodeLocator :: String -> Int
decodeLocator locator = 
    let rowLocator = take 7 locator in
    let colLocator = reverse $ take 3 $ reverse locator in
    let row = decodeRowLocator rowLocator in
    let col = decodeColLocator colLocator in
        row * 8 + col

day5 :: IO ()
day5 = do

    locators <- lines <$> readFile "../inputs/Day5.txt"

    let seatIDs = map decodeLocator locators

    let highest = maximum seatIDs

    let mySeat = findMySeat seatIDs

    print highest
    
    print mySeat

    where

        findMySeat ids =
            let lowest = minimum ids in
            let highest = maximum ids in
                head [i | i <- [lowest..highest], i `notElem` ids]
         