module Allergies exposing (Allergy(..), isAllergicTo, toList)

import Bitwise


type Allergy
    = Eggs
    | Peanuts
    | Shellfish
    | Strawberries
    | Tomatoes
    | Chocolate
    | Pollen
    | Cats


isAllergicTo : Allergy -> Int -> Bool
isAllergicTo allergy score =
    let
        value =
            case allergy of
                Eggs ->
                    1

                Peanuts ->
                    2

                Shellfish ->
                    4

                Strawberries ->
                    8

                Tomatoes ->
                    16

                Chocolate ->
                    32

                Pollen ->
                    64

                Cats ->
                    128
    in
    Bitwise.and score value > 0


allergyScores : List ( Int, Allergy )
allergyScores =
    [ ( 1, Eggs )
    , ( 2, Peanuts )
    , ( 4, Shellfish )
    , ( 8, Strawberries )
    , ( 16, Tomatoes )
    , ( 32, Chocolate )
    , ( 64, Pollen )
    , ( 128, Cats )
    ]


toList : Int -> List Allergy
toList score =
    List.filterMap
        (\( code, allergen ) ->
            if Bitwise.and score code > 0 then
                Just allergen

            else
                Nothing
        )
        allergyScores
