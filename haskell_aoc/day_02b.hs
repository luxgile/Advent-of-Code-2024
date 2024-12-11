type Level = Int

type Report = [Level]

data Direction = Increasing | Decreasing deriving (Show, Eq, Enum)

first (x, y, z) = x

third (x, y, z) = x

getDirection x y = if x < y then Increasing else Decreasing

checkPairSafe dir x y = isDiffOk && isNotEq && isDirOk
  where
    isDiffOk = abs (x - y) <= 3
    isNotEq = x /= y
    isDirOk = getDirection x y == dir

isReportSafeStart report@(x : y : xs) = isReportSafe report (getDirection x y) True

-- Is Safe and SafeNet
isReportSafe :: Report -> Direction -> Bool -> (Bool, Bool)
isReportSafe (x : y : z : xs) direction safeNet
  | checkPairSafe direction x y = isReportSafe (y : xs) direction safeNet
  | checkPairSafe direction x z && safeNet = isReportSafe (z : xs) direction False
  | otherwise = (False, safeNet)
isReportSafe (x : xs) _ s = (True, s)
isReportSafe [] _ s = (True, s)

parseReport :: String -> Report
parseReport line = map read (words line) :: Report

parseReports :: String -> [Report]
parseReports text = map parseReport (lines text)

main = do
  -- contents <- readFile "day_02.txt"
  let contents = "7 6 4 2 1 \n 8 6 4 4 1 \n 1 2 7 8 9"
  print $ foldr ((\x acc -> if x then acc + 1 else acc) . fst . isReportSafeStart) 0 (parseReports contents)
