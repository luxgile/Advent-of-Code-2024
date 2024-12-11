type Level = Int

type Report = [Level]

data Direction = None | Increasing | Decreasing deriving (Show, Eq, Enum)

isSafe :: Direction -> Report -> (Direction, Bool)
isSafe d (x : y : xs) = if d == None || getDirection == d then (getDirection, isReportSafe) else (None, False)
  where
    getDirection = if x < y then Increasing else Decreasing
    isReportSafe = abs (x - y) <= 3 && x /= y && snd (isSafe getDirection (y : xs))
isSafe d (x : xs) = (None, True)
isSafe d [] = (None, True)

parseReport :: String -> Report
parseReport line = map read (words line) :: Report

parseReports :: String -> [Report]
parseReports text = map parseReport (lines text)

main = do
  contents <- readFile "day_02.txt"
  print $ foldr ((\x acc -> if x then acc + 1 else acc) . snd . isSafe None) 0 (parseReports contents)