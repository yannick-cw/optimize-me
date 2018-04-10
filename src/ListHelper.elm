module ListHelper exposing (..)


find : (a -> Bool) -> List a -> Maybe a
find cond l =
    l |> List.filter (\ele -> cond ele) |> List.head
