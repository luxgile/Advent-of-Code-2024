import Data.List

main = do
  contents <- readFile "day_01.txt"
  print $ solution contents

solution :: String -> Int
solution input =
  let xs = lines input
      lefts = sort $ map (read . head . words) xs
      rights = sort $ map (read . last . words) xs
   in sum $ zipWith (\l r -> abs (l - r)) lefts rights