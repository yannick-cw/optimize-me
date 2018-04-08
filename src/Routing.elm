module Routing exposing (Route(..), parseLocation)

import Navigation exposing (Location)
import UrlParser exposing (map, top, Parser, parsePath, oneOf)


type Route
    = Track
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Track top
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parsePath matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
