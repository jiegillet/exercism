module ListOps exposing
    ( append
    , concat
    , filter
    , foldl
    , foldr
    , length
    , map
    , reverse
    )


foldr : (a -> b -> b) -> b -> List a -> b
foldr f acc list =
    case list of
        [] ->
            acc

        a :: rest ->
            f a (foldr f acc rest)


foldl : (a -> b -> b) -> b -> List a -> b
foldl f acc list =
    let
        step : a -> (b -> b) -> (b -> b)
        step a fct =
            f a >> fct
    in
    foldr step identity list acc


length : List a -> Int
length =
    foldr (\_ n -> n + 1) 0


reverse : List a -> List a
reverse =
    foldl (::) []


map : (a -> b) -> List a -> List b
map f =
    foldr (f >> (::)) []


filter : (a -> Bool) -> List a -> List a
filter f =
    let
        keep a =
            if f a then
                (::) a

            else
                identity
    in
    foldr keep []


append : List a -> List a -> List a
append xs ys =
    foldr (::) ys xs


concat : List (List a) -> List a
concat =
    foldr append []
