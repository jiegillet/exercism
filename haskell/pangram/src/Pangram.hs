module Pangram (isPangram) where

import Data.Char (toLower)
import qualified Data.Set as Set

isPangram :: String -> Bool
isPangram = go alphabet . map toLower  
  where alphabet = Set.fromList ['a'..'z']

        go left [] = Set.null left
        go left (c : cs) 
          | Set.null left = True
          | otherwise = go (Set.delete c left) cs
