module Triangle exposing (rows)


rows : Int -> List (List Int)
rows i =
    let
        build n row =
            if n == 0 then
                [ row ]

            else
                row :: build (n - 1) (List.map2 (+) (0 :: row) (row ++ [ 0 ]))
    in
    if i <= 0 then
        []

    else
        build (i - 1) [ 1 ]
