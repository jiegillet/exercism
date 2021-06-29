module Acronym (abbreviate) where

import Data.Char (isUpper, toUpper)

abbreviate :: String -> String
abbreviate = snd . foldr split (Nothing ,[])
  where
    split char (initial, acronym)
      | char `elem` " ,-_" = (Nothing, maybe id (:) initial $ acronym)
      | isUpper char = (Nothing, char : acronym)
      | otherwise = (Just (toUpper char), acronym)
