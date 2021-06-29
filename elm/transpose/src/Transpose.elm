module Transpose exposing (transpose)


transpose : List String -> List String
transpose lines =
    if List.all String.isEmpty lines then
        []

    else
        let
            ( column, rest ) =
                getColumn lines

            getColumn =
                List.foldr getFirst ( [], [] )

            getFirst str ( heads, tails ) =
                case String.uncons str of
                    Nothing ->
                        ( Nothing :: heads, "" :: tails )

                    Just ( head, tail ) ->
                        ( Just head :: heads, tail :: tails )

            clean col =
                col
                    |> List.reverse
                    |> dropWhile ((==) Nothing)
                    |> List.reverse
                    |> List.map (Maybe.withDefault ' ')
                    |> String.fromList
        in
        clean column :: transpose rest


dropWhile : (a -> Bool) -> List a -> List a
dropWhile p list =
    case list of
        [] ->
            []

        a :: rest ->
            if p a then
                dropWhile p rest

            else
                list
