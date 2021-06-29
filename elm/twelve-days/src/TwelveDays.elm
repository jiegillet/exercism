module TwelveDays exposing (recite)

import Html


main =
    Html.text (verse 12)


recite : Int -> Int -> List String
recite start stop =
    List.range start stop
        |> List.map verse


verse : Int -> String
verse n =
    String.concat
        [ "On the "
        , nth n
        , " day of Christmas my true love gave to me: "
        , List.range 2 n
            |> List.reverse
            |> List.map gift
            |> String.join ", "
        , if n == 1 then
            ""

          else
            ", and "
        , gift 1
        , "."
        ]


gift : Int -> String
gift n =
    case n of
        1 ->
            "a Partridge in a Pear Tree"

        2 ->
            "two Turtle Doves"

        3 ->
            "three French Hens"

        4 ->
            "four Calling Birds"

        5 ->
            "five Gold Rings"

        6 ->
            "six Geese-a-Laying"

        7 ->
            "seven Swans-a-Swimming"

        8 ->
            "eight Maids-a-Milking"

        9 ->
            "nine Ladies Dancing"

        10 ->
            "ten Lords-a-Leaping"

        11 ->
            "eleven Pipers Piping"

        _ ->
            "twelve Drummers Drumming"


nth : Int -> String
nth n =
    case n of
        1 ->
            "first"

        2 ->
            "second"

        3 ->
            "third"

        4 ->
            "fourth"

        5 ->
            "fifth"

        6 ->
            "sixth"

        7 ->
            "seventh"

        8 ->
            "eighth"

        9 ->
            "ninth"

        10 ->
            "tenth"

        11 ->
            "eleventh"

        _ ->
            "twelfth"
