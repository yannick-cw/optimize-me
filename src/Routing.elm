module Routing exposing (Route(..), parseLocation)

import Navigation exposing (Location)
import UrlParser exposing (map, top, Parser, parsePath, oneOf, s, (</>), string)
import Sports exposing (Sport)


type Route
    = Home
    | Track
    | TrackSport Sport
    | NotFoundRoute


type alias ValidSports =
    List String


matchers : ValidSports -> Parser (Route -> a) a
matchers validSports =
    oneOf
        [ map Home top
        , map Track (s "track")
        , map (checkIfSport validSports) (s "track" </> string)
        ]


checkIfSport : ValidSports -> String -> Route
checkIfSport validSports sport =
    validSports
        |> List.filter (\s -> (String.toLower s) == (String.toLower sport))
        |> List.head
        |> Maybe.map TrackSport
        |> Maybe.withDefault NotFoundRoute


parseLocation : ValidSports -> Location -> Route
parseLocation validSports location =
    case (parsePath (matchers validSports) location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
