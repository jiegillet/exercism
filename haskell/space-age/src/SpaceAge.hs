module SpaceAge (Planet (..), ageOn) where

data Planet
  = Mercury
  | Venus
  | Earth
  | Mars
  | Jupiter
  | Saturn
  | Uranus
  | Neptune

orbitalPeriods :: Planet -> Float
orbitalPeriods Mercury = 0.2408467
orbitalPeriods Venus = 0.61519726
orbitalPeriods Earth = 1.0
orbitalPeriods Mars = 1.8808158
orbitalPeriods Jupiter = 11.862615
orbitalPeriods Saturn = 29.447498
orbitalPeriods Uranus = 84.016846
orbitalPeriods Neptune = 164.79132

earthYear :: Float
earthYear = 31557600

ageOn :: Planet -> Float -> Float
ageOn planet = (/ orbitalPeriods planet) . (/ earthYear)
