module SpaceAge (Planet (..), ageOn) where

import Data.Map ((!), Map)
import qualified Data.Map as Map

data Planet
  = Mercury
  | Venus
  | Earth
  | Mars
  | Jupiter
  | Saturn
  | Uranus
  | Neptune
  deriving (Eq, Ord)

orbitalPeriods :: Map Planet Float
orbitalPeriods =
  Map.fromList
    [ (Mercury, 0.2408467),
      (Venus, 0.61519726),
      (Earth, 1.0),
      (Mars, 1.8808158),
      (Jupiter, 11.862615),
      (Saturn, 29.447498),
      (Uranus, 84.016846),
      (Neptune, 164.79132)
    ]

earthYear :: Float
earthYear = 31557600

ageOn :: Planet -> Float -> Float
ageOn planet = (/ orbitalPeriods ! planet) . (/ earthYear)
