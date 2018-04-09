module Routing exposing (Route(..), parseLocation)

import Navigation exposing (Location)
import UrlParser exposing (map, top, Parser, parsePath, oneOf, s, (</>), string)


type Route
    = Home
    | Track
    | TrackSport String
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Home top
        , map Track (s "track")
        , map TrackSport (s "track" </> string)
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parsePath matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
