module Etl exposing (transform)

import Dict exposing (Dict)


transform : Dict Int (List String) -> Dict String Int
transform =
    let
        move point letters dict =
            List.foldl (\letter -> Dict.insert (String.toLower letter) point) dict letters
    in
    Dict.foldl move Dict.empty
