module Helper exposing (..)

import Date exposing (Date)


find : (a -> Bool) -> List a -> Maybe a
find cond l =
    l |> List.filter (\ele -> cond ele) |> List.head


join : String -> List String -> String
join seperator list =
    List.foldl (\ele acc -> acc ++ seperator ++ ele) "" list |> String.dropLeft 1


renderDate : Date -> String
renderDate date =
    join "/"
        ([ Date.day >> toString, Date.month >> toString, Date.year >> toString ]
            |> List.map (\f -> f date)
        )
