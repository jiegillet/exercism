module Wordy exposing (..)

import Parser exposing ((|.), (|=), Parser, Trailing(..))


answer : String -> Maybe Int
answer =
    Parser.run mathP >> Result.toMaybe >> Maybe.andThen eval


type Expr
    = Val Int
    | Plus
    | Minus
    | Times
    | DividedBy


eval : List Expr -> Maybe Int
eval list =
    case list of
        [] ->
            Nothing

        (Val n) :: more ->
            evalHelper n more

        _ ->
            Nothing


evalHelper : Int -> List Expr -> Maybe Int
evalHelper n list =
    case list of
        [] ->
            Just n

        Plus :: (Val m) :: more ->
            evalHelper (n + m) more

        Minus :: (Val m) :: more ->
            evalHelper (n - m) more

        Times :: (Val m) :: more ->
            evalHelper (n * m) more

        DividedBy :: (Val m) :: more ->
            evalHelper (n // m) more

        _ ->
            Nothing


mathP : Parser (List Expr)
mathP =
    Parser.sequence
        { start = "What is"
        , separator = ""
        , end = "?"
        , spaces = Parser.spaces
        , item = exprP
        , trailing = Optional
        }


exprP : Parser Expr
exprP =
    Parser.oneOf
        [ Parser.succeed Val |= intP
        , Parser.succeed Plus |. Parser.keyword "plus"
        , Parser.succeed Minus |. Parser.keyword "minus"
        , Parser.succeed Times |. Parser.keyword "multiplied by"
        , Parser.succeed DividedBy |. Parser.keyword "divided by"
        ]


intP : Parser Int
intP =
    Parser.oneOf
        [ Parser.succeed negate
            |. Parser.symbol "-"
            |= Parser.int
        , Parser.int
        ]
